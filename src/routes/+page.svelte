<script lang="ts">
  import { Play } from "@lucide/svelte"
  import InstallButton from "$lib/components/InstallButton.svelte"
  import NavBar from "$lib/components/NavBar.svelte"

  let name = $state("")
  let greeting = $state("Hello!")

  async function getHello() {
    const response = await fetch(`/api?name=${name}`)
    name = ""
    greeting = await response.text()
  }
</script>

<h1 class="text-6xl">{greeting}</h1>
<form class="my-3 flex">
  <input class="border-2 p-1" placeholder="Name" type="text" bind:value={name} />
  <button class="border-2 p-1" onclick={getHello} aria-label="Submit">
    <Play />
  </button>
</form>
<InstallButton />
