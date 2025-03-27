<script lang="ts">
  import { Play } from "@lucide/svelte"
  import { browser } from "$app/environment"

  let name = $state("")
  let greeting = $state("Hello!")
  let installPrompt: any = null
  let showInstall = $state(false)

  if (browser) {
    window.addEventListener("beforeinstallprompt", (event) => {
      event.preventDefault()
      installPrompt = event
      showInstall = true
    })
  }

  async function getHello() {
    const response = await fetch(`/api?name=${name}`)
    name = ""
    greeting = await response.text()
  }

  async function install() {
    await installPrompt?.prompt()
  }
</script>

<h1 class="text-6xl">{greeting}</h1>
<form class="my-3 flex">
  <input class="border-2 p-1" placeholder="Name" type="text" bind:value={name} />
  <button class="border-2 p-1" onclick={getHello} aria-label="Submit">
    <Play />
  </button>
</form>
<button class="border-2 p-1 cursor-pointer" onclick={install} hidden={!showInstall}>Install</button>
