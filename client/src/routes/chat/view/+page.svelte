<script lang="ts">
  import { browser } from "$app/environment"
  import { page } from "$app/state"
  import type { Message } from "$lib"
  import { getMessages, postMessage } from "$lib/api"

  let messages: Message[] = $state([])
  let id: string | null = null
  let message = $state("")

  if (browser) {
    id = page.url.searchParams.get("id")

    fetchMessages()
  }

  async function fetchMessages() {
    if (!id) return

    const result = await getMessages(id)

    result.match((m) => (messages = m), alert)
  }

  async function sendMessage() {
    if (!id) return

    const result = await postMessage(id, message)

    message = ""

    result.match((m) => messages.push(m), alert)
  }
</script>

<div>
  {#each messages as message (message.id)}
    <div>
      <div class="font-bold">
        {message.author_name}:
      </div>
      <div class="text-xl">
        {message.content}
      </div>
    </div>
  {/each}
</div>
<div>
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    placeholder="Message"
    bind:value={message}
    onkeydown={(e) => e.key === "Enter" && sendMessage()}
  />
  <button class="m-1 cursor-pointer rounded-2xl border-2 p-1 text-lg" onclick={sendMessage}>
    Send
  </button>
</div>
