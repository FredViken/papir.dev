<!-- Create a layout with sidebar navigation -->
<script lang="ts">
	import { page } from '$app/state';
	import Icon from '$components/ui/icon/icon.svelte';
	import type { LayoutData } from './$types';
	import type { Tables } from '$db';
	import * as Sidebar from '$lib/components/ui/sidebar';
	import * as DropdownMenu from '$lib/components/ui/dropdown-menu';
	import { Button } from '$components/ui/button';

	let { data, children } = $props();

	// Navigation items
	const nav = $derived([
		{
			label: 'Templates',
			href: `/app/${page.params.workspace}/templates`,
			icon: 'file-lines'
		},
		{
			label: 'Logs',
			href: `/app/${page.params.workspace}/logs`,
			icon: 'table-list'
		},
		{
			label: 'Plan',
			href: `/app/${page.params.workspace}/plan`,
			icon: 'credit-card'
		},
		{
			label: 'API Keys',
			href: `/app/${page.params.workspace}/api-keys`,
			icon: 'lock'
		},
		{
			label: 'Settings',
			href: `/app/${page.params.workspace}/settings`,
			icon: 'gear'
		}
	]);

	let isOwner = $derived(
		data.workspace?.workspace_members.some(
			(member: Tables<'workspace_members'>) =>
				member.user_id === data.user?.id && member.role === 'owner'
		) ?? false
	);
</script>

<svelte:head>
	<title>{data.workspace.name} | Prismer.io</title>
</svelte:head>

<Sidebar.Provider>
	<Sidebar.Root collapsible="icon">
		<Sidebar.Header>
			<div class="flex items-center gap-2 p-2">
				<img src="/logo.svg" class="size-8 rounded-sm" alt="Logo" />
				<span class="font-semibold group-data-[collapsible=icon]:hidden">Prismer.io</span>
			</div>
		</Sidebar.Header>
		<Sidebar.Separator />
		<Sidebar.Content>
			<Sidebar.Group>
				<Sidebar.GroupContent>
					<Sidebar.Menu>
						{#each nav as item (item.label)}
							<Sidebar.MenuItem>
								<Sidebar.MenuButton size="default" isActive={item.href === page.url.pathname}>
									{#snippet child({ props })}
										<a href={item.href} {...props}>
											<Icon
												name={item.icon}
												type={item.href === page.url.pathname ? 'solid' : 'regular'}
												class="text-muted-foreground group-data-[collapsible=icon]:text-base group-data-[active=true]:text-brand"
											/>
											<span class="truncate group-data-[collapsible=icon]:hidden">{item.label}</span
											>
										</a>
									{/snippet}
									{#snippet tooltipContent()}
										{item.label}
									{/snippet}
								</Sidebar.MenuButton>
							</Sidebar.MenuItem>
						{/each}
					</Sidebar.Menu>
				</Sidebar.GroupContent>
			</Sidebar.Group>
		</Sidebar.Content>
		<Sidebar.Footer>
			<Sidebar.Separator />
			<DropdownMenu.Root>
				<DropdownMenu.Trigger>
					{#snippet child({ props })}
						<Sidebar.MenuButton
							{...props}
							size="lg"
							class="h-12 rounded-sm duration-200 data-[state=open]:bg-sidebar-accent data-[state=open]:text-sidebar-accent-foreground"
						>
							<!-- <img src="/logo.svg" class="size-8 rounded-sm" alt="Logo" /> -->
							<div
								class="flex aspect-square size-8 items-center justify-center rounded-sm border"
								style="
              background-color: {data.workspace.color.replace(')', ', 10%)')};
              color: {data.workspace.color.replace('45%)', '35%)')};
              border-color: {data.workspace.color.replace(')', ', 100%)')};"
							>
								<!-- <Icon name="house" type="solid" /> -->
								{data.workspace.name.charAt(0)}
							</div>
							<span class="truncate font-medium group-data-[collapsible=icon]:hidden"
								>{data.workspace.name}</span
							>
							<i class="far fa-angles-up-down ml-auto group-data-[collapsible=icon]:hidden"></i>
						</Sidebar.MenuButton>
					{/snippet}
				</DropdownMenu.Trigger>
				<DropdownMenu.Content class="w-[--bits-dropdown-menu-anchor-width] min-w-56">
					{#each data.workspaces as workspace}
						<DropdownMenu.Item>
							{#snippet child({ props })}
								<a href="/app/{workspace.id}" {...props}>
									<div class="flex w-full items-center gap-2">
										<div
											class="flex size-8 items-center justify-center rounded-sm border"
											style="
                      background-color: {workspace.color.replace(')', ', 10%)')};
                      color: {workspace.color.replace('45%)', '35%)')};
                      border-color: {workspace.color.replace(')', ', 100%)')};"
										>
											<!-- <Icon name="house" type="solid" /> -->
											{workspace.name.charAt(0)}
										</div>
										{workspace.name}
										{#if workspace.id == page.params.workspace}
											<Icon name="check" class="ml-auto" />
										{/if}
									</div>
								</a>
							{/snippet}
						</DropdownMenu.Item>
					{/each}

					<DropdownMenu.Separator />
					<DropdownMenu.Item>
						<a href="/app/create">
							<Icon name="plus" />
							Create workspace
						</a>
					</DropdownMenu.Item>
				</DropdownMenu.Content>
			</DropdownMenu.Root>

			<!-- <Sidebar.Trigger /> -->

			<div class="p-2 space-y-2 text-muted-foreground text-sm">
        Free plan
        <div class="rounded-full h-1 w-full mb-4 bg-neutral-200 block relative overflow-hidden">
          <div class="absolute inset-0 w-1/2 bg-brand rounded-full"></div>
        </div>
      </div>
		</Sidebar.Footer>
	</Sidebar.Root>

	<div class="flex min-h-screen w-full flex-col">
		<header class="w-full border-b bg-background p-4 md:hidden">
			<Sidebar.Trigger variant="outline" size="icon" />
		</header>
		<main>
			{@render children()}
		</main>
	</div>
</Sidebar.Provider>
