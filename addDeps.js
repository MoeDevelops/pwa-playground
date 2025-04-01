import { readFile, writeFile } from "node:fs/promises"

const packageJson = await readFile("package.json", { encoding: "utf-8"}).then((x) => JSON.parse(x))
const deps = packageJson.dependencies

await writeFile("build/package.json", JSON.stringify({ type: "module", dependencies: deps }))