<script lang="ts">
  import { Home, Mail, Search, User } from "@lucide/svelte"
  import { page } from "$app/state"

  const elements = [
    { link: "/", display: "Home", icon: Home, isActive: false },
    { link: "/search", display: "Search", icon: Search, isActive: false },
    { link: "/chat", display: "Chat", icon: Mail, isActive: false },
    { link: "/account", display: "Account", icon: User, isActive: false },
  ]

  function isActive(element: { link: string; isActive: boolean }) {
    return page.url.pathname === element.link
  }
</script>

<nav class="my-1 flex flex-row justify-around">
  {#each elements as element (element.link)}
    <a
      href={element.link}
      class="flex flex-col items-center {isActive(element) ? 'font-extrabold' : ''}"
    >
      <svelte:component this={element.icon} class="" />
      {element.display}
    </a>
  {/each}
</nav>
