<script lang="ts">
  import { browser } from "$app/environment"
  import type { Chat } from "$lib"

  let username = $state("")
  let chats: Chat[] = $state([])

  if (browser) getChats()

  async function getChats() {
    const result = await fetch("/api/chat/all", {
      method: "GET",
    })

    if (result.status !== 200) {
      return
    }

    const netChats: Chat[] = await result.json()
    chats.push(...netChats)
  }

  async function createChat() {
    const result = await fetch("/api/chat", {
      method: "POST",
      body: JSON.stringify({
        username: username,
      }),
    })

    if (result.status !== 201) {
      alert(await result.text())
      return
    }

    const chat: Chat = await result.json()
    chats.push(chat)
  }
</script>

<h1 class="text-6xl">Chat</h1>

<form class="my-2">
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    placeholder="Username"
    bind:value={username}
  />
  <button class="m-1 rounded-2xl border-2 p-1 text-lg" onclick={createChat}>New chat</button>
</form>

<div>
  {#each chats as chat (chat.id)}
    <a href="/chat/view?id={chat.id}">
      <div class="mx-1 my-2 rounded-2xl border-2 p-2">
        {chat.username1} & {chat.username2}
      </div>
    </a>
  {/each}
</div>
