:- use_module(library(system)).
:- use_module(library(lists)).

:- dynamic tabuleiro1/1.
:- dynamic player/5.
:- dynamic turnColor/1.


:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').

player(p,12,12,12,0).
player(b,12,12,12,0).
turnColor(p).


/* funçao principal do jogo*/

adaptoid:-
  retract(tabuleiro1(Board)),
  retract(player(p,12,12,12,0)),
  retract(player(b,12,12,12,0)),
  retract(turnColor(p)),
  repeat,
    once(play(Board, NewBoard, ColorIn)),
    displayBoard(NewBoard,0),
  assert(tabuleiro1(NewBoard)),
  assert(player(p,_,_,_,_)),
  assert(player(b,_,_,_,_)),
  assert(turnColor(p)), fail.


play(Board, NewBoard, ColorIn):-
  nl,
  getEnemyColor(ColorIn, ColorOut),
  displayBoard(Board,0),
  toMove(Board,Player, Board1),
  toCreateOrAdd(Board1,Player, Board2),
  toEliminateStarvingAdaptoids(Board2,Player, NewBoard).

toMove(Board, Player, NewBoard):-
  write('move adaptoid'),nl,
  write('actual position of adaptoid'),nl,
  askCoords(R-C),
  write('Next position of adaptoid'),nl,
  askCoords(Row-Column),
  moveWithPossibleCapture(Board,R-C, Row-Column, NewBoard),
  displayBoard(NewBoard,0).


toCreateOrAdd(Board, Player, NewBoard):-
  write('choose your option'), nl,
  askOptionForSecondRule(Answer),
  secondRule(Answer, Board, NewBoard,p),
  displayBoard(NewBoard,0).


toEliminateStarvingAdaptoids(Board,Player,  NewBoard):-
  getPlayerColor(Player, Color),
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


secondRule(p, Board, NewBoard,Color):-
  write('choose the coords of the Adaptoid'),nl,
  askCoords(R-C),
  updateAdaptoid(Board, _, R-C,1, 0, NewBoard).


askCoords(R-C):-
  write('please introduce the coord row = '),
  read(R),
  write('please introduce the coord Column = '),
  read(C).


askOptionForSecondRule(Answer):-
  write('create a new adaptoid (c), add a Leg (l) or add a Pincer(p) '),
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

getPlayerColor([Color,Body,Pincer, Leg, Score], Color).

getPlayerScore([Color,Body,Pincer, Leg, Score], Score).

updatePlayerScore(Points,[Color,Body,Pincer, Leg, Score], [Color,Body,Pincer, Leg, NewScore]):-
  NewScore is Points + Score.

getEnemyColor(p, b).
getEnemyColor(b, p).    
