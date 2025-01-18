<script lang="ts">
	import * as Dialog from '$lib/components/ui/dialog';
	import * as Form from '$lib/components/ui/form';
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { createWorkspaceSchema } from './create-workspace-schema';
	import { superForm } from 'sveltekit-superforms';
	import type { PageData } from './$types';
	import { zodClient } from 'sveltekit-superforms/adapters';

	let { data } = $props<{ data: PageData }>();
	let dialogOpen = $state(false);

	const form = superForm(data.form, {
		validators: zodClient(createWorkspaceSchema)
	});

    const { form: formData, enhance, errors } = form;
</script>

<div class="container mx-auto py-8">
	<div class="mb-8">
		<h1 class="text-3xl font-bold">Select a Workspace</h1>
		<p class="text-muted-foreground">Choose a workspace or create a new one to get started.</p>
	</div>

	{#if data.workspaces?.length}
		<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
			{#each data.workspaces as workspace}
				<a
					href="/app/{workspace.slug}"
					class="group relative rounded-lg border p-6 transition-all hover:shadow-md"
				>
					<h2 class="font-semibold group-hover:text-brand">{workspace.name}</h2>
					{#if workspace.description}
						<p class="mt-1 text-sm text-muted-foreground">{workspace.description}</p>
					{/if}
				</a>
			{/each}
		</div>
	{:else}
		<div class="py-12 text-center">
			<h3 class="text-lg font-medium">No workspaces yet</h3>
			<p class="mt-1 text-muted-foreground">Create your first workspace to get started.</p>
		</div>
	{/if}

	<Button onclick={() => (dialogOpen = true)} class="mt-8">Create Workspace</Button>

	<Dialog.Root bind:open={dialogOpen}>
		<Dialog.Content class="sm:max-w-[425px]">
			<Dialog.Header>
				<Dialog.Title>Create Workspace</Dialog.Title>
				<Dialog.Description>
					Create a new workspace to organize your templates and collaborate with others.
				</Dialog.Description>
			</Dialog.Header>

			<form method="POST" use:enhance class="space-y-4">
				<Form.Field {form} name="name">
					<Form.Control>
						{#snippet children({ props })}
							<Form.Label>Name</Form.Label>
							<Input {...props} placeholder="Acme Inc." />
						{/snippet}
					</Form.Control>
					<Form.Description>This is your workspace's visible name.</Form.Description>
					<Form.FieldErrors />
				</Form.Field>

				<Form.Field {form} name="slug">
					<Form.Control>
						{#snippet children({ props })}
							<Form.Label>Slug</Form.Label>
							<Input {...props} placeholder="acme" />
						{/snippet}
					</Form.Control>
					<Form.Description>
						This will be used in URLs. Use lowercase letters, numbers, and hyphens only.
					</Form.Description>
					<Form.FieldErrors />
				</Form.Field>

				<Form.Field {form} name="description">
					<Form.Control>
						{#snippet children({ props })}
							<Form.Label>Description</Form.Label>
							<Input {...props} placeholder="A brief description of your workspace" />
						{/snippet}
					</Form.Control>
					<Form.Description>Optional description for your workspace.</Form.Description>
					<Form.FieldErrors />
				</Form.Field>

				<Dialog.Footer>
					<Button type="button" variant="outline" onclick={() => (dialogOpen = false)}>
						Cancel
					</Button>
					<Button type="submit">Create</Button>
				</Dialog.Footer>
			</form>
		</Dialog.Content>
	</Dialog.Root>
</div>
