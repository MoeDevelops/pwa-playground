<script lang="ts">
  import { browser } from "$app/environment"
  import type { User } from "$lib"
  import InstallButton from "$lib/components/InstallButton.svelte"

  let greeting = $state("")

  if (browser) {
    setGreeting()
    fetchUserData()
  }

  function setGreeting() {
    const username = localStorage.getItem("username")
    greeting = username ? `Hello, ${username}!` : "Hello!"
  }

  async function fetchUserData() {
    try {
      const response = await fetch("/api/account/self", {})

      if (response.status === 200) {
        const userData: User = await response.json()
        localStorage.setItem("username", userData.username)
      } else {
        localStorage.removeItem("username")
      }
    } finally {
      setGreeting()
    }
  }
</script>

<h1 class="text-6xl">{greeting}</h1>

<InstallButton />
