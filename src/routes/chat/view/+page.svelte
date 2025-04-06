<script lang="ts">
  import { browser } from "$app/environment"
  import { page } from "$app/state"
  import type { Message, User } from "$lib"

  let messages: Message[] = $state([])
  let id: string | null = null
  let message = $state("")

  if (browser) {
    id = page.url.searchParams.get("id")

    fetchMessages()
  }

  async function fetchMessages() {
    if (!id) return

    const result = await fetch(`/api/chat/messages?id=${id}`)

    if (result.status !== 200) {
      alert(await result.text())
      return
    }

    const netMessages: Message[] = await result.json()

    messages = netMessages
  }

  async function sendMessage() {
    if (!id) return

    const result = await fetch("/api/message", {
      method: "POST",
      body: JSON.stringify({
        chat: id,
        message: message,
      }),
    })

    if (result.status !== 201) {
      alert(await result.text())
      return
    }

    message = ""
    const resultMessage: Message = await result.json()
    messages.push(resultMessage)
  }
</script>

<div>
  {#each messages as message (message.id)}
    <div>
      <div class="font-bold">
        {message.authorName}:
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
  <button class="m-1 cursor-pointer rounded-2xl border-2 p-1 text-lg" onclick={sendMessage}
    >Send</button
  >
</div>
