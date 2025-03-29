<script lang="ts">
  import { Home, Mail, Search } from "@lucide/svelte"

  const elements = [
    { link: "/", display: "Home", icon: Home },
    { link: "/search", display: "Search", icon: Search },
    { link: "/messages", display: "Messages", icon: Mail },
  ]
</script>

<nav>
  {#each elements as element (element.link)}
    <a href={element.link}>
      <div class="flex p-2 m-2 w-50 rounded-2xl bg-blue-400 dark:bg-blue-600">
        <svelte:component this={element.icon} class="ml-1 mr-2" />
        {element.display}
      </div>
    </a>
  {/each}
</nav>
