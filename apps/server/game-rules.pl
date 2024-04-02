create_board(N, M, Board) :-
  N > 0,
  M > 0,
  Length is N * M,
  length(Board, Length),
  !.

has_next_move(Board) :-
  append(_, ['E'|_], Board), !.

create_list_n(_, 0, []).
create_list_n(Element, N, List) :-
  NextN is N - 1,
  create_list_n(Element, NextN, NextList),
  append(NextList, [Element], List), 
  !.

add_columns_separator([], _, _, []).
add_columns_separator([BoardHead|BoardTail], CurrentN, N, BoardWithSeparators) :-
  CurrentN is N - 1,
  add_columns_separator(BoardTail, 0, N, NextBoardWithSeparators),
  append([BoardHead, 'S'], NextBoardWithSeparators, BoardWithSeparators),
  !.

add_columns_separator([BoardHead|BoardTail], CurrentN, N, BoardWithSeparators) :-
  NextN is CurrentN + 1,
  add_columns_separator(BoardTail, NextN, N, NextBoardWithSeparators),
  append([BoardHead], NextBoardWithSeparators, BoardWithSeparators), 
  !.

is_winning_line(Player, N, Board, WinLength) :-
  WinLength =< N,
  add_columns_separator(Board, 0, N, BoardWithSeparators),
  create_list_n(Player, N, RepeatedList),
  append(_, T, BoardWithSeparators),
  append(RepeatedList, _, T),
  !.

is_winning_column_starting_at(_, _, _, _, 0).
is_winning_column_starting_at(Player, N, 0, [Player|RestBoard], WinLength) :-
  NextWinLength is WinLength - 1,
  NextSkip is N - 1,
  is_winning_column_starting_at(Player, N, NextSkip, RestBoard, NextWinLength), !.

is_winning_column_starting_at(Player, N, Skip, [_|Rest], WinLength) :-
  Skip > 0,
  NextSkip is Skip - 1,
  is_winning_column_starting_at(Player, N, NextSkip, Rest, WinLength), !.

is_winning_column_recursive_helper(Player, N, _, Skip, Board, WinLength) :-
  is_winning_column_starting_at(Player, N, Skip, Board, WinLength), !.

is_winning_column_recursive_helper(Player, N, M, Skip, Board, WinLength) :-
  NextSkip is Skip + 1,
  MaxSkip is (M - WinLength) * N,
  NextSkip =< MaxSkip,
  is_winning_column_recursive_helper(Player, N, M, NextSkip, Board, WinLength), 
  !.

is_winning_column(Player, N, M, Board, WinLength) :-
  is_winning_column_recursive_helper(Player, N, M, 0, Board, WinLength).

next_x(N, X, NextX) :-
  N is X + 1,
  NextX = 0, 
  !.

next_x(_, X, NextX) :-
  NextX is X + 1, 
  !.

is_winning_primary_diagonal_starting_at(_, _, _, _, _, 0).
is_winning_primary_diagonal_starting_at(Player, _, _, 0, [Player|_], 1).

is_winning_primary_diagonal_starting_at(Player, N, X, 0, [Player|RestBoard], WinLength) :-
  NextWinLength is WinLength - 1,
  NextSkip is N,
  next_x(N, X, NextX),
  NextX =\= 0,
  is_winning_primary_diagonal_starting_at(Player, N, NextX, NextSkip, RestBoard, NextWinLength),
  !.

is_winning_primary_diagonal_starting_at(Player, N, X, Skip, [_|Rest], WinLength) :-
  Skip > 0,
  NextSkip is Skip - 1,
  next_x(N, X, NextX),
  is_winning_primary_diagonal_starting_at(Player, N, NextX, NextSkip, Rest, WinLength), !.

is_winning_primary_diagonal_recursive_helper(Player, N, _, Skip, Board, WinLength) :-
  X is Skip mod N,
  is_winning_primary_diagonal_starting_at(Player, N, X, Skip, Board, WinLength), !.

is_winning_primary_diagonal_recursive_helper(Player, N, M, Skip, Board, WinLength) :-
  NextSkip is Skip + 1,
  MaxSkip is ((M - WinLength) + 1) * N,
  NextSkip =< MaxSkip,
  is_winning_primary_diagonal_recursive_helper(Player, N, M, NextSkip, Board, WinLength), 
  !.

is_winning_primary_diagonal(Player, N, M, Board, WinLength) :-
  is_winning_primary_diagonal_recursive_helper(Player, N, M, 0, Board, WinLength).

is_winning_secondary_diagonal_starting_at(_, _, _, _, _, 0).
is_winning_secondary_diagonal_starting_at(Player, _, _, 0, [Player|_], 1).

is_winning_secondary_diagonal_starting_at(Player, N, X, 0, [Player|RestBoard], WinLength) :-
  NextWinLength is WinLength - 1,
  NextSkip is N - 2,
  % X =\= 0,
  next_x(N, X, NextX),
  is_winning_secondary_diagonal_starting_at(Player, N, NextX, NextSkip, RestBoard, NextWinLength),
  !.

is_winning_secondary_diagonal_starting_at(Player, N, X, Skip, [_|Rest], WinLength) :-
  Skip > 0,
  NextSkip is Skip - 1,
  next_x(N, X, NextX),
  is_winning_secondary_diagonal_starting_at(Player, N, NextX, NextSkip, Rest, WinLength), 
  !.

is_winning_secondary_diagonal_recursive_helper(Player, N, _, Skip, Board, WinLength) :-
  X is Skip mod N,
  is_winning_secondary_diagonal_starting_at(Player, N, X, Skip, Board, WinLength), 
  !.

is_winning_secondary_diagonal_recursive_helper(Player, N, M, Skip, Board, WinLength) :-
  NextSkip is Skip + 1,
  MaxSkip is ((M - WinLength) + 1) * N,
  NextSkip =< MaxSkip,
  is_winning_secondary_diagonal_recursive_helper(Player, N, M, NextSkip, Board, WinLength), 
  !.

is_winning_secondary_diagonal(Player, N, M, Board, WinLength) :-
  is_winning_secondary_diagonal_recursive_helper(Player, N, M, 0, Board, WinLength).

% is_winning(Player, N, M, Board, WinLength)
is_winning(Player, N, _, Board, WinLength) :-
  is_winning_line(Player, N, Board, WinLength), 
  !.

is_winning(Player, N, M, Board, WinLength) :-
  is_winning_column(Player, N, M, Board, WinLength), 
  !.

is_winning(Player, N, M, Board, WinLength) :-
  is_winning_column(Player, N, M, Board, WinLength), 
  !.

is_winning(Player, N, M, Board, WinLength) :-
  is_winning_primary_diagonal(Player, N, M, Board, WinLength), 
  !.

is_winning(Player, N, M, Board, WinLength) :-
  is_winning_secondary_diagonal(Player, N, M, Board, WinLength), 
  !.
