:- use_module(library(system)).
:- use_module(library(lists)).
:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').
:- include('utils.pl').

:- dynamic board/1.
:- dynamic turnColor/1.
:- dynamic player/5.


adaptoid:-
  tabuleiro1(Board),
  %assert(Board),
  %assert(player)
  % assert() jogador
  % assert() cor do jogador que esta a jogar
  % displayBoard(Board,0),nl,
  repeat,
  once(play),
  displayBoard(Board,0).


play(Board):-
  displayBoard(Board,0),
  toMove(Board,_).
  toCreateOrAdd(Board,_),
  toEliminateStarvingAdaptoids(Board,Color).

toMove(Board, Player):-
  write('actual position of adaptoid'),nl,
  askCoords(R-C),
  write('Next position of adaptoid'),nl,
  askCoords(Row-Column),
  moveWithPossibleCapture(Board,R-C, Row-Column, NewBoard),
  displayBoard(NewBoard,0).


toCreateOrAdd(Board, Player):-
  write('choose your option'), nl,
  askOptionForSecondRule(Answer),
  secondRule(Answer, Board, NewBoard,p), % obter aqui a cor do jogador que esta a jogar
  displayBoard(NewBoard,0).
% criar os jogadores , para depois poder obter a cor

toEliminateStarvingAdaptoids(Board,Color):-
  removeStarvingAdaptoids(Board, Color, NewBoard),
  displayBoard(NewBoard,0).

secondRule(c, Board, NewBoard,Color):-
  write('choose the coords of the new '),nl,
  askCoords(R-C),
  createNewAdaptoid(Board, Color,R-C, NewBoard).

secondRule(l, Board, NewBoard,Color):-
  write('choose the coords of the Adaptoid'),nl,
  askCoords(R-C),
  updateAdaptoid(Board, _, R-C,0, 1, NewBoard).


secondRule(l, Board, NewBoard,Color):-
  write('choose the coords of the Adaptoid'),nl,
  askCoords(R-C),
  updateAdaptoid(Board, _, R-C,1, 0, NewBoard).


askCoords(R-C):-
  write('please introduce the coord row = '),
  read(R),
  write('please introduce the coord Column = '),
  read(C).


askOptionForSecondRule(Answer):-
  write('create a new adaptoid (c), add a Leg (l) or add a Pincer '),
  read(Answer).

% Result message

winnerMessage(branco):- write('Jogador Branco é o vencedor!'),nl.
winnerMessage(preto):- write('Jogador Preto é o vencedor!'),nl.
winnerMessage(empate):- write('O jogo empatou!'),nl.

% Result announcement (falta empate)

testWinner(_, Color):-
  player(Color,_,_,_Score),
  Score > 4.

testWinner(Board, Color):-
  findall(R-C, getElement(Board,_,R-C,Color-_-_),Adaptoids),
  Adaptoids = [].


% announce player turn
announcePlayerTurn(Color):-write('Vez do jogador '),write(Color),nl.
