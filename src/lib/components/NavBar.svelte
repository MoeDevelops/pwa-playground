<script lang="ts">
  import { Home, Mail, Search, User } from "@lucide/svelte"
  import { page } from "$app/state"

  const elements = [
    { link: "/", display: "Home", icon: Home, isActive: false },
    { link: "/search", display: "Search", icon: Search, isActive: false },
    { link: "/messages", display: "Messages", icon: Mail, isActive: false },
    { link: "/account", display: "Account", icon: User, isActive: false },
  ]

  function isActive(element: { link: string; isActive: boolean }) {
    return page.url.pathname === element.link
  }
</script>

<nav class="flex justify-evenly">
  {#each elements as element (element.link)}
    <a href={element.link}>
      <div
        class="flex p-2 m-2 w-max flex-col flex-wrap items-center {isActive(element)
          ? 'font-extrabold'
          : ''}"
      >
        <svelte:component this={element.icon} class="" />
        {element.display}
      </div>
    </a>
  {/each}
</nav>
