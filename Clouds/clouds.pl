:-include('board.pl').
:-include('solver.pl').

clouds(Line_Clues, Col_Clues, Board):-
  solver(Line_Clues,Col_Clues, Board),
  nth0(0,Board,List),
  length(List, Size),
  displayBoard(0,Size,Board, Line_Clues, Col_Clues).
