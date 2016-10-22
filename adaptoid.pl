:- include('board.pl').
:- include('logic.pl').

adaptoid:-
  tabuleiro(_X),
  %% displayBoard(_X, 0),
  moveAdaptoid(_X, _ , 3 - 1, 1 - 5, Y),
  updateAdaptoid(Y, _ , 1 - 5 , 1 , 2 , Y1),
  displayBoard(Y1, 0).
