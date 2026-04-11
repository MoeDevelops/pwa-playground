<script>
  import { resolve } from "$app/paths"
</script>

<h1 class="text-6xl">Account</h1>

<div>
  <a class="text-2xl text-blue-400 underline" href={resolve("/account/signup")}>Sign up</a>
</div>
<div>
  <a class="text-2xl text-blue-400 underline" href={resolve("/account/login")}>Login</a>
</div>
