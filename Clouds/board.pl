:- use_module(library(lists)).

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
        
