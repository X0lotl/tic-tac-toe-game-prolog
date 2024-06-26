import { Move, Player } from "~/models/player.model";
import type { Cell, Table } from "~/models/table.model";

export const useTableStore = defineStore('tableStore', () => {
  const engineBaseUrl = import.meta.env.NUXT_PUBLIC_ENGINE_BASE_URL;

  const table = ref<Table>([])

  const isWin = ref("E")

  const isGameEnd = ref(false)

  const meta = ref({
    m: 0,
    n: 0,
    lengthToWin: 0,
    difficulty: 1
  })

  const xPlayer = ref(Player.Player)
  const oPlayer = ref(Player.Player)

  const curentMove = ref(Move.X);

  const isCurentMoveComputer = computed(() => {
    if (curentMove.value === Move.X) {
      return xPlayer.value === Player.Computer
    }

    if (curentMove.value === Move.O) {
      return oPlayer.value === Player.Computer
    }

    return false
  })

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

  const checkWin = async () => {
    const response = await fetch(`http://localhost:8888/is_win`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        table: table.value.join(""),
        m: meta.value.m,
        n: meta.value.n,
        winLength: meta.value.lengthToWin,
      })
    })

    const data = await response.json()

    if (data.winner !== "E") {
      isWin.value = data.winner
      isGameEnd.value = true
    }
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

  const preNextMove = async () => {
    if (isCurentMoveComputer.value) {
      await makeComputerMove();
    }

    checkIfBoardIsFull();
    await checkWin();

  }

  const makeComputerMove = async () => {
    await checkWin();

    if (isGameEnd.value) {
      return
    }

    const response = await fetch(`http://localhost:8888/make_move`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        table: table.value.join(""),
        m: meta.value.m,
        n: meta.value.n,
        winLength: meta.value.lengthToWin,
        player: curentMove.value,
        maxDepth: meta.value.difficulty
      })
    })

    const data = await response.json()

    if (data.bestMove === "") {
      table.value = (table.value.join("").replace("E", curentMove.value)).split("") as Cell[]
    } else {
      table.value = data.bestMove.split("")
    }


    changeCurrentMove()
    await preNextMove()
  }

  const makeMove = async (index: number) => {
    checkIfBoardIsFull();
    checkWin();

    if (isGameEnd.value || isCurentMoveComputer.value) {
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
    await checkWin();

    if (isGameEnd.value) {
      return
    }

    await preNextMove();
  }

  const resetTable = async () => {
    table.value = table.value.map(() => "E")

    isWin.value = "E"
    isGameEnd.value = false
    curentMove.value = Move.X

    await preNextMove();
  }

  const startGame = async (m: number, n: number, x: Player, o: Player, lengthToWin: number, difficulty: number) => {
    meta.value = {
      m, n, lengthToWin, difficulty
    }

    generateEmptyTable(m, n)
    xPlayer.value = x
    oPlayer.value = o

    await preNextMove()

    if (xPlayer.value === Player.Computer) {
      // await makeComputerMove()
    }
  }

  return { table, meta, generateEmptyTable, resetTable, isWin, checkWin, makeMove, isGameEnd, curentMove, startGame }
})