<script lang="ts">
	import { cn } from "$lib/utils";

	// We can expand this type as we add more icons
	type IconName = 'github' | 'google' | 'house' | 'spinner' | 'check' | 'x' | 'arrow-right' | 'plus';
	type IconStyle = 'solid' | 'regular' | 'brands' | 'light';

	let { name, type = 'light', class: className = '' } = $props<{
		name: IconName | string;
		type?: IconStyle;
		class?: string;
	}>();




</script>

<i class={cn(`fa-duotone fa-${type} fa-${name}`, className)} aria-hidden="true"></i> 