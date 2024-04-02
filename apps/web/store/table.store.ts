import { Move, Player } from "~/models/player.model";
import type { Cell, Table } from "~/models/table.model";

export const useTableStore = defineStore('tableStore', () => {
  const table = ref<Table>([])

  const isWin = ref("E")

  const isGameEnd = ref(false)

  const meta = ref({
    m: 0,
    n: 0,
    lengthToWin: 0
  })

  const xPlayer = ref(Player.Player)
  const oPlayer = ref(Player.Player)

  const curentMove = ref(Move.X);

  const generateEmptyTable = (m: number, n: number) => {
    table.value = []

    for (let i = 0; i < m * n; i++) {
      table.value.push("E");
    }

    curentMove.value = Move.X
    isWin.value = "E"
    isGameEnd.value = false
    preNextMove();
  }

  const checkWin = () => {
    isWin.value = "E"
  }

  const changeCurrentMove = () => {
    if (curentMove.value === Move.X) {
      curentMove.value = Move.O
    } else {
      curentMove.value = Move.X
    }
  }

  const checkIfBoardIsFull = () => {
    const isFull = table.value.every((cell) => cell !== "E")

    if (isFull) {
      isGameEnd.value = true
    }

    return
  }

  const preNextMove = () => {
    if (curentMove.value === Move.O) {
      if (oPlayer.value === Player.Computer) {
        makeComputerMove();
      }
    }

    if (curentMove.value === Move.X) {
      if (xPlayer.value === Player.Computer) {
        makeComputerMove();
      }
    }
    
    checkIfBoardIsFull();
    checkWin();

  }

  const makeComputerMove = () => {
    let savedTable = table.value

    checkWin();

    for (let i = 0; i < table.value.length; i++) {
      if (table.value[i] === "E") {
        savedTable[i] = curentMove.value
        break
      }
    }

    changeCurrentMove()
    savedTable = table.value
    preNextMove()
  }

  const makeMove = (index: number) => {
    checkIfBoardIsFull();
    checkWin();

    if (isGameEnd.value) {
      return
    }

    if (table.value[index] !== "E") {
      return
    }

    if (curentMove.value === Move.X) {
      console.log("X")
      table.value[index] = "X"
    }

    if (curentMove.value === Move.O) {
      console.log("O")
      table.value[index] = "O"
    }

    changeCurrentMove();
    checkIfBoardIsFull();
    checkWin();

    if(isGameEnd.value) {
      return
    }

    preNextMove();
  }

  const resetTable = () => {
    table.value = table.value.map(() => "E")

    isWin.value = "E"
    isGameEnd.value = false
    curentMove.value = Move.X

    preNextMove();
  }

  const startGame = (m: number, n: number, x: Player, o: Player, lengthToWin: number) => {
    generateEmptyTable(m, n)
    xPlayer.value = x
    oPlayer.value = o

    meta.value = {
      m, n, lengthToWin
    }
  }

  return { table, meta, generateEmptyTable, resetTable, isWin, checkWin, makeMove, isGameEnd, curentMove, startGame }
})