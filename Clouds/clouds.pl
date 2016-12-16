:-include('board.pl').
:-include('solver.pl').

clouds:-
  solver([1,0,0],[1,0,0], Board),
  nth0(0,Board,List),
  length(List, Size),
  displayBoard(Size,Size,Board, [1,0,0], [1,0,0]).
