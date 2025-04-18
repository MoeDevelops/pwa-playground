<script lang="ts">
  import { browser } from "$app/environment"

  interface BeforeInstallPromptEvent extends Event {
    readonly platforms: Array<string>
    readonly userChoice: Promise<{
      outcome: "accepted" | "dismissed"
      platform: string
    }>
    prompt(): Promise<void>
  }

  let installPrompt: BeforeInstallPromptEvent | null = null
  let showInstall = $state(false)

  if (browser) {
    window.addEventListener("beforeinstallprompt", (event) => {
      event.preventDefault()
      installPrompt = event as BeforeInstallPromptEvent
      showInstall = true
    })
  }

  async function install() {
    await installPrompt?.prompt()
  }
</script>

<button class="cursor-pointer border-2 p-1" onclick={install} hidden={!showInstall}>Install</button>
