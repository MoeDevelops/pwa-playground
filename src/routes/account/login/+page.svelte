<script lang="ts">
  import { goto } from "$app/navigation"

  let username = $state("")
  let password = $state("")

  async function login() {
    const result = await fetch("/api/account/login", {
      method: "POST",
      body: JSON.stringify({
        username: username,
        password: password,
      }),
    })

    if (result.status !== 200) {
      alert(await result.text())
      return
    }

    localStorage.setItem("username", username)

    goto("/")
  }
</script>

<form class="flex flex-col items-center justify-center">
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    placeholder="username"
    bind:value={username}
  />
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    type="password"
    placeholder="password"
    bind:value={password}
  />
  <button class="m-1 rounded-2xl border-2 p-1 text-lg" onclick={login}>Login</button>
</form>
