:- use_module(library(system)).
:- use_module(library(lists)).
:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').
:- include('utils.pl').


adaptoid:-
  tabuleiro1(Board),
  % assert(Board),
  % assert() jogador
  % assert() jogador
  % assert() cor do jogador que esta a jogar
  % displayBoard(Board,0),nl,
  toMove(Board,_),
  write('please press a key to continue'),
  readCommand(_).



toMove(Board, Player):-
  write('actual position of adaptoid'),nl,
  write('please introduce the coord row = '),
  read(R),
  format("lido = ~d", [R]),nl,
  write('please introduce the coord Column = '),
  read(C),
  format('lido = ~d', [C]),nl,
  write('Next position of adaptoid'),nl,
  write('please introduce the coord row = '),
  read(Row),
  format("lido = ~d", [Row]),nl,
  write('please introduce the coord Column = '),
  read(Column),
  format('lido = ~d', [Column]),nl,
  validateMove(Board,_, Row-Column),
  moveAdaptoid(Board,_, R-C, Row-Column, NewBoard),
  displayBoard(NewBoard,0).

% Result message

winnerMessage(branco):- write('Jogador Branco é o vencedor!'),nl.
winnerMessage(preto):- write('Jogador Preto é o vencedor!'),nl.
winnerMessage(empate):- write('O jogo empatou!'),nl.

% Result announcement (falta empate)

winnerAnnouncement(Wscore,Bscore):-
      Wscore > Bscore,
      winnerMessage(branco).

winnerAnnouncement(Wscore,Bscore):-
      Bscore > Wscore,
      winnerMessage(preto).

% announce player turn
announcePlayerTurn(Color):-write('Vez do jogador '),write(Color),nl.
