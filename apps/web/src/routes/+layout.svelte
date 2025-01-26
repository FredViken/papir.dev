<script>
    import { invalidate } from '$app/navigation'
    import { onMount } from 'svelte'
    import '../app.css';
    import { ProgressBar } from "@prgm/sveltekit-progress-bar";
	import { Toaster } from '$components/ui/sonner';
	// import NavigationProgress from '$components/ui/progress/navigation-progress.svelte';
  
    let { data, children } = $props()
    let { session, supabase } = $derived(data)
  
    onMount(() => {
      const { data } = supabase.auth.onAuthStateChange((_, newSession) => {
        if (newSession?.expires_at !== session?.expires_at) {
          invalidate('supabase:auth')
        }
      })
  
      return () => data.subscription.unsubscribe()
    })
</script>

<!-- <NavigationProgress /> -->
<!-- <ProgressBar class="text-rose-500 z-50" /> -->
{@render children()}
<Toaster />
