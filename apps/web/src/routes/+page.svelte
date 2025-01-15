<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { onMount } from 'svelte';
	import { fade, fly } from 'svelte/transition';
	import { gsap } from 'gsap';
	import { TextPlugin } from 'gsap/dist/TextPlugin';
	gsap.registerPlugin(TextPlugin);

	const invoices = [
		{
			name: 'Invoice #1234',
			amount: '$299.99',
			status: 'pending',
			date: 'March 15, 2024',
			dueDate: 'March 29, 2024'
		},
		{
			name: 'Invoice #1235',
			amount: '$599.99',
			status: 'paid',
			date: 'March 16, 2024',
			dueDate: 'March 30, 2024'
		},
		{
			name: 'Invoice #1236',
			amount: '$1,299.99',
			status: 'pending',
			date: 'March 17, 2024',
			dueDate: 'March 31, 2024'
		}
	];

	let invoiceName = invoices[0].name;
	let invoiceAmount = invoices[0].amount;
	let invoiceStatus = invoices[0].status;
	let invoiceDate = invoices[0].date;
	let dueDate = invoices[0].dueDate;

	let terminalRef: HTMLDivElement;
	let invoiceRef: HTMLDivElement;

	onMount(() => {
		// Create the main timeline
		const tl = gsap.timeline({
			repeat: -1,
			repeatDelay: 3
		});

		invoices.forEach((invoice, index) => {
			const nextInvoice = invoices[(index + 1) % invoices.length];

			// Name field animation
			tl.to({}, {
				duration: 0.2,
				onStart: () => {
					gsap.to(terminalRef.querySelector('p:first-child'), {
						backgroundColor: 'rgba(255,255,255,0.15)',
						duration: 0.2
					});
				}
			})
			.to(terminalRef.querySelector('p:first-child'), {
				duration: 0.4,
				text: '"name": ""',
				ease: 'none'
			})
			.to(terminalRef.querySelector('p:first-child'), {
				duration: 1.2,
				text: `"name": "${nextInvoice.name}",`,
				ease: 'none',
				onComplete: () => {
					gsap.to(invoiceRef.querySelector('.invoice-name'), {
						x: -20,
						opacity: 0,
						duration: 0.2,
						onComplete: () => {
							invoiceName = nextInvoice.name;
							invoiceDate = nextInvoice.date;
							dueDate = nextInvoice.dueDate;
							gsap.fromTo(invoiceRef.querySelector('.invoice-name'), 
								{ x: 20, opacity: 0 },
								{ x: 0, opacity: 1, duration: 0.4, ease: 'back.out(1.7)' }
							);
						}
					});
				}
			})
			.to({}, {
				duration: 0.3,
				onStart: () => {
					gsap.to(terminalRef.querySelector('p:first-child'), {
						backgroundColor: 'transparent',
						duration: 0.2
					});
				}
			})

			// Amount field animation
			.to({}, {
				duration: 0.2,
				onStart: () => {
					gsap.to(terminalRef.querySelector('p:nth-child(2)'), {
						backgroundColor: 'rgba(255,255,255,0.15)',
						duration: 0.2
					});
				}
			})
			.to(terminalRef.querySelector('p:nth-child(2)'), {
				duration: 0.4,
				text: '"amount": ""',
				ease: 'none'
			})
			.to(terminalRef.querySelector('p:nth-child(2)'), {
				duration: 1.2,
				text: `"amount": "${nextInvoice.amount}",`,
				ease: 'none'
			})
			.to({}, {
				duration: 0.2,
				onComplete: () => {
					gsap.to([
						invoiceRef.querySelector('.subtotal-row'),
						invoiceRef.querySelector('.total-row')
					], {
						opacity: 0,
						y: -10,
						duration: 0.2,
						stagger: 0,
						onComplete: () => {
							invoiceAmount = nextInvoice.amount;
							gsap.fromTo([
								invoiceRef.querySelector('.subtotal-row'),
								invoiceRef.querySelector('.total-row')
							], 
							{
								opacity: 0,
								y: -20
							},
							{
								opacity: 1,
								y: 0,
								duration: 0.4,
								stagger: 0.2,
								ease: 'power2.out'
							});
						}
					});
				}
			})
			.to({}, {
				duration: 0.3,
				onStart: () => {
					gsap.to(terminalRef.querySelector('p:nth-child(2)'), {
						backgroundColor: 'transparent',
						duration: 0.2
					});
				}
			})

			// Status field animation
			.to({}, {
				duration: 0.2,
				onStart: () => {
					gsap.to(terminalRef.querySelector('p:nth-child(3)'), {
						backgroundColor: 'rgba(255,255,255,0.15)',
						duration: 0.2
					});
				}
			})
			.to(terminalRef.querySelector('p:nth-child(3)'), {
				duration: 0.4,
				text: '"status": ""',
				ease: 'none'
			})
			.to(terminalRef.querySelector('p:nth-child(3)'), {
				duration: 1.2,
				text: `"status": "${nextInvoice.status}"`,
				ease: 'none',
				onComplete: () => {
					gsap.to(invoiceRef.querySelector('.status-badge'), {
						keyframes: [
							{ scale: 1.2, duration: 0.2 },
							{ scale: 1, duration: 0.2 }
						]
					});
					invoiceStatus = nextInvoice.status;
					invoiceDate = nextInvoice.date;
					dueDate = nextInvoice.dueDate;
				}
			})
			.to({}, {
				duration: 0.3,
				onStart: () => {
					gsap.to(terminalRef.querySelector('p:nth-child(3)'), {
						backgroundColor: 'transparent',
						duration: 0.2
					});
				}
			});
		});
	});
