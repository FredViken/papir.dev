<script lang="ts">
	import { invalidateAll } from '$app/navigation';
	import { Button } from '$components/ui/button';
    import type { PageData } from './$types';

    let { data }: { data: PageData } = $props();

    async function signOut() {
        await data.supabase.auth.signOut();
        invalidateAll();
    }
</script>

<Button onclick={signOut} loadingText="Signing out...">
    Sign Out
</Button>