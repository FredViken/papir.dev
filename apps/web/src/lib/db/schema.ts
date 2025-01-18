import { z } from 'zod';

export const WorkspaceRole = {
	OWNER: 'owner',
	MEMBER: 'member'
} as const;

export type WorkspaceRole = (typeof WorkspaceRole)[keyof typeof WorkspaceRole];

export const workspaceSchema = z.object({
	id: z.string().uuid().optional(), // Supabase will generate this
	name: z.string().min(3).max(50),
	slug: z.string().min(3).max(50),
	description: z.string().max(500).optional(),
	logo_url: z.string().url().optional(),
	created_at: z.string().datetime().optional(), // Supabase will generate this
	updated_at: z.string().datetime().optional() // Supabase will generate this
});

export const workspaceMemberSchema = z.object({
	workspace_id: z.string().uuid(),
	user_id: z.string().uuid(),
	role: z.enum([WorkspaceRole.OWNER, WorkspaceRole.MEMBER]),
	created_at: z.string().datetime().optional()
});

export type Workspace = z.infer<typeof workspaceSchema>;
export type WorkspaceMember = z.infer<typeof workspaceMemberSchema>; 