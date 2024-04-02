:- consult('./engine.pl').

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).

:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).

:- http_handler(root(make_move), handle_make_move, []).		
:- http_handler(root(is_win), handle_is_win, []).		

server(Port) :-
  http_server(http_dispatch, [port(Port)]).

destruct_make_move_dict(_{table: Board, m: M, n: N, player: PlayerRaw, winLength: WinLength}, Board, M, N, Player, WinLength) :-
  atom_string(Player, PlayerRaw), !.

handle_make_move(Request) :-
  http_read_json_dict(Request, Input),
  destruct_make_move_dict(Input, Board, M, N, Player, WinLength),
  string_chars(Board, DestructedBoard),
  minimax(DestructedBoard, M, N, Player, WinLength, BestMove),
  string_chars(SerializedBestMove, BestMove),
  Res = _{
    bestMove: SerializedBestMove
  },
  reply_json_dict(Res).

destruct_is_win_dict(_{table: Board, m: M, n: N, winLength: WinLength}, Board, M, N, WinLength).

get_winner(Board, M, N, WinLength, 'X') :-
  is_winning('X', N, M, Board, WinLength), !.

get_winner(Board, M, N, WinLength, 'O') :-
  is_winning('O', N, M, Board, WinLength), !.

get_winner(_, _, _, _, 'E').

handle_is_win(Request) :-
  http_read_json_dict(Request, Input),
  destruct_is_win_dict(Input, Board, M, N, WinLength),
  string_chars(Board, DestructedBoard),
  get_winner(DestructedBoard, M, N, WinLength, Winner),
  Res = _{
    winner: Winner
  },
  reply_json_dict(Res).
  