import MarkdowmIt from "markdown-it"
import fs from "fs/promises"

const md = MarkdowmIt()
const md2htmlString = (mdString:string) => md.render(mdString)

const htmlFileName = "../dist/1-1.html"
const mdFilePath = "../src/01_視点学とはなにかを考える/01.md"

const mdPromise = fs.readFile(mdFilePath, "utf-8")

async () => {
  const mdString = await mdPromise
  fs.writeFile(htmlFileName,mdString)
}