<script lang="ts">
  import { browser } from "$app/environment"

  class InstallEvent extends Event {
    prompt: () => Promise<void> = () => new Promise(() => {})
  }

  let installPrompt: InstallEvent | null = null
  let showInstall = $state(false)

  if (browser) {
    window.addEventListener("beforeinstallprompt", (event) => {
      if (event instanceof InstallEvent) {
        event.preventDefault()
        installPrompt = event
        showInstall = true
      }
    })
  }

  async function install() {
    await installPrompt?.prompt()
  }
</script>

<button class="border-2 p-1 cursor-pointer" onclick={install} hidden={!showInstall}>Install</button>
