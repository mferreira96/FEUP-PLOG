:- use_module(library(lists)).

translate(0, '  ').
translate(1, 'X').
translate(none , '  ').


displayTop(0) :- nl.
displayTop(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write(' --'),
      displayTop(Counter1).

displayMid(0,_) :- write('|'), nl.
displayMid(Counter, List) :-
      Counter > 0,
      Counter1 is Counter - 1,
      nth0(Counter1, List, Element),
      translate(Element, NewElement),
      write('|'),
      write(NewElement),
      displayMid(Counter1, List).

displayBoard(0,Tamanho, _):-displayTop(Tamanho).
displayBoard(N,Tamanho,Board):-
      N1 is N-1,
      Mid is Tamanho+1,
      displayTop(Tamanho),
      nth0(N1, Board, List),
      displayMid(Tamanho, List),
      displayBoard(N1,Tamanho, Board).

fillList(0,_,[]).
fillList(N,X,[X|Xs]) :-
      N > 0,
      N1 is N-1,
      fillList(N1,X,Xs).

createBoard(_, 0,Board, Board).
createBoard(Tamanho,Counter,Board, NewBoard):-
    Counter > 0,
    Counter1 is Counter - 1,
    fillList(Tamanho,0,FilledList),
    append(Board,[FilledList], Board1),
    createBoard(Tamanho, Counter1,Board1, NewBoard).



teste(Tamanho):-
    createBoard(Tamanho, Tamanho, [], NewBoard),
    displayBoard(Tamanho, Tamanho, NewBoard).
