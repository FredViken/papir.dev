<script lang="ts">
	import { cn } from "$lib/utils";

	// We can expand this type as we add more icons
	type IconName = 'github' | 'google' | 'house' | 'spinner' | 'check' | 'x' | 'arrow-right' | 'plus' | 'file-lines' | 'chart-line' | 'gear' | 'chevron-down';
	type IconStyle = 'solid' | 'regular' | 'brands' | 'light';

	let { name, type = 'regular', class: className = '' } = $props<{
		name: IconName | string;
		type?: IconStyle;
		class?: string;
	}>();




</script>

<i class={cn(` fa-${type} fa-${name}`, className)} aria-hidden="true"></i> 