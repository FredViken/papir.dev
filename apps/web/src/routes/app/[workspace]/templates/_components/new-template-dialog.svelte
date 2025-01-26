<script lang="ts">
	import { createTemplateSchema, type CreateTemplateSchema } from './create-template-schema';
	import * as Dialog from '$components/ui/dialog';
	import { superForm, type Infer, type SuperForm, type SuperValidated } from 'sveltekit-superforms';
	import { Button, buttonVariants } from '$components/ui/button';
	import { zodClient } from 'sveltekit-superforms/adapters';

	import * as Form from '$components/ui/form';
	import { Input } from '$components/ui/input';
	import { slugify } from '$lib/utils/slugify';
	import { redirect } from '@sveltejs/kit';
	import { page } from '$app/state';
	import { toast } from 'svelte-sonner';
	import { goto, invalidateAll } from '$app/navigation';

	interface Props {
		form: SuperValidated<Infer<CreateTemplateSchema>>;
		open: boolean;
	}

	let { form: formProps, open = $bindable() }: Props = $props();

	const form = superForm(formProps, {
		validators: zodClient(createTemplateSchema),
    onResult: ({result}) => {
      if (result.type === 'success') {
        console.log(result);
        open = false;
        toast.success('Template created');
        if (result.data) {
          goto(`/app/${page.params.workspace}/templates/${result.data.form.data.slug}`);
        } else {
          invalidateAll();
        }
      }
    }
	});

	const { form: formData, enhance, errors, delayed, submitting } = form;

	function generateSlug(name: string) {
		$formData.slug = slugify(name);
	}
</script>

<Dialog.Root bind:open>
	<Dialog.Content>
		<Dialog.Header>
			<Dialog.Title>Create Template</Dialog.Title>
		</Dialog.Header>

		<form method="post" use:enhance>
			<div class="flex flex-col gap-4 p-6">
				<Form.Field {form} name="name">
					<Form.Control>
						{#snippet children({ props })}
							<Form.Label>Template name</Form.Label>
							<Input
								oninput={() => generateSlug($formData.name)}
								{...props}
								bind:value={$formData.name}
							/>
						{/snippet}
					</Form.Control>
					<Form.FieldErrors />
				</Form.Field>
				<Form.Field {form} name="slug">
					<Form.Control>
						{#snippet children({ props })}
							<Form.Label>API slug</Form.Label>
							<Input {...props} bind:value={$formData.slug} />
						{/snippet}
					</Form.Control>
					<Form.Description>A unique identifier for the template for API requests.</Form.Description
					>
					<Form.FieldErrors />
				</Form.Field>
      </div>

				<Dialog.Footer>
					<Dialog.Close class={buttonVariants({ variant: 'outline' })}>Cancel</Dialog.Close>
					<Button type="submit" loading={$delayed || $submitting} loadingText="Creating...">Create template</Button
					>
				</Dialog.Footer>
		</form>
	</Dialog.Content>
</Dialog.Root>
