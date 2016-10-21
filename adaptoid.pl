:- include('board.pl').
:- include('logic.pl').

adaptoid:-
  tabuleiro(_X),
  %% displayBoard(_X, 0),
  moveAdaptoid(_X, _ , 3 - 1, 1 - 5, Y),
  displayBoard(Y, 0).
