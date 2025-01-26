-- Create templates table
create table public.templates (
    workspace_id text references public.workspaces(id) on delete cascade,
    slug text not null check (slug ~* '^[a-z0-9]+(?:-[a-z0-9]+)*$'), -- Enforce kebab-case
    name text not null,
    description text,
    content text not null, -- Store HTML template as text
    schema jsonb not null default '{
        "type": "object",
        "properties": {},
        "required": []
    }'::jsonb, -- JSON Schema for template variables
    version integer not null default 1,
    is_published boolean not null default false,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
    primary key (workspace_id, slug)
);

-- Create update timestamp function
create or replace function update_timestamp()
returns trigger as $$
begin
    new.updated_at = timezone('utc'::text, now());
    return new;
end;
$$ language plpgsql;

-- Add RLS policies
alter table public.templates enable row level security;

-- Template policies
create policy "Users can view templates in their workspaces"
    on templates for select
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = templates.workspace_id
            and workspace_members.user_id = auth.uid()
        )
    );

create policy "Workspace members can create templates"
    on templates for insert
    with check (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = templates.workspace_id
            and workspace_members.user_id = auth.uid()
        )
    );

create policy "Workspace members can update templates"
    on templates for update
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = templates.workspace_id
            and workspace_members.user_id = auth.uid()
        )
    );

create policy "Workspace members can delete templates"
    on templates for delete
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = templates.workspace_id
            and workspace_members.user_id = auth.uid()
        )
    );

-- Add template versioning table for history
create table public.template_versions (
    workspace_id text not null,
    template_slug text not null,
    version integer not null,
    content text not null,
    schema jsonb not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    created_by uuid references auth.users(id) on delete set null,
    primary key (workspace_id, template_slug, version),
    foreign key (workspace_id, template_slug) references templates(workspace_id, slug) on delete cascade
);

-- Add RLS policies for versions
alter table public.template_versions enable row level security;

create policy "Users can view template versions in their workspaces"
    on template_versions for select
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = template_versions.workspace_id
            and workspace_members.user_id = auth.uid()
        )
    );

-- Function to update template version
create or replace function update_template_version()
returns trigger as $$
begin
    if (old.content != new.content or old.schema != new.schema) then
        -- Insert old version into history
        insert into template_versions (
            workspace_id,
            template_slug,
            version,
            content,
            schema,
            created_by
        ) values (
            old.workspace_id,
            old.slug,
            old.version,
            old.content,
            old.schema,
            auth.uid()
        );
        
        -- Increment version
        new.version = old.version + 1;
        new.updated_at = now();
    end if;
    return new;
end;
$$ language plpgsql security definer;

-- Add trigger for versioning
create trigger template_version_trigger
    before update on templates
    for each row
    execute function update_template_version();

-- Add updated_at trigger
create trigger templates_updated_at_trigger
    before update on templates
    for each row
    execute function update_timestamp(); 