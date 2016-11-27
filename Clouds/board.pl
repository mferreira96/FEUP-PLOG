:- use_module(library(lists)).

translate(vazio, ' ').
translate(cheio, 'X').




displayTop(0) :- nl.
displayTop(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write(' --'),
      displayTop(Counter1).

displayMid(0) :- nl.
displayMid(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write('|  '),
      displayMid(Counter1).

displayBoard(0,Tamanho):-displayTop(Tamanho).
displayBoard(N,Tamanho):-
      N1 is N-1,
      Mid is Tamanho+1,
      displayTop(Tamanho),
      displayMid(Mid),
      displayMid(Mid),
      displayBoard(N1,Tamanho).

fillList(0,_,[]).
fillList(N,X,[X|Xs]) :-
      N > 0,
      N1 is N-1,
      fillList(N1,X,Xs).

createBoard(_, 0,[]).
createBoard(Tamanho,Counter,[X|Xs]):-
    Counter > 0,
    Counter1 is Counter - 1,
    fillList(Tamanho,vazio,X),
    createBoard(Tamanho, Counter1, Xs, NewBoard).

    // melhor utilizar append


teste(Tamanho):-
    createBoard(Tamanho, Tamanho, Board),
    format('~w ', [Board]), nl.
