:-include('board.pl').
:-include('solver.pl').
:-include('boardsTest.pl').

clouds(N):-
  number(N),
  getBoard(N, Vertical_Clues, Horizontal_Clues),
  solver(Vertical_Clues,Horizontal_Clues, Board),
  nth0(0,Board,List),
  length(List, Size),
  displayBoard(0,Size,Board, Vertical_Clues, Horizontal_Clues).


clouds(Line_Clues, Col_Clues):-
  checkCorrectInputOfClues(Line_Clues),
  checkCorrectInputOfClues(Col_Clues),
  solver(Line_Clues,Col_Clues, Board),
  nth0(0,Board,List),
  length(List, Size),
  displayBoard(0,Size,Board, Line_Clues, Col_Clues).

checkCorrectInputOfClues([]).
checkCorrectInputOfClues([Value|Rest]):-
    number(Value),
    checkCorrectInputOfClues(Rest).
