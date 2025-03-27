import { precacheAndRoute } from "workbox-precaching"
import { build, files, prerendered, version } from "$service-worker"

const precacheList = [...build, ...files, ...prerendered].map((file) => ({
  url: file,
  revision: version,
}))

precacheAndRoute(precacheList)