</script>

<div class="bg-grid-neutral-100 relative pt-16">
	<section class="container grid overflow-hidden md:grid-cols-[2fr_3fr] lg:gap-12">
		<div
			class="my-auto flex flex-col items-center justify-center space-y-4 pt-32 text-center md:items-start md:py-20 md:text-left"
		>
			<h1 class="text-4xl font-bold">Simplify your <span class="text-rose-500">PDFs</span></h1>
			<p class="text-pretty text-lg text-muted-foreground">
				Create beautiful dynamic and fully customizable PDFs with our powerful editor and API.
			</p>
			<div class="flex gap-4">
				<Button class="w-fit">Get started for free</Button>
				<Button variant="outline" class="w-fit">Pricing</Button>
			</div>
		</div>
		<div
			class="overflow-x-show relative flex h-[500px] w-full items-start justify-center overflow-y-hidden px-12 pt-16 lg:px-20"
		>
			<div class="relative aspect-[1/1.4142] w-full">
				<div class="absolute inset-0 -rotate-6 transform-gpu">
					<div class="h-full w-full rounded-sm border bg-white p-8 shadow-xl shadow-rose-500">
						<div class="mb-2 h-4 w-full rounded bg-muted"></div>
						<div class="mb-2 h-4 w-3/4 rounded bg-muted"></div>
						<div class="h-4 w-1/2 rounded bg-muted"></div>
					</div>
				</div>
				<div class="absolute inset-0 rotate-3 transform-gpu">
					<div class="h-full w-full rounded-sm border bg-white p-8 shadow-lg shadow-rose-500">
						<div class="mb-2 h-4 w-full rounded bg-muted"></div>
						<div class="mb-2 h-4 w-2/3 rounded bg-muted"></div>
						<div class="h-4 w-1/3 rounded bg-muted"></div>
					</div>
				</div>
				<div class="absolute inset-0 transform-gpu" bind:this={invoiceRef}>
					<div class="h-full w-full rounded-sm border bg-white p-8 shadow-lg shadow-rose-500">
						<div class="mb-6 flex items-start justify-between">
							<div class="flex items-center gap-2">
								<div class="flex size-8 items-center justify-center rounded bg-rose-500">
									<span class="text-sm font-bold text-white">A</span>
								</div>
								<div>
									<h3 class="text-base font-semibold leading-none">ACME Inc.</h3>
									<p class="text-xs text-muted-foreground">Since 2002</p>
								</div>
							</div>
							<div class="text-right">
								<div
									class="status-badge inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium capitalize transition-all duration-200"
									class:bg-yellow-100={invoiceStatus === 'pending'}
									class:text-yellow-700={invoiceStatus === 'pending'}
									class:bg-green-100={invoiceStatus === 'paid'}
									class:text-green-700={invoiceStatus === 'paid'}
								>
									{invoiceStatus}
								</div>
							</div>
						</div>

						<div class="mb-6 invoice-details">
							<h2 class="invoice-name text-xl font-semibold text-rose-500">{invoiceName}</h2>
							<div class="mt-1">
								<p class="text-xs text-muted-foreground">Issue Date: {invoiceDate}</p>
								<p class="text-xs text-muted-foreground">Due Date: {dueDate}</p>
							</div>
						</div>

						<div class="amount-group">
							<div class="mb-3 border-b border-t py-3">
								<div class="subtotal-row">
									<div class="mb-1 flex justify-between">
										<span class="text-sm text-muted-foreground">Professional Plan</span>
										<span class="text-sm">{invoiceAmount}</span>
									</div>
									<div class="flex justify-between text-xs text-muted-foreground">
										<span>Monthly Subscription</span>
										<span>1 × {invoiceAmount}</span>
									</div>
								</div>
							</div>

							<div class="total-row flex items-center justify-between text-base font-medium">
								<span>Total Amount</span>
								<span>{invoiceAmount}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div
				class="absolute bottom-20 right-4 z-20 w-80 transform-gpu rounded-lg border-2 border-neutral-700 bg-neutral-900/75 p-4 font-mono text-sm text-neutral-200 shadow-lg backdrop-blur-sm"
				bind:this={terminalRef}
			>
				<div class="mb-3 flex items-center gap-1.5">
					<div class="size-2 rounded-full bg-red-500"></div>
					<div class="size-2 rounded-full bg-yellow-500"></div>
					<div class="size-2 rounded-full bg-green-500"></div>
				</div>
				<div class="relative space-y-1 text-xs">
					<span>&#123;</span>
					<div class="ml-4 space-y-1">
						<p class="rounded-sm p-1">"name": "{invoiceName}",</p>
						<p class="rounded-sm p-1">"amount": "{invoiceAmount}",</p>
						<p class="rounded-sm p-1">"status": "{invoiceStatus}"</p>
					</div>
					<span>&#125;</span>
				</div>
			</div>
		</div>
	</section>
	<div
		class="absolute inset-x-0 bottom-0 h-[200px] bg-gradient-to-b from-transparent to-background"
	></div>
</div>

<!-- <section class="container mt-24">
	<ul class="grid grid-cols-3 gap-8 text-center">
		<li>
			<div class="mb-2 text-4xl font-bold">10M+</div>
			<div class="text-muted-foreground">Documents Generated</div>
		</li>
		<li>
			<div class="mb-2 text-4xl font-bold">50k+</div>
			<div class="text-muted-foreground">Active Users</div>
		</li>
		<li>
			<div class="mb-2 text-4xl font-bold">99.9%</div>
			<div class="text-muted-foreground">Uptime Guarantee</div>
		</li>
	</ul>
</section> -->

<div class="h-[1000px]"></div>
