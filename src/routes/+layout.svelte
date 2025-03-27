<script lang="ts">
  import Footer from "$lib/components/Footer.svelte"
  import Header from "$lib/components/Header.svelte"
  import "../app.css"

  let { children } = $props()
</script>

<div class="flex flex-col h-screen justify-between dark:text-white dark:bg-black">
  <header class="p-2 bg-gray-200 dark:bg-gray-900">
    <Header />
  </header>
  <main class="p-2 mb-auto">
    {@render children()}
  </main>
  <footer class="p-2 bg-gray-200 dark:bg-gray-900">
    <Footer />
  </footer>
</div>
