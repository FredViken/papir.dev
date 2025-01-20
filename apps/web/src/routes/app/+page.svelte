<script lang="ts">
	import * as Dialog from '$lib/components/ui/dialog';
	import * as Form from '$lib/components/ui/form';
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input';
	import { createWorkspaceSchema } from './create-workspace-schema';
	import { superForm } from 'sveltekit-superforms';
	import type { PageData } from './$types';
	import { zodClient } from 'sveltekit-superforms/adapters';
	import Icon from '$ui/icon/icon.svelte';

	let { data }: { data: PageData } = $props();

	let dialogOpen = $state(false);

	const form = superForm(data.form, {
		validators: zodClient(createWorkspaceSchema),
		onResult: ({ result }) => {
			// Close dialog on success
			if (result.type === 'success') {
				dialogOpen = false;
			}
		},

		onError: ({ result }) => {
			console.log(result);
		}
	});

	const { form: formData, enhance, errors,delayed } = form;
</script>

<svelte:head>
	<title>Workspaces</title>
</svelte:head>

<div class="mx-auto max-w-lg px-6 py-16">
	<h1 class="text-xl font-bold">Your workspaces</h1>
	<p class="text-muted-foreground">
		Choose a workspace or create a new one to get started with your PDF templates.
	</p>
	{#if data.workspaces?.length}
	<ul class="mt-4 space-y-2">
		{#each data.workspaces as workspace}
			<li>
				{@render item(workspace)}
			</li>
		{/each}
		</ul>
	{:else}
		<div class="mt-4 rounded-md border border-dashed bg-muted/40 p-4 py-8 text-center">
			<Icon name="house" class="text-xl text-muted-foreground" />
			<h2 class="mt-4 text-lg font-semibold">No workspaces yet</h2>
			<p class="mt-2 text-sm text-muted-foreground text-balance">Create your first workspace to get started with your PDF templates.</p>
		
		</div>
	{/if}

	<Button onclick={() => (dialogOpen = true)} variant="outline" class="mt-8 w-full" size="lg">
		<Icon name="plus" class="mr-2 size-4" />
		Create Workspace
	</Button>
</div>

{#snippet item(workspace: PageData['workspaces'][number])}
	{@const role = workspace.workspace_members.find((member) => member.user_id === data.user?.id)?.role}
	<a
		href="/app/{workspace.id}"
		class="group flex items-center gap-4 rounded-md border p-4 hover:bg-accent duration-200 shadow-sm"
	>
		<div
			class="flex size-10 items-center justify-center border rounded-lg"
			style="
				background-color: {workspace.color.replace(')', ', 10%)')};
				color: {workspace.color.replace('45%)', '35%)')};
				border-color: {workspace.color.replace(')', ', 100%)')};
			"
		>
			<Icon name="house" type="solid" />
		</div>
		<div class="flex flex-col">
			<h2 class="font-semibold">{workspace.name}</h2>
			<p class="text-sm text-muted-foreground">
				<Icon name={role == 'owner' ? 'crown' : 'users'} class="size-4" />
				{role == 'owner' ? 'Owner' : 'Member'} • {workspace.workspace_members.length} member{workspace.workspace_members.length == 1 ? '' : 's'}
			</p>
		</div>
	</a>
{/snippet}



<Dialog.Root bind:open={dialogOpen}>
	<Dialog.Content class="sm:max-w-[425px]">
		<Dialog.Header>
			<Dialog.Title>Create Workspace</Dialog.Title>
			<!-- <Dialog.Description>
				Create a new workspace to organize your templates and collaborate with others.
			</Dialog.Description> -->
		</Dialog.Header>

		<form method="POST" use:enhance>
			<div class="p-6">
				<Form.Field {form} name="name">
					<Form.Control>
						{#snippet children({ props })}
							<Form.Label>Name</Form.Label>
							<Input {...props} bind:value={$formData.name} placeholder="Acme Inc." />
						{/snippet}
					</Form.Control>
					<Form.Description>This is your workspace's visible name.</Form.Description>
					<Form.FieldErrors />
				</Form.Field>

				{#if $errors}
					<div class="mt-4">
						<p class="text-sm text-red-500">{$errors.name}</p>
					</div>
				{/if}
			</div>

			<Dialog.Footer>
				<Button type="button" variant="outline" onclick={() => (dialogOpen = false)}>Cancel</Button>
				<Button type="submit" loading={$delayed} loadingText="Creating...">Create</Button>
			</Dialog.Footer>
		</form>
	</Dialog.Content>
</Dialog.Root>
<!-- </div> -->
