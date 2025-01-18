import { createWorkspaceSchema } from './create-workspace-schema';
import { fail, redirect } from '@sveltejs/kit';
import { superValidate } from 'sveltekit-superforms/server';
import { zod } from 'sveltekit-superforms/adapters';
import type { PageServerLoad, Actions } from './$types';

export const load: PageServerLoad = async ({ locals: { supabase, user } }) => {
	const { data: workspaces } = await supabase
		.from('workspaces')
		.select(
			`
            id,
            name,
            slug,
            description,
            workspace_members!inner (
                role
            )
        `
		)
		.eq('workspace_members.user_id', user?.id);

	return {
		workspaces,
		form: await superValidate(zod(createWorkspaceSchema))
	};
};

export const actions: Actions = {
	default: async ({ request, locals: { supabase, user } }) => {
		const form = await superValidate(request, zod(createWorkspaceSchema));
		
		if (!form.valid) {
			return fail(400, { form });
		}

		const { data: workspace, error: workspaceError } = await supabase
			.from('workspaces')
			.insert({
				name: form.data.name,
				slug: form.data.slug,
				description: form.data.description
			})
			.select()
			.single();

		if (workspaceError) {
			return fail(500, {
				form,
				error: 'Failed to create workspace. Please try again.'
			});
		}

		const { error: memberError } = await supabase.from('workspace_members').insert({
			workspace_id: workspace.id,
			user_id: user?.id,
			role: 'owner'
		});

		if (memberError) {
			return fail(500, {
				form,
				error: 'Failed to setup workspace membership. Please try again.'
			});
		}

		throw redirect(303, `/app/${workspace.slug}`);
	}
};