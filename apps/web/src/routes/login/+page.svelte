<script lang="ts">
	import Button from '$ui/button/button.svelte';
	import { PUBLIC_BASE_URL } from '$env/static/public';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();
	let email = $state('');

	async function signInWithGithub() {
		await data.supabase.auth.signInWithOAuth({
			provider: 'github',
			options: {
				redirectTo: `${PUBLIC_BASE_URL}/auth/callback`
			}
		});
	}

	async function signInWithGoogle() {
		await data.supabase.auth.signInWithOAuth({
			provider: 'google'
		});
	}

	async function signInWithEmail(e: Event) {
		e.preventDefault();

		const { error } = await data.supabase.auth.signInWithOtp({
			email,
			options: {
				emailRedirectTo: `${location.origin}/auth/callback`
			}
		});

		if (error) {
			console.error('Error:', error.message);
			return;
		}

		email = '';
		// Show success message or handle UI feedback
	}
</script>

<div class="container flex min-h-[calc(100vh-4rem)] items-center justify-center">
	<div class="w-full max-w-sm space-y-8">
		<div class="text-center">
			<h1 class="text-2xl font-bold">Welcome back</h1>
			<p class="text-sm text-muted-foreground">Sign in to your account</p>
		</div>

		<div class="space-y-4">
			<form onsubmit={signInWithEmail} class="space-y-4">
				<div>
					<label for="email" class="text-sm font-medium">Email</label>
					<input
						type="email"
						id="email"
						bind:value={email}
						placeholder="name@example.com"
						required
						class="mt-1.5 w-full rounded-md border bg-background px-3 py-2 text-sm"
					/>
				</div>
				<Button type="submit" class="w-full">Continue with Email</Button>
			</form>

			<div class="relative">
				<div class="absolute inset-0 flex items-center">
					<div class="w-full border-t"></div>
				</div>
				<div class="relative flex justify-center text-xs uppercase">
					<span class="bg-background px-2 text-muted-foreground">Or continue with</span>
				</div>
			</div>

			<div class="grid gap-2">
				<Button variant="outline" onclick={signInWithGithub} class="w-full">
					<i class="fa-brands fa-github text-brand"></i>
					Continue with GitHub
				</Button>
				<Button variant="outline" onclick={signInWithGoogle} class="w-full">
					<i class="fa-brands fa-google text-brand"></i>
					Continue with Google
				</Button>
			</div>
		</div>
	</div>
</div>
