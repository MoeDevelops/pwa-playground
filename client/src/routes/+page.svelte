<script lang="ts">
  import { browser } from "$app/environment"
  import { getAccountSelf } from "$lib/api"
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
    const result = await getAccountSelf()

    result.match(
      (user) => {
        localStorage.setItem("username", user.username)
      },
      () => {
        localStorage.removeItem("username")
      },
    )

    setGreeting()
  }
</script>

<h1 class="text-6xl">{greeting}</h1>

<InstallButton />
