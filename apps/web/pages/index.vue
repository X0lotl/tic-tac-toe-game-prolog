<script lang="ts" setup>
import Button from 'primevue/button';
import Slider from 'primevue/slider';
import InputNumber from 'primevue/inputnumber';
import FloatLabel from 'primevue/floatlabel';
import { useTableStore } from '~/store/table.store';
import { Player } from '~/models/player.model';

const selectedMode = ref<'single' | 'duo' | 'auto' >('single');

const playerPlays = ref<'X' | 'O'>('X');

const router = useRouter();

const m = ref(3);

const n = ref(3);

const lengthToWin = ref(3);

const difficulty = ref(1);

const tableStore = useTableStore();

const onStartButtonClick = () => {
  if (selectedMode.value === 'single') {
    const xPlayer = playerPlays.value === 'X' ? Player.Player : Player.Computer;
    const oPlayer = playerPlays.value === 'O' ? Player.Player : Player.Computer; 
    
    tableStore.startGame(m.value, n.value, xPlayer, oPlayer, lengthToWin.value, difficulty.value);

  } else if (selectedMode.value === 'duo') {
    tableStore.startGame(m.value, n.value, Player.Player, Player.Player,  lengthToWin.value, difficulty.value);

  } else if (selectedMode.value === 'auto') {
    tableStore.startGame(m.value, n.value, Player.Computer, Player.Computer,  lengthToWin.value, difficulty.value);

  }
    router.push('/game');
};

</script>

<template>
  <div class="flex justify-center h-full items-center">
    <div class="grid grid-cols-1 gap-10">
      <div class="grid grid-cols-3 gap-3">
        <Button @click="selectedMode = 'single'" :outlined="selectedMode !== 'single'" class="w-full"
          label="Player Vs Computer"></Button>
        <Button @click="selectedMode = 'duo'" :outlined="selectedMode !== 'duo'" class="w-full"
          label="Player Vs Player"></Button>
        <Button @click="selectedMode = 'auto'" :outlined="selectedMode !== 'auto'" class="w-full"
          label="Computer Vs Computer"></Button>
      </div>
      <div class="grid grid-cols-2 gap-3">
        <Button @click="playerPlays = 'X'" :outlined="playerPlays !== 'X'" :disabled="selectedMode !== 'single'"
          class="w-full" label="Player X"></Button>
        <Button @click="playerPlays = 'O'" :outlined="playerPlays !== 'O'" :disabled="selectedMode !== 'single'"
          class="w-full" label="Player O"></Button>
      </div>
      <div class="grid grid-cols-1 gap-3">
        <FloatLabel>
          <InputNumber id="rows" v-model="m" label="Rows" :min="3" :max="20" class="w-full" />
          <label for="rows">Row numbers</label>
        </FloatLabel>
        <Slider v-model="m" :min="3" :max="20" />
      </div>
      <div class="grid grid-cols-1 gap-3">
        <FloatLabel>
          <InputNumber id="rows" v-model="n" label="Rows" :min="3" :max="20" class="w-full" />
          <label for="rows">Column numbers</label>
        </FloatLabel>
        <Slider v-model="n" :min="3" :max="20" />
      </div>
      <div class="grid grid-cols-1 gap-3">
        <FloatLabel>
          <InputNumber id="rows" v-model="lengthToWin" label="Rows" :min="3" :max="Math.min(m,n)" class="w-full" />
          <label for="rows">Length to win</label>
        </FloatLabel>
        <Slider v-model="lengthToWin" :min="3" :max="Math.min(m,n)" />
      </div>
      <div class="grid grid-cols-1 gap-3">
        <FloatLabel>
          <InputNumber id="rows" v-model="difficulty" label="Rows" :min="1" :max="5" class="w-full" />
          <label for="rows">Difficulty</label>
        </FloatLabel>
        <Slider v-model="difficulty" :min="1" :max="5" />
      </div>
      <div>
        <Button @click="onStartButtonClick()" class="w-full" severity="success" label="Start Game" />
      </div>
    </div>
  </div>
</template>
