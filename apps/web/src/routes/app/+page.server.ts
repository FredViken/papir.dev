import { createWorkspaceSchema } from './create-workspace-schema';
import { fail, redirect } from '@sveltejs/kit';
import { message, superValidate } from 'sveltekit-superforms/server';
import { zod } from 'sveltekit-superforms/adapters';
import type { PageServerLoad, Actions } from './$types';
import { customAlphabet } from 'nanoid';
import type { Tables } from '$db';

// Create a custom nanoid that uses a URL-friendly alphabet and generates 10-character IDs
const nanoid = customAlphabet('0123456789abcdefghijklmnopqrstuvwxyz', 10);

export const load: PageServerLoad = async ({ locals: { supabase, user } }) => {
	type Workspace = Tables<'workspaces'> & { workspace_members: Tables<'workspace_members'>[] };

	const { data: workspaces } = await supabase
		.from('workspaces')
		.select('*, workspace_members!inner(*)')
		.eq('workspace_members.user_id', user?.id)
		.returns<Workspace[]>();

	return {
		workspaces: workspaces || [],
		form: await superValidate(zod(createWorkspaceSchema))
	};
};

export const actions: Actions = {
	default: async ({ request, locals: { supabase, user } }) => {
		const form = await superValidate(request, zod(createWorkspaceSchema));

		if (!form.valid) {
			return fail(400, { form });
		}

		const id = nanoid();

		type WorkspaceResponse = Pick<
			Tables<'workspaces'>,
			'id' | 'name' | 'description' | 'color' | 'created_at' | 'updated_at'
		>;

		const { data: workspace, error: workspaceError } = await supabase
			.rpc('create_workspace_with_owner', {
				workspace_id: id,
				workspace_name: form.data.name,
				owner_id: user?.id
			})
			.select('id')
			.single();

		if (workspaceError) {
			console.error(workspaceError);
			return message(form, 'Failed to create workspace. Please try again.', { status: 500 });
		}

		return redirect(303, `/app/${workspace.id}`);
	}
};
