<script lang="ts" setup>
import { useTableStore } from '../store/table.store';

const tableStore = useTableStore()

const { makeMove, curentMove } = tableStore;
</script>

<template>
  <div class="text-center w-full h-full">
    <div class="text-3xl py-4" :key="tableStore.curentMove">
      Move: {{ tableStore.curentMove }}
    </div>
    <div class="flex justify-center">
      <div class="grid gap-[2px] items-start"
        :style="`width: min(calc((80vh / ${tableStore.meta.m}) * ${tableStore.meta.n}), 100%);  grid-template-columns: repeat(${tableStore.meta.n}, minmax(0, 1fr));`">
        <div @click="makeMove(index)" :key="index" v-for="(cell, index) of tableStore.table"
          class="bg-white/30 aspect-square flex justify-center items-center" :style="`font-size: min(calc((60vh / ${tableStore.meta.m})), calc(60vw / ${tableStore.meta.n}))`">
          <Icon v-if="cell === 'X'" name="mdi:close" />
          <Icon v-if="cell === 'O'" name="mdi:circle-outline" class="w-full" />
        </div>
      </div>
    </div>
  </div>
</template>