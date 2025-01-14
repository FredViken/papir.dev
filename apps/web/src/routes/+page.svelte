<script>
	import { Button } from "$lib/components/ui/button";

	let invoiceName = "Invoice #1234";
	let invoiceAmount = "$299.99";
	let invoiceStatus = "pending";
	let invoiceDate = "March 15, 2024";
	let dueDate = "March 29, 2024";
</script>

<div class="bg-grid-neutral-100 pt-16 relative">  
  <section class="container grid md:grid-cols-[2fr_3fr] lg:gap-12 overflow-hidden">
    <div class="flex flex-col items-center md:items-start justify-center my-auto space-y-4 pt-32 text-center md:text-left md:py-20">
      <h1 class="text-4xl font-bold">Simplify your <span class="text-rose-500">PDFs</span></h1>
      <p class="text-muted-foreground text-lg text-pretty">
        Create beautiful dynamic and fully customizable PDFs with our powerful editor and API.
      </p>
      <div class="flex gap-4">
        <Button class="w-fit">Get started for free</Button>
        <Button variant="outline" class="w-fit">Pricing</Button>
      </div>
    </div>
    <div class="w-full flex items-start justify-center px-12 lg:px-20 relative overflow-y-hidden overflow-x-show h-[500px] pt-16">
      <div class="relative w-full aspect-[1/1.4142]">
        <div class="absolute inset-0 -rotate-6 transform-gpu">
          <div class="w-full h-full rounded-sm border bg-white shadow-xl shadow-rose-500 p-8">
            <div class="w-full h-4 bg-muted rounded mb-2"></div>
            <div class="w-3/4 h-4 bg-muted rounded mb-2"></div>
            <div class="w-1/2 h-4 bg-muted rounded"></div>
          </div>
        </div>
        <div class="absolute inset-0 rotate-3 transform-gpu">
          <div class="w-full h-full rounded-sm border bg-white shadow-lg shadow-rose-500 p-8">
            <div class="w-full h-4 bg-muted rounded mb-2"></div>
            <div class="w-2/3 h-4 bg-muted rounded mb-2"></div>
            <div class="w-1/3 h-4 bg-muted rounded"></div>
          </div>
        </div>
        <div class="absolute inset-0 transform-gpu">
          <div class="w-full h-full rounded-sm border bg-white shadow-lg shadow-rose-500 p-8">
            <div class="flex justify-between items-start mb-6">
              <div class="flex items-center gap-2">
                <div class="size-8 bg-rose-500 rounded flex items-center justify-center">
                  <span class="text-sm font-bold text-white">A</span>
                </div>
                <div>
                  <h3 class="font-semibold text-base leading-none">ACME Inc.</h3>
                  <p class="text-xs text-muted-foreground">Since 2002</p>
                </div>
              </div>
              <div class="text-right">
                <div class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium capitalize" class:bg-yellow-100={invoiceStatus === "pending"} class:text-yellow-700={invoiceStatus === "pending"} class:bg-green-100={invoiceStatus === "paid"} class:text-green-700={invoiceStatus === "paid"}>
                  {invoiceStatus}
                </div>
              </div>
            </div>

            <div class="mb-6">
              <h2 class="text-xl font-semibold text-rose-500">{invoiceName}</h2>
              <p class="text-xs text-muted-foreground mt-1">Issue Date: {invoiceDate}</p>
              <p class="text-xs text-muted-foreground">Due Date: {dueDate}</p>
            </div>
            
            <div class="border-t border-b py-3 mb-3">
              <div class="flex justify-between mb-1">
                <span class="text-sm text-muted-foreground">Professional Plan</span>
                <span class="text-sm">{invoiceAmount}</span>
              </div>
              <div class="flex justify-between text-xs text-muted-foreground">
                <span>Monthly Subscription</span>
                <span>1 × {invoiceAmount}</span>
              </div>
            </div>

            <div class="flex justify-between items-center text-base font-medium">
              <span>Total Amount</span>
              <span>{invoiceAmount}</span>
            </div>
          </div>
        </div>
      </div>
        <div class="absolute bottom-20 right-4 w-80 bg-neutral-900/75 backdrop-blur-sm rounded-lg shadow-lg border-2 border-neutral-700 font-mono text-sm text-neutral-200 p-4 transform-gpu z-20">
          <div class="flex items-center gap-1.5 mb-3">
            <div class="size-2 rounded-full bg-red-500"></div>
            <div class="size-2 rounded-full bg-yellow-500"></div>
            <div class="size-2 rounded-full bg-green-500"></div>
          </div>
          <div class="text-xs space-y-1">
            <span>&#123;</span>
            <div class="ml-4 space-y-1">
              <p>"name": "{invoiceName}",</p>
              <p>"amount": "{invoiceAmount}",</p>
              <p>"status": "{invoiceStatus}"</p>
            </div>
            <span>&#125;</span>
          </div>
        </div>
      </div>
    </section>
    <div class="absolute inset-x-0 bottom-0 h-[200px] bg-gradient-to-b from-transparent to-background"></div>
</div>

<section class="container mt-24">
  <ul class="grid grid-cols-3 gap-8 text-center">
    <li>
      <div class="text-4xl font-bold mb-2">10M+</div>
      <div class="text-muted-foreground">Documents Generated</div>
    </li>
    <li>
      <div class="text-4xl font-bold mb-2">50k+</div>
      <div class="text-muted-foreground">Active Users</div>
    </li>
    <li>
      <div class="text-4xl font-bold mb-2">99.9%</div>
      <div class="text-muted-foreground">Uptime Guarantee</div>
    </li>
  </ul>
</section>

<div class="h-[1000px]"></div>