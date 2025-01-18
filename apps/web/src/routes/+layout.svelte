<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { scrollY } from 'svelte/reactivity/window';
	import '../app.css';
	let { children } = $props();

	let isScrolled = $derived(scrollY.current ? scrollY.current > 100 : false);
</script>

<nav
	class="fixed left-0 right-0 top-0 z-50 w-full duration-300 {isScrolled
		? 'bg-background/75 backdrop-blur-sm'
		: ''}"
>
	<div class="container flex h-16 items-center justify-between">
		<div class="flex items-center gap-2">
			{@render logo()}
			<span class="text-xl font-bold text-brand">Prismer.io</span>
		</div>
		<div class="hidden items-center gap-6 text-muted-foreground sm:flex">
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

{#snippet logo()}
	<img src="/logo.svg" alt="Prismer" class="size-8" />
	<!-- <div class="grid">
		<div class="relative size-6 rotate-45 rounded-sm drop-shadow-md col-start-1 row-start-1">
			<div class="bg-gradient-to-b from-brand/50 to-brand/10 absolute inset-0 h-full w-3/4 rounded-[2px]"></div>
			<div class="bg-gradient-to-l from-brand/50 to-brand/10 absolute bottom-0 h-3/4 w-full rounded-[2px] mix-blend-hard-light"></div>
		</div>
		<div class="relative size-6 rotate-45 rounded-sm drop-shadow-md col-start-1 row-start-1">
			<div class="bg-gradient-to-b from-brand/50 to-brand/10 absolute inset-0 h-full w-3/4 rounded-[2px]"></div>
			<div class="bg-gradient-to-l from-brand/50 to-brand/10 absolute bottom-0 h-3/4 w-full rounded-[2px] mix-blend-hard-light"></div>
		</div>
		
	</div> -->
{/snippet}
