:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').
:- include('adaptoid.pl').


adaptoid:-
  askCoord.


teste1:-
  tabuleiro1(_X),
  checkNeighbours(_X, 5, 5 , Resposta).
