import { z } from 'zod';

export const createTemplateSchema = z.object({
    name: z
        .string()
        .min(3, 'Name must be at least 3 characters')
        .max(50, 'Name must be less than 50 characters'),
    slug: z
        .string()
        .min(3, 'Slug must be at least 3 characters')
        .max(50, 'Slug must be less than 50 characters')
        .regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/, 'Slug must be in kebab-case format'),
}); 

export type CreateTemplateSchema = typeof createTemplateSchema;