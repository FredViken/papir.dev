<script lang="ts">
	import type { PageData } from './$types';
	import { Button } from '$components/ui/button';
	import Icon from '$components/ui/icon/icon.svelte';
	import NewTemplateDialog from './_components/new-template-dialog.svelte';

	let { data } = $props<{ data: PageData }>();

	let dialogOpen = $state(false);
</script>

<div class="container py-8">
	<div class="mb-8 flex items-center justify-between">
		<div>
			<h1 class="text-2xl font-bold">Templates</h1>
			<p class="text-muted-foreground">Create and manage your PDF templates.</p>
		</div>
		<Button size="sm" onclick={() => (dialogOpen = true)}>
			<Icon name="plus" class="mr-1" />
			New template
		</Button>
	</div>

	{#if data.templates.length}
		<div class="grid gap-4">
			{#each data.templates as template}
				<a
					href={`templates/${template.slug}`}
					class="group flex items-center gap-4 rounded-md border p-4 duration-200 hover:bg-accent"
				>
					<div class="flex min-w-0 flex-1 flex-col">
						<h2 class="truncate font-semibold">{template.name}</h2>
						{#if template.description}
							<p class="truncate text-sm text-muted-foreground">{template.description}</p>
						{/if}
					</div>
					<div class="flex items-center gap-4 text-sm text-muted-foreground">
						<span class="flex items-center gap-2">
							<Icon name={template.is_published ? 'check' : 'clock'} class="size-4" />
							{template.is_published ? 'Published' : 'Draft'}
						</span>
						<Icon name="chevron-right" class="size-4 duration-200 group-hover:translate-x-0.5" />
					</div>
				</a>
			{/each}
		</div>
	{:else}
		<div class="rounded-md border border-dashed bg-muted/40 p-8 text-center">
			<Icon name="file-lines" class="mx-auto text-xl text-muted-foreground" />
			<h2 class="mt-4 text-lg font-semibold">No templates yet</h2>
			<p class="mt-2 text-balance text-sm text-muted-foreground">
				Create your first template to get started with generating PDFs.
			</p>
			<Button onclick={() => (dialogOpen = true)} variant="outline" class="mt-4">
				<Icon name="plus" class="mr-2 size-4" />
				Create Template
			</Button>
		</div>
	{/if}
</div>

<NewTemplateDialog form={data.form} bind:open={dialogOpen} />
