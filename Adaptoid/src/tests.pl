:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').
:- include('adaptoid.pl').


teste1(Res):-
  tabuleiro1(_X),
  getEmpetyNeighbours(_X,5,5, Res).



% Is necessary test this predicate
teste2:-
  tabuleiro1(_X),
  % displayBoard(_X,0),
  removeStarvingAdaptoids(_X, 0, 0, NewBoard),
  displayBoard(NewBoard, 0).

createAdaptoid:-
  tabuleiro1(_X),
  createNewAdaptoid(_X, p,2-2, NewBoard),
  displayBoard(NewBoard,0).
