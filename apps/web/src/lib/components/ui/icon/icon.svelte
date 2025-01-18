<script lang="ts">
	import { cn } from "$lib/utils";

	// We can expand this type as we add more icons
	type IconName = 'github' | 'google' | 'house' | 'spinner' | 'check' | 'x';
	type IconStyle = 'solid' | 'regular' | 'brands';

	let { name, type = 'solid', class: className = '' } = $props<{
		name: IconName;
		type?: IconStyle;
		class?: string;
	}>();




</script>

<i class={cn(`fa-${type} fa-${name}`, className)} aria-hidden="true" ></i> 