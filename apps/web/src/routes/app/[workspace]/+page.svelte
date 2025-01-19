<script>
	import Icon from '$components/ui/icon/icon.svelte';

	let { data } = $props();
</script>

<div class="container mx-auto max-w-7xl px-6 py-16">
	<a href="/app" class="text-muted-foreground hover:text-foreground transition-colors">
		<Icon name="chevron-left" />
		Back
	</a>
	<h1>{data.workspace.name}</h1>
</div>
