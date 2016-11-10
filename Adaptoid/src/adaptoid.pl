:- use_module(library(system)).
:- use_module(library(lists)).
:- include('board.pl').
:- include('logic.pl').
:- include('interface.pl').


adaptoid:-
  tabuleiro1(Board),
  % assert(Board),
  % assert() jogador
  % assert() jogador
  % assert() cor do jogador que esta a jogar
  displayBoard(Board,0),nl,
  repeat,
    toMove(Board,_),
    write('please press a key to continue'),
    get_code(_).



toMove(Board, Player):-
  write('actual position of adaptoid'),nl,
  write('please introduce the coord x = '),
  read(R),
  format("lido = ~d", [R]),nl,
  write('please introduce the coord y = '),
  read(C),
  format("lido = ~d", [C]),nl,
  write('Next position of adaptoid'),nl,
  write('please introduce the coord x = '),
  read(Row),
  format("lido = ~d", [Row]),nl,
  write('please introduce the coord y = '),
  read(Column),
  format("lido = ~d", [Column]),nl,
  validateMove(Board,_, Row-Column),
  moveAdaptoid(Board,_, R-C, Row-Column, NewBoard).


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
