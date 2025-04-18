<script lang="ts">
  import { browser } from "$app/environment"
  import type { Chat } from "$lib"
  import { getChats, postChat } from "$lib/api"

  let username = $state("")
  let chats: Chat[] = $state([])

  if (browser) fetchChats()

  async function fetchChats() {
    const result = await getChats()
    chats = result.unwrapOr([])
  }

  async function createChat() {
    const result = await postChat(username)
    result.match((c) => chats.push(c), alert)
  }
</script>

<h1 class="text-6xl">Chat</h1>

<form class="my-2">
  <input
    class="m-1 border-2 bg-white p-1 text-lg text-black"
    placeholder="Username"
    bind:value={username}
  />
  <button class="m-1 cursor-pointer rounded-2xl border-2 p-1 text-lg" onclick={createChat}
    >New chat</button
  >
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
