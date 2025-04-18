<script lang="ts">
  import { goto } from "$app/navigation"
  import { postSignup } from "$lib/api"

  let username = $state("")
  let password = $state("")

  async function signup() {
    const result = await postSignup(username, password)

    result.match(() => {
      localStorage.setItem("username", username)
      goto("/")
    }, alert)
  }
</script>

<form class="flex flex-col items-center justify-center">
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    placeholder="Username"
    bind:value={username}
  />
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    type="password"
    placeholder="Password"
    bind:value={password}
  />
  <button class="m-1 cursor-pointer rounded-2xl border-2 p-1 text-lg" onclick={signup}
    >Sign up</button
  >
</form>
