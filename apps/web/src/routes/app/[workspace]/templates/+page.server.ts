import type { PageServerLoad } from './$types';
import type { Tables } from '$db';
import { createTemplateSchema } from '$lib/schemas/template';
import { fail, redirect } from '@sveltejs/kit';
import { message, superValidate } from 'sveltekit-superforms/server';
import { zod } from 'sveltekit-superforms/adapters';

export const load: PageServerLoad = async ({ locals: { supabase }, params, depends }) => {
	depends('supabase:db:templates');
	type Template = Tables<'templates'>;

	const [{ data: templates }, form] = await Promise.all([
		supabase
			.from('templates')
			.select('*')
			.eq('workspace_id', params.workspace)
			.order('created_at', { ascending: false })
			.returns<Template[]>(),
		superValidate(zod(createTemplateSchema))
	]);

	return {
		templates: templates || [],
		form
	};
};

export const actions = {
	default: async ({ request, locals: { supabase }, params }) => {
		const form = await superValidate(request, zod(createTemplateSchema));

		if (!form.valid) {
			return fail(400, { form });
		}

		// Check if slug is already taken
		const { count } = await supabase
			.from('templates')
			.select('*', { count: 'exact', head: true })
			.eq('workspace_id', params.workspace)
			.eq('slug', form.data.slug);

		if (count && count > 0) {
			return message(form, 'A template with this slug already exists', { status: 400 });
		}

		// Create template
		const { error: templateError } = await supabase.from('templates').insert({
			workspace_id: params.workspace,
			name: form.data.name,
			slug: form.data.slug,
			description: form.data.description,
			content: '<h1>{{title}}</h1>', // Default template
			schema: {
				type: 'object',
				properties: {
					title: { type: 'string' }
				},
				required: ['title']
			}
		});

		if (templateError) {
			console.error(templateError);
			return message(form, 'Failed to create template. Please try again.', { status: 500 });
		}

		return redirect(302, `/app/${params.workspace}/templates/${form.data.slug}`);
	}
};
