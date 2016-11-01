:- use_module(library(system)).
:- use_module(library(lists)).
:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').


% adaptoid:-
  % tabuleiro(_X),
  % toMove(_X, _).



  %% displayBoard(_X, 0),
  % moveAdaptoid(_X, _ , 3 - 1, 1 - 5, Y),
  % removeAdaptoid(Y, _ , 1 - 5, T),
  % displayBoard(T, 0).

% needded to be tested

toMove(Board, Player):-
  askCoords,
  readCommand(R),
  askNextCoords,
  readCommand(Row),
  validateMove(Board, Player, Row-Column),
  moveAdaptoid(Board, Player, R-C, Row-Column, NewBoard).
