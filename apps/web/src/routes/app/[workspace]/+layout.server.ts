import { error } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';
import type { Tables } from '$db';

export const load: LayoutServerLoad = async ({ params, locals: { supabase, user } }) => {
	type Workspace = Tables<'workspaces'> & { workspace_members: Tables<'workspace_members'>[] };

	// Get current workspace and check membership
	const { data: workspace } = await supabase
		.from('workspaces')
		.select('*, workspace_members(*)')
		.eq('id', params.workspace)
		.returns<Workspace[]>()
		.single();

	if (!workspace) {
		throw error(404, 'Workspace not found');
	}

	// Check if user is a member
	const isMember = workspace.workspace_members.some((member) => member.user_id === user?.id);
	if (!isMember) {
		throw error(403, 'You do not have access to this workspace');
	}

	// Get all workspaces for the switcher
	const { data: workspaces } = await supabase
		.from('workspaces')
		.select('*, workspace_members!inner(*)')
		.eq('workspace_members.user_id', user?.id)
		.returns<Workspace[]>();

	return {
		workspace,
		workspaces: workspaces || []
	};
}; 