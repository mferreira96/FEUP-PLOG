:- use_module(library(clpfd)).

% solver of the game
solver(Line_Clues, Column_Clues, SolvedBoard):-

  length(Line_Clues,NLines),
  length(Column_Clues,NCols),
  length(SolvedBoard,NLines),
  createMatrix(SolvedBoard,NCols),

  checkLines(SolvedBoard,Line_Clues),

  transpose(SolvedBoard,SolvedBoard_Inverted),

  checkLines(SolvedBoard_Inverted, Column_Clues),

  append(SolvedBoard_Inverted,Vars),

  reset_timer,

  labeling([],Vars),

  print_time,
  fd_statistics.


  % at this point we already make that the sum is equal to the clues

  % there are two other restrictions to check
  % -> cloud must be at least 2 x 2
  % -> should have a white space between clouds

%Get an element based on coords from a 2d list
getBoardElem(1-Col,[H|_],Color):- nth0(Col,H,Color).
getBoardElem(Line-Col,[_|Hs],Color):-
        Line > 1,
        Line1 is Line - 1,
        getBoardElem(Line1-Col,Hs,Color).



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


checkClouds(_, _, NLines - _, LineIndex-_):-
  LineIndex > NLines.

checkClouds(Lines, Cols, NLines - NCols, LineIndex-ColIndex):-
  ColIndex = NCols,
  AuxLine is LineIndex + 1,
  checkClouds(Lines, Cols, NLines - NCols, AuxLine-0):-

checkClouds(Lines, Cols, NLines - NCols, LineIndex-ColIndex):-
  LineIndex < NLines,
  ColIndex < NCols,

  checkIfIsFirst(Lines, LineIndex-ColIndex,IsFirst),

  checkIfCloudIsCorrect(Lines, Cols,NLines - Ncols, LineIndex-ColIndex, Correct),

  AuxCol is ColIndex + 1,
  checkClouds(Lines, Cols, NLines-NCols, LineIndex-AuxCol).



%% verify if is first and also verify if there is no other cloud  withou space

checkIfIsFirst(0 - 0, Matrix, IsFirst):-
  %caso seja o primeiro

checkIfIsFirst(LineIndex - 0, Matrix, IsFirst):-
  % caso esteja na primeira coluna e na tenha mais nada por cima pintado


checkIfIsFirst(LineIndex - ColIndex, Matrix, IsFirst):-
    LineIndex >= 0,
    ColIndex >= 0,

    AuxLine is LineIndex - 1,
    AuxCol is ColIndex - 1,


%% verify if the cloud as the proper  size
checkIfCloudIsCorrect(Lines, Cols,NLines - Ncols, LineIndex-ColIndex, Correct).


%% STATISTICS %%%

reset_timer :- statistics(walltime,_).
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.
