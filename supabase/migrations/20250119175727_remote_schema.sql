create type "public"."workspace_role" as enum ('owner', 'member');

create table "public"."workspace_members" (
    "workspace_id" text not null,
    "user_id" uuid not null,
    "role" workspace_role not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
);


create table "public"."workspaces" (
    "id" text not null,
    "name" text not null,
    "description" text,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "color" text not null default concat('hsl(', (floor((random() * (360)::double precision)))::text, ', 85%, 45%)')
);


alter table "public"."workspaces" enable row level security;

CREATE UNIQUE INDEX workspace_members_pkey ON public.workspace_members USING btree (workspace_id, user_id);

CREATE UNIQUE INDEX workspaces_pkey ON public.workspaces USING btree (id);

alter table "public"."workspace_members" add constraint "workspace_members_pkey" PRIMARY KEY using index "workspace_members_pkey";

alter table "public"."workspaces" add constraint "workspaces_pkey" PRIMARY KEY using index "workspaces_pkey";

alter table "public"."workspace_members" add constraint "workspace_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."workspace_members" validate constraint "workspace_members_user_id_fkey";

alter table "public"."workspace_members" add constraint "workspace_members_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE CASCADE not valid;

alter table "public"."workspace_members" validate constraint "workspace_members_workspace_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_workspace(workspace_id text, workspace_name text, owner_id uuid DEFAULT auth.uid())
 RETURNS TABLE(id text, name text, description text, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    new_workspace workspaces;
begin
    -- Create workspace and add owner in a transaction
    insert into workspaces (id, name)
    values (workspace_id, workspace_name)
    returning * into new_workspace;

    insert into workspace_members (workspace_id, user_id, role)
    values (new_workspace.id, owner_id, 'owner');

    return query select
        new_workspace.id,
        new_workspace.name,
        new_workspace.created_at,
        new_workspace.updated_at;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.create_workspace_with_owner(workspace_id text, workspace_name text, workspace_description text DEFAULT NULL::text, owner_id uuid DEFAULT auth.uid())
 RETURNS TABLE(id text, name text, description text, created_at timestamp with time zone, updated_at timestamp with time zone)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    new_workspace workspaces;
begin
    -- Create workspace and add owner in a transaction
    insert into workspaces (id, name, description)
    values (workspace_id, workspace_name, workspace_description)
    returning * into new_workspace;

    insert into workspace_members (workspace_id, user_id, role)
    values (new_workspace.id, owner_id, 'owner');

    return query select
        new_workspace.id,
        new_workspace.name,
        new_workspace.description,
        new_workspace.created_at,
        new_workspace.updated_at;
end;
$function$
;

grant delete on table "public"."workspace_members" to "anon";

grant insert on table "public"."workspace_members" to "anon";

grant references on table "public"."workspace_members" to "anon";

grant select on table "public"."workspace_members" to "anon";

grant trigger on table "public"."workspace_members" to "anon";

grant truncate on table "public"."workspace_members" to "anon";

grant update on table "public"."workspace_members" to "anon";

grant delete on table "public"."workspace_members" to "authenticated";

grant insert on table "public"."workspace_members" to "authenticated";

grant references on table "public"."workspace_members" to "authenticated";

grant select on table "public"."workspace_members" to "authenticated";

grant trigger on table "public"."workspace_members" to "authenticated";

grant truncate on table "public"."workspace_members" to "authenticated";

grant update on table "public"."workspace_members" to "authenticated";

grant delete on table "public"."workspace_members" to "service_role";

grant insert on table "public"."workspace_members" to "service_role";

grant references on table "public"."workspace_members" to "service_role";

grant select on table "public"."workspace_members" to "service_role";

grant trigger on table "public"."workspace_members" to "service_role";

grant truncate on table "public"."workspace_members" to "service_role";

grant update on table "public"."workspace_members" to "service_role";

grant delete on table "public"."workspaces" to "anon";

grant insert on table "public"."workspaces" to "anon";

grant references on table "public"."workspaces" to "anon";

grant select on table "public"."workspaces" to "anon";

grant trigger on table "public"."workspaces" to "anon";

grant truncate on table "public"."workspaces" to "anon";

grant update on table "public"."workspaces" to "anon";

grant delete on table "public"."workspaces" to "authenticated";

grant insert on table "public"."workspaces" to "authenticated";

grant references on table "public"."workspaces" to "authenticated";

grant select on table "public"."workspaces" to "authenticated";

grant trigger on table "public"."workspaces" to "authenticated";

grant truncate on table "public"."workspaces" to "authenticated";

grant update on table "public"."workspaces" to "authenticated";

grant delete on table "public"."workspaces" to "service_role";

grant insert on table "public"."workspaces" to "service_role";

grant references on table "public"."workspaces" to "service_role";

grant select on table "public"."workspaces" to "service_role";

grant trigger on table "public"."workspaces" to "service_role";

grant truncate on table "public"."workspaces" to "service_role";

grant update on table "public"."workspaces" to "service_role";

create policy "Owners can delete workspace members"
on "public"."workspace_members"
as permissive
for delete
to public
using ((EXISTS ( SELECT 1
   FROM workspace_members members
  WHERE ((members.workspace_id = members.workspace_id) AND (members.user_id = auth.uid()) AND (members.role = 'owner'::workspace_role)))));


create policy "Owners can update workspace members"
on "public"."workspace_members"
as permissive
for update
to public
using ((EXISTS ( SELECT 1
   FROM workspace_members members
  WHERE ((members.workspace_id = members.workspace_id) AND (members.user_id = auth.uid()) AND (members.role = 'owner'::workspace_role)))));


create policy "Owners can view workspace members"
on "public"."workspace_members"
as permissive
for select
to public
using ((EXISTS ( SELECT 1
   FROM workspace_members members
  WHERE ((members.workspace_id = members.workspace_id) AND (members.user_id = auth.uid()) AND (members.role = 'owner'::workspace_role)))));


create policy "Users can create their own memberships"
on "public"."workspace_members"
as permissive
for insert
to authenticated
with check ((user_id = auth.uid()));


create policy "Users can view their own memberships"
on "public"."workspace_members"
as permissive
for select
to public
using ((auth.uid() = user_id));


create policy "Allow authenticated users to insert into workspaces"
on "public"."workspaces"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable insert for authenticated users only"
on "public"."workspaces"
as permissive
for insert
to authenticated
with check (true);


create policy "Users can view workspaces they are members of"
on "public"."workspaces"
as permissive
for select
to authenticated
using ((EXISTS ( SELECT 1
   FROM workspace_members
  WHERE ((workspace_members.workspace_id = workspaces.id) AND (workspace_members.user_id = auth.uid())))));



