:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').
:- include('adaptoid.pl').


teste1(Res):-
  tabuleiro1(_X),
  getEmpetyNeighbours(_X,5,5, Res).



% Is necessary test this predicate
removeStarving:-
  tabuleiro1(_X),
  % displayBoard(_X,0),
  removeStarvingAdaptoids(_X,b, NewBoard),
  displayBoard(NewBoard, 0).

createAdaptoid:-
  tabuleiro1(_X),
  createNewAdaptoid(_X, p,2-2, NewBoard),
  displayBoard(NewBoard,0).


find:-
  tabuleiro1(_X),
  getElement(_X,_,2,3, Element),
  getNuberOfLegs(Element, Leg),
  findPath(_X,2-3, 2-1,4, NewBoard),
  displayBoard(NewBoard, 0).
