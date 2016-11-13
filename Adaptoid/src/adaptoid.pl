:- use_module(library(system)).
:- use_module(library(lists)).
:- use_module(library(random)).

:- dynamic tabuleiro1/1.
:- dynamic player/5.
:- dynamic turnColor/1.

:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').
:- include('bot.pl').


/* funçao principal do jogo*/
adaptoid:-
  startMenu.

teste:-
  tabuleiro1(X),
  value(X,p, Total).


game(Mode, Difficult):-
  tabuleiro1(Board),
  assert(tabuleiro1(Board)),
  assert(player(p,12,12,12,0)),
  assert(player(b,12,12,12,0)),
  assert(turnColor(p)),
  repeat,
    write('please press Enter'),
    get_code(_),
    turnColor(ColorIn),
    once(play(Mode, ColorIn, Difficult)),
    getEnemyColor(ColorIn, ColorOut),
    retract(turnColor(ColorIn)),
    assert(turnColor(ColorOut)),
    showScores,
    testWinner(NewBoard,ColorIn),

  retract(tabuleiro1(_)),
  retract(player(p,_,_,_,_)),
  retract(player(b,_,_,_,_)),
  retract(turnColor(_)).

play(hh,ColorIn, _):-
  nl,
  announcePlayerTurn,
  tabuleiro1(Board),
  %displayBoard(Board,0),
  toMove(Board,ColorIn, Board1),
  toCreateOrAdd(Board1,ColorIn, Board2),
  toEliminateStarvingAdaptoids(Board2,ColorIn, NewBoard),
  updateBoard(NewBoard).

/* play(hh,ColorIn,Level)*/
play(ch,b,_):-
  nl,
  announcePlayerTurn,
  tabuleiro1(Board),
  %displayBoard(Board,0),
  toMove(Board,b, Board1),
  toCreateOrAdd(Board1,b, Board2),
  toEliminateStarvingAdaptoids(Board2,b, NewBoard),
  updateBoard(NewBoard).

play(ch,p,Level-_):-
  nl,
  announcePlayerTurn,
  tabuleiro1(Board),
  %displayBoard(Board,0),
  computer(p, Level, Board, NewBoard),
  write('wuadadf'),
  get_code(_),
  updateBoard(NewBoard).


play(cc,p,Level1-_):-
  nl,
  announcePlayerTurn,
  tabuleiro1(Board),
  displayBoard(Board,0),
  computer(p, Level1, Board, NewBoard),
  updateBoard(NewBoard).

play(cc,b,_-Level2):-
  nl,
  announcePlayerTurn,
  tabuleiro1(Board),
  displayBoard(Board,0),
  computer(b, Level2, Board, NewBoard),
  updateBoard(NewBoard).

toMove(Board, ColorIn, NewBoard):-
  write('move adaptoid'),nl,
  write('actual position of adaptoid'),nl,
  askCoords(R-C),
  write('Next position of adaptoid'),nl,
  askCoords(Row-Column),
  moveWithPossibleCapture(Board,R-C, Row-Column, NewBoard, PlayerOut),
  updatePlayer(PlayerOut),
  %displayBoard(NewBoard,0),
  get_char(_).


toCreateOrAdd(Board, ColorIn, NewBoard):-
  write('choose your option'), nl,
  askOptionForSecondRule(Answer),
  secondRule(Answer, Board, NewBoard,p),
  %displayBoard(NewBoard,0),
  get_char(_).


toEliminateStarvingAdaptoids(Board,ColorIn,  NewBoard):-
  getEnemyColor(ColorIn, ColorOut),
  removeStarvingAdaptoids(Board, ColorOut, NewBoard, PlayerOut),
  updatePlayer(PlayerOut),
  %displayBoard(NewBoard,0),
  get_char(_).

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

winnerMessage(b):- write('Jogador Branco e o vencedor!'),nl.
winnerMessage(p):- write('Jogador Preto e o vencedor!'),nl.
winnerMessage(empate):- write('O jogo empatou!'),nl.



testWinner(_, Color):-
  player(Color,_,_,_,Score),
  Score > 4, !,
  winnerMessage(Color).

testWinner(Board, Color):-
  findall(R-C, getElement(Board,_,R-C,Color-_-_),Adaptoids),
  Adaptoids = [],!,
  winnerMessage(Color).


% announce player turn
announcePlayerTurn:-
  turnColor(Color),
  write('Vez do jogador com a cor '),
  write(Color),
  nl.

updatePlayer([Color,Body,Pincer, Leg, Score]):-
  retract(player(Color,_,_,_,_)),
  assert(player(Color, Body, Pincer, Leg, Score)).

updateBoard(NewBoard):-
    retract(tabuleiro1(_)),
    assert(tabuleiro1(NewBoard)).

getPlayerColor([Color,Body,Pincer, Leg, Score], Color).

getPlayerScore([Color,Body,Pincer, Leg, Score], Score).

updatePlayerScore(Points,[Color,Body,Pincer, Leg, Score], [Color,Body,Pincer, Leg, NewScore]):-
  NewScore is Points + Score.

getEnemyColor(p, b).
getEnemyColor(b, p).

getPlayerByIsColor(Player, Color):-
  player(Color,Body, Pincer, Leg, Score),
  Player = [Color, Body, Pincer, Leg, Score].

showScores:-
    getPlayerByIsColor(Player,p),
    getPlayerByIsColor(Enemy, b),
    getPlayerScore(Player,Score1),
    getPlayerScore(Enemy,Score2),
    format('Score of Black player is ~d', [Score2]), nl,
    format('Score of White player is ~d', [Score1]), nl.
