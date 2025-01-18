-- Create workspaces table
create table public.workspaces (
    id uuid default gen_random_uuid() primary key,
    name text not null,
    slug text not null unique,
    description text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create workspace_members table with role enum
create type workspace_role as enum ('owner', 'member');

create table public.workspace_members (
    workspace_id uuid references public.workspaces(id) on delete cascade,
    user_id uuid references auth.users(id) on delete cascade,
    role workspace_role not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    primary key (workspace_id, user_id)
);

-- Add RLS policies
alter table public.workspaces enable row level security;
alter table public.workspace_members enable row level security;

-- Workspace policies
create policy "Users can view workspaces they are members of"
    on workspaces for select
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = workspaces.id
            and workspace_members.user_id = auth.uid()
        )
    );

create policy "Workspace owners can update their workspaces"
    on workspaces for update
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = workspaces.id
            and workspace_members.user_id = auth.uid()
            and workspace_members.role = 'owner'
        )
    );

create policy "Authenticated users can create workspaces"
    on workspaces for insert
    to authenticated
    with check (true);

-- Workspace member policies
create policy "Users can view members of their workspaces"
    on workspace_members for select
    using (
        exists (
            select 1
            from workspace_members my_membership
            where my_membership.workspace_id = workspace_members.workspace_id
            and my_membership.user_id = auth.uid()
        )
    );

create policy "Workspace owners can manage members"
    on workspace_members for all
    using (
        exists (
            select 1
            from workspace_members
            where workspace_members.workspace_id = workspace_members.workspace_id
            and workspace_members.user_id = auth.uid()
            and workspace_members.role = 'owner'
        )
    );

create policy "Users can join workspaces"
    on workspace_members for insert
    to authenticated
    with check (user_id = auth.uid()); 