:- consult('./game-rules.pl').

% possible_move(+Player, +Board -PossibleMove)
% The first n will be replaced with PlayerColor -> possible move.
% possible_move(_, [], []).
possible_move(Player, ['E'|T], [Player|T]).
possible_move(Player, [H|T], [H|PossibleMove]) :-
  possible_move(Player, T, PossibleMove).

opposite_side('X', 'O').
opposite_side('O', 'X').

% all_possible_moves(+PlayerColor, +Board, -AllMoves)
% AllMoves will be matched with all possible moves for the current
% Board.
all_possible_moves(Player, Board, AllMoves) :-
  findall(Move, possible_move(Player, Board, Move), AllMoves),
  !.

% eval_board(+Board, +M, +N, +Player, +WinLength, -Value)
% Evaluates the score of the Board.
eval_board([], _, _, _, _, 0).
eval_board(Board, M, N, Player, WinLength, Value) :-
  is_winning(Player, N, M, Board, WinLength),
  Value = 1, 
  !.
eval_board(Board, M, N, Player, WinLength, Value) :-
  opposite_side(Player, OppositePlayer),
  is_winning(OppositePlayer, N, M, Board, WinLength),
  Value = -1, 
  !.
eval_board(Board, Value) :-
  \+ has_next_move(Board),
  Value is 0.

% change_max_min(+MinOrMax, TheOther)
% Changes the MinMax atom.
change_max_min(max, min).
change_max_min(min, max).

% compare_moves(+MinMax, +MoveA, +ValueA, +MoveB, +ValueB, -BetterMove, -BetterValue)
% Chooses the move with the higher value.
compare_moves(max, MoveA, ValueA, _, ValueB, MoveA, ValueA) :-
	ValueA >= ValueB.
compare_moves(max, _, ValueA, MoveB, ValueB, MoveB, ValueB) :-
	ValueA < ValueB.
compare_moves(min, MoveA, ValueA, _, ValueB, MoveA, ValueA) :-
	ValueA =< ValueB.
compare_moves(min, _, ValueA, MoveB, ValueB, MoveB, ValueB) :-
	ValueA > ValueB.

% best_move(+MinMax, +AllMoves, +M, +N, +Player, +WinLength, -BestMove, -BestValue)
% Chooses the next move.
best_move(max, [], _, _, _, _, [], -2).
best_move(min, [], _, _, _, _, [], 2).

best_move(MinMax, [Move | RestMoves], M, N, Player, WinLength, BestMove, BestValue) :-
  eval_board(Move, M, N, Player, WinLength, Value),
  best_move(MinMax, RestMoves, M, N, Player, WinLength, CurrentBestM, CurrentBestV),
	compare_moves(MinMax, Move, Value, CurrentBestM, CurrentBestV, BestMove, BestValue).

best_move(MinMax, [Move | RestMoves], M, N, Player, WinLength, BestMove, BestValue) :-
	best_move(MinMax, RestMoves, M, N, Player, WinLength, CurrentBestM, CurrentBestV),
	change_max_min(MinMax, Other),
  opposite_side(Player, OppositePlayer),
	minimax_step(Other, Move, M, N, OppositePlayer, WinLength, _, BottomBestV),
	compare_moves(MinMax, Move, BottomBestV, CurrentBestM, CurrentBestV, BestMove, BestValue).

minimax_step(MinMax, Board, M, N, Player, WinLength, BestMove, BestValue) :-
  all_possible_moves(Player, Board, AllMoves),
  best_move(MinMax, AllMoves, M, N, Player, WinLength, BestMove, BestValue), !.

minimax(Board, M, N, Player, WinLength, BestMove) :-
  minimax_step(max, Board, M, N, Player, WinLength, BestMove, _).
