<script lang="ts">
  import Footer from "$lib/components/Footer.svelte"
  import Header from "$lib/components/Header.svelte"
  import "../app.css"

  let { children } = $props()
</script>

<div class="flex flex-col h-screen justify-between dark:text-white dark:bg-black">
  <Header />
  <main class="mb-auto">
    {@render children()}
  </main>
  <Footer />
</div>
