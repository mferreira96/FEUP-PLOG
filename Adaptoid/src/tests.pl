:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').



teste1(Res):-
  tabuleiro1(_X),
  getEmpetyNeighbours(_X,5,5, Res).

testFindall(Adaptoids, Color):-
    tabuleiro1(X),
    findall(R-C, (getElement(X,_,R-C,Color-_-_)), Adaptoids).

% Is necessary test this predicate
removeStarving:-
  tabuleiro1(X),
  removeStarvingAdaptoids(X,b, NewBoard),
  displayBoard(NewBoard, 0).

createAdaptoid:-
  tabuleiro1(_X),
  createNewAdaptoid(_X, p,2-2, NewBoard),
  displayBoard(NewBoard,0).


find:-
  tabuleiro1(_X),
  getElement(_X,_,2-3, Element),
  getNuberOfLegs(Element, Leg),
  findPath(_X,2-3, 2-1, Leg, NewBoard),
  displayBoard(NewBoard, 0).
