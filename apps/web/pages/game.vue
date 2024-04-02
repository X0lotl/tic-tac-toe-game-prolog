<script lang="ts" setup>
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';
import { useTableStore } from '../store/table.store';

const tableStore = useTableStore();

const router = useRouter();

</script>

<template>
  <div class="flex justify-center items-center h-full">
    <board />
    <Dialog :visible="tableStore.isGameEnd" modal header=" " class="w-[500px]">
      <template #footer>
        <div class="flex justify-center w-full gap-5">
          <Button @click="tableStore.resetTable()" label="Restart" />
          <Button @click="router.push('/')" severity="danger" label="Change settings" />
        </div>
      </template>
      <div class="text-3xl font-bold text-center">
        GAME END
      </div>
      <div class="mt-3 text-center">
        {{ tableStore.winner === 'X' ? 'Player X wins' : tableStore.winner === 'O' ? 'Player O wins' : 'Draw' }}
      </div>
    </Dialog>
  </div>
</template>
