<script setup lang="ts">
type CodeItem = {
  title: string
  code: string
}

type ContentBlock = {
  type: 'text' | 'quote' | 'table' | 'code' | 'code_group'
  text?: string
  source?: string
  title?: string
  code?: string
  headers?: string[]
  rows?: string[][]
  items?: CodeItem[]
}

defineProps<{
  blocks: ContentBlock[]
}>()
</script>

<template>
  <div class="content-blocks">
    <template v-for="(block, index) in blocks" :key="`${block.type}-${index}`">
      <p v-if="block.type === 'text'" class="content-text">{{ block.text }}</p>

      <blockquote v-else-if="block.type === 'quote'" class="content-quote">
        <p>{{ block.text }}</p>
        <cite v-if="block.source">{{ block.source }}</cite>
      </blockquote>

      <div v-else-if="block.type === 'table'" class="content-table-wrap" tabindex="0">
        <table class="content-table">
          <thead v-if="block.headers?.length">
            <tr>
              <th v-for="header in block.headers" :key="header" scope="col">{{ header }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, rowIndex) in block.rows" :key="rowIndex">
              <td v-for="(cell, cellIndex) in row" :key="cellIndex">{{ cell }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <figure v-else-if="block.type === 'code'" class="code-panel">
        <figcaption v-if="block.title">{{ block.title }}</figcaption>
        <pre><code>{{ block.code }}</code></pre>
      </figure>

      <div v-else-if="block.type === 'code_group'" class="code-group">
        <figure v-for="item in block.items" :key="item.title" class="code-panel">
          <figcaption>{{ item.title }}</figcaption>
          <pre><code>{{ item.code }}</code></pre>
        </figure>
      </div>
    </template>
  </div>
</template>

<style scoped>
.content-blocks { display: grid; gap: 20px; min-width: 0; }
.content-text { margin: 0; white-space: pre-wrap; }
.content-quote { margin: 0; padding: 18px 20px; border: 1px solid var(--line); border-left: 4px solid var(--teal); background: #f7faf9; }
.content-quote p { margin: 0; white-space: pre-wrap; }
.content-quote cite { display: block; margin-top: 10px; color: var(--muted); font-size: 13px; font-style: normal; }
.content-table-wrap { max-width: 100%; overflow-x: auto; border: 1px solid var(--line); }
.content-table { width: 100%; min-width: 620px; border-collapse: collapse; background: #fff; }
.content-table th,
.content-table td { padding: 12px 14px; border-right: 1px solid var(--line); border-bottom: 1px solid var(--line); text-align: left; vertical-align: top; white-space: pre-wrap; }
.content-table th { background: #f1f6f5; color: #30464d; font-size: 14px; }
.content-table tr:last-child td { border-bottom: 0; }
.content-table th:last-child,
.content-table td:last-child { border-right: 0; }
.code-group { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
.code-panel { min-width: 0; margin: 0; border: 1px solid var(--line); background: #f8faf9; }
.code-panel figcaption { padding: 10px 14px; border-bottom: 1px solid var(--line); font-weight: 800; text-align: center; }
.code-panel pre { margin: 0; padding: 16px; overflow-x: auto; font-size: 14px; line-height: 1.75; white-space: pre; }
.code-panel code { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace; }
@media (max-width: 720px) {
  .code-group { grid-template-columns: 1fr; }
  .content-quote { padding: 16px; }
}
</style>
