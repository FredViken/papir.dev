<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { scrollY } from 'svelte/reactivity/window';
	import '../app.css';
	let { children } = $props();

	let isScrolled = $derived(scrollY.current ? scrollY.current > 100 : false);
</script>

<nav class="fixed left-0 right-0 top-0 z-50 w-full duration-300 {isScrolled ? 'bg-background/75 backdrop-blur-sm' : ''}">
	<div class="container flex h-16 items-center justify-between">
		<div class="flex items-center gap-2">
			<div
				class="flex size-8 items-center justify-center rounded-sm bg-primary font-bold text-white"
			>
				P
			</div>
			<span class="text-xl font-bold">Papir.dev</span>
		</div>
		<div class="items-center gap-6 text-muted-foreground hidden sm:flex">

			<a href="/">Home</a>
			<a href="/pricing">Pricing</a>
			<a href="/docs">Docs</a>
			<a href="/blog">Blog</a>
		</div>
		<div class="flex items-center gap-4">
			<Button variant="outline">Login</Button>
			<Button>Get started</Button>
		</div>
	</div>
</nav>
{@render children()}
