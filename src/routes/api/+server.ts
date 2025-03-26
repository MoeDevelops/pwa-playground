export async function GET(event) {
  let name = event.url.searchParams.get("name")

  if (name === "" || name === null) {
    name = "Guest"
  }

  console.log(name + " made a request")

  return new Response(`Hello, ${name}!`)
}
