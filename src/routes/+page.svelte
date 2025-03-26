<script lang="ts">
  let name = ""
  let greeting = "Hello!"

  async function getHello() {
    const response = await fetch(`/api?name=${name}`)
    name = ""
    greeting = await response.text()
  }
</script>

<h1 class="text-6xl">{greeting}</h1>
<form class="my-3">
  <input class="border-2 p-1" placeholder="Name" type="text" bind:value={name} />
  <button class="border-2 p-1" onclick={getHello}>Submit</button>
</form>
