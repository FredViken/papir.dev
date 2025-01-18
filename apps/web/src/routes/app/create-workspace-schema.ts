import { z } from 'zod';

export const createWorkspaceSchema = z.object({
    name: z.string()
        .min(3, 'Name must be at least 3 characters')
        .max(50, 'Name must be less than 50 characters'),
    slug: z.string()
        .min(3, 'Slug must be at least 3 characters')
        .max(50, 'Slug must be less than 50 characters')
        .regex(/^[a-z0-9-]+$/, 'Slug can only contain lowercase letters, numbers, and hyphens'),
    description: z.string()
        .max(500, 'Description must be less than 500 characters')
        .optional()
}); 