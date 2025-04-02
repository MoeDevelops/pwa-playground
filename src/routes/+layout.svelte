<script lang="ts">
  import Header from "$lib/components/Header.svelte"
  import NavBar from "$lib/components/NavBar.svelte"
  import "../app.css"

  let { children } = $props()
</script>

<div class="flex h-screen flex-col justify-between dark:bg-black dark:text-white">
  <header class="bg-gray-200 p-2 dark:bg-gray-900">
    <Header />
  </header>
  <main class="mb-auto p-2">
    {@render children()}
  </main>
  <footer class="bg-gray-200 p-2 dark:bg-gray-900">
    <NavBar />
  </footer>
</div>
