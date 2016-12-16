:- use_module(library(clpfd)).

% solver of the game
solver(Line_Clues, Column_Clues, SolvedBoard):-

  length(Line_Clues,NLines),
  length(Column_Clues,NCols),
  length(SolvedBoard,NLines),
  createMatrix(SolvedBoard,NCols),

  checkLines(SolvedBoard,Line_Clues),

  transpose(SolvedBoard,SolvedBoard_Inveted),

  checkLines(SolvedBoard_Inveted, Column_Clues),

  append(SolvedBoard,Vars),

  labeling([],Vars).

  % at this point we already make that the sum is equal to the clues

  % there are two other restrictions to check
  % -> cloud must be at least 2 x 2
  % -> should have a white space between clouds




% create matrix with the right size
createMatrix([],_).
createMatrix([Line|Ls],NCols):-
	length(Line,NCols),
	domain(Line,0,1),
	createMatrix(Ls,NCols).


% matrix(tabuleiro) .. Lista de Clues
checkLines([],[]).
checkLines([Line|Rest],[Clue|Others]):-
  checkSum(Line, Clue),
  checkLines(Rest, Others).

%verify if sum of the Elements of list is equal to clue
checkSum(_, 0):- !.
checkSum(Line, Clue):-
  Clue \= 0, !,
  sum(Line, #=,Clue).
