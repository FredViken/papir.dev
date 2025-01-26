<script lang="ts">
	import Button from '$ui/button/button.svelte';
	import { PUBLIC_BASE_URL } from '$env/static/public';
	import type { PageData } from './$types';
	import Input from '$components/ui/input/input.svelte';
	import Icon from '$ui/icon/icon.svelte';
	import { toast } from 'svelte-sonner';

	let { data }: { data: PageData } = $props();
	let email = $state('');
	let loading: null | 'github' | 'google' | 'email' = $state(null);

	async function signInWithGithub() {
		loading = 'github';
		await data.supabase.auth.signInWithOAuth({
			provider: 'github',
			options: {
				redirectTo: `${PUBLIC_BASE_URL}/auth/callback`
			}
		});
	}

	async function signInWithGoogle() {
		loading = 'google';
		await data.supabase.auth.signInWithOAuth({
			provider: 'google'
		});
	}

	async function signInWithEmail(e: Event) {
		e.preventDefault();
		loading = 'email';
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
		toast.success('Email sent');
		loading = null;
	}
</script>

<div class="flex min-h-screen items-center justify-center">
	<div class="w-full max-w-md space-y-8">
		<div class="text-center">
			<h1 class="text-2xl font-bold">Welcome back</h1>
			<p class="text-sm text-muted-foreground">Sign in to your account</p>
		</div>

		<div class="space-y-4">
			<form onsubmit={signInWithEmail} class="space-y-4">
				<div>
					<label for="email" class="text-sm font-medium">Email</label>
					<Input
						type="email"
						id="email"
						bind:value={email}
						placeholder="name@example.com"
						required
						class="mt-1.5 w-full rounded-md border bg-background px-3 py-2 text-sm"
					/>
				</div>
				<Button
					type="submit"
					loading={loading === 'email'}
					loadingText="Signing in with Email..."
					class="w-full"
				>
					Continue with Email
				</Button>
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
				<Button
					loading={loading === 'github'}
					loadingText="Signing in with GitHub..."
					variant="outline"
					onclick={signInWithGithub}
					class="w-full"
				>
					<Icon name="github" type="brands" class="mr-2 text-brand" />
					Continue with GitHub
				</Button>
				<Button
					loading={loading === 'google'}
					loadingText="Signing in with Google..."
					variant="outline"
					onclick={signInWithGoogle}
					class="w-full"
				>
					<Icon name="google" type="brands" class="mr-2 text-brand" />
					Continue with Google
				</Button>
			</div>
		</div>
	</div>
</div>
