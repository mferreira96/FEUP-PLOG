:- use_module(library(lists)).

translate(0, '  ').
translate(1, ' X').


displayTop(0) :- nl.
displayTop(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write(' --'),
      displayTop(Counter1).

displayMid(Counter,_, NumberOfLine,ClueVertical, Tamanho) :-
      Counter = Tamanho,
      write('|'),
      nth0(NumberOfLine, ClueVertical, Clue),
      write(Clue),
      nl.

displayMid(Counter, List,NumberOfLine, ClueVertical, Tamanho) :-
      Counter1 is Counter + 1,
      nth0(Counter, List, Element),
      translate(Element, NewElement),
      write('|'),
      write(NewElement),
      displayMid(Counter1, List,NumberOfLine,ClueVertical, Tamanho).


displayBoardAux([]).
displayBoardAux([Clue|Rest]):-
  write('  '),
  write(Clue),
  displayBoardAux(Rest).

displayBoard(N,Tamanho, _, _, ClueHorizontal):-
  Tamanho = N,
  displayTop(Tamanho),
  displayBoardAux(ClueHorizontal).


displayBoard(N,Tamanho,Board, ClueVertical, ClueHorizontal):-
  N1 is N + 1,
  displayTop(Tamanho),
  nth0(N, Board, List),
  displayMid(0, List,N, ClueVertical, Tamanho),
  displayBoard(N1,Tamanho, Board,ClueVertical, ClueHorizontal).
