:- use_module(library(lists)).

translate(0, '  ').
translate(1, ' X').


displayTop(0) :- nl.
displayTop(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write(' --'),
      displayTop(Counter1).

displayMid(0,_, NumberOfLine,ClueVertical) :-
      write('|'),
      reverse(ClueVertical, ReverseList),
      nth0(NumberOfLine, ReverseList, Clue),
      write(Clue),
      nl.

displayMid(Counter, List,NumberOfLine, ClueVertical) :-
      Counter > 0,
      Counter1 is Counter - 1,
      nth0(Counter1, List, Element),
      translate(Element, NewElement),
      write('|'),
      write(NewElement),
      displayMid(Counter1, List,NumberOfLine,ClueVertical).


displayBoardAux([]).
displayBoardAux([Clue|Rest]):-
  write('  '),
  write(Clue),
  displayBoardAux(Rest).

displayBoard(0,Tamanho, _, _, ClueHorizontal):-
  displayTop(Tamanho),
  displayBoardAux(ClueHorizontal).


displayBoard(N,Tamanho,Board, ClueVertical, ClueHorizontal):-
      N1 is N-1,
      displayTop(Tamanho),
      nth0(N1, Board, List),
      displayMid(Tamanho, List,N1, ClueVertical),
      displayBoard(N1,Tamanho, Board,ClueVertical, ClueHorizontal).
