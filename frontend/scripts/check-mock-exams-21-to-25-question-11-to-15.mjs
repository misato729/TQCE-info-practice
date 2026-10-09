import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { parse, compileScript } from '@vue/compiler-sfc'
import ts from 'typescript'
import * as Vue from 'vue'
import * as VueSSR from 'vue/server-renderer'

// Render the real shared component. Backend tests independently establish that
// all seed/API payloads match this approved-draft fixture, including the table.
const componentPath = new URL('../app/components/QuestionContentBlocks.vue', import.meta.url)
const fixturePath = new URL('../../backend/test/fixtures/mock_exams_21_to_25_guidance_psychology_report_approved.json', import.meta.url)
const { descriptor } = parse(readFileSync(componentPath, 'utf8'), { filename: fileURLToPath(componentPath) })
const compiled = compileScript(descriptor, { id: 'q21-25-block-check', inlineTemplate: true, templateOptions: { ssr: true } })
const script = ts.transpileModule(compiled.content, {
  compilerOptions: { target: ts.ScriptTarget.ES2022, module: ts.ModuleKind.ESNext },
}).outputText.replace(/import \{([^}]+)\} from ['"](vue(?:\/server-renderer)?)['"];?/g, (_match, bindings, module) => {
  return `const { ${bindings.replace(/\s+as\s+/g, ': ')} } = ${module === 'vue' ? 'Vue' : 'VueSSR'};`
}).replace('export default', 'return')
const ContentBlocks = new Function('Vue', 'VueSSR', script)(Vue, VueSSR)
const fixture = JSON.parse(readFileSync(fixturePath, 'utf8'))
let choiceCount = 0
let fillCellCount = 0
let excerptCount = 0

const render = blocks => VueSSR.renderToString(Vue.createSSRApp(ContentBlocks, { blocks }))
for (const { exam, attributes: question } of fixture.questions) {
  const key = `${exam}-${question.question_number}`
  const body = await render(question.content_blocks)
  assert(!body.includes('{{'), `${key}: unrendered blank marker`)
  assert(!body.includes('content-quote'), `${key}: generic quote instead of exam excerpt`)
  const quotes = question.content_blocks.filter(block => block.type === 'fill_in_quote')
  excerptCount += quotes.length
  assert.equal((body.match(/class="exam-fill-in-quote"/g) ?? []).length, quotes.length, key)
  const blanks = question.content_blocks.reduce((count, block) => count + (block.text?.match(/\{\{[①②③]\}\}/g) ?? []).length, 0)
  assert.equal((body.match(/class="fill-in-blank"/g) ?? []).length, blanks, key)
  if (exam === 24 && question.question_number === 11) {
    assert.equal((body.match(/<table\b/g) ?? []).length, 1)
    assert.equal((body.match(/<td[^>]*>【[①②③]】<\/td>/g) ?? []).length, 3)
    assert(body.includes('SCはスクールカウンセラーを表す。'))
    assert(body.includes('原典に掲載された表そのものではない。'))
  }
  for (const choice of question.choices) {
    const html = await render(choice.content_blocks)
    const cells = choice.content_blocks[0].cells ?? []
    assert.equal((html.match(/class="fill-in-choice-cell"/g) ?? []).length, cells.length, `${key} ${choice.label}`)
    assert(!html.includes('{{'))
    fillCellCount += cells.length
    choiceCount++
  }
  const explanation = await render(question.explanation_blocks)
  assert.equal((explanation.match(/class="content-text"/g) ?? []).length, question.explanation_blocks.length, key)
}
assert.equal(fixture.questions.length, 25)
assert.equal(choiceCount, 100)
assert.equal(excerptCount, 6)
assert.equal(fillCellCount, 64)
console.log(`PASS: ${fixture.questions.length} questions, ${choiceCount} choices, ${excerptCount} exam excerpts, ${fillCellCount} fill-in cells; table and SC note verified`)
