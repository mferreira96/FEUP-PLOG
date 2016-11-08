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




