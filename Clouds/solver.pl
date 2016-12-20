:- use_module(library(clpfd)).
:- use_module(library(lists)).
% solver of the game
solver(Line_Clues, Column_Clues, SolvedBoard):-

  length(Line_Clues,NLines),
  length(Column_Clues,NCols),
  length(SolvedBoard,NLines),
  createMatrix(SolvedBoard,NCols),

  checkLines(SolvedBoard,Line_Clues),

  transpose(SolvedBoard,SolvedBoard_Inverted),

  checkLines(SolvedBoard_Inverted, Column_Clues),

  checkClouds(SolvedBoard, SolvedBoard, NLines-NCols, 0-0),

  append(SolvedBoard,Vars),

  reset_timer,

  labeling([],Vars),

  print_time,
  fd_statistics.




%Get an element based on coords from a 2d list
getBoardElem(LineIndex-ColIndex,Matrix,Color):-
   nth0(LineIndex, Matrix, Line),
   nth0(ColIndex,Line,Color), !.


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
  ColIndex #= NCols,
  AuxLine is LineIndex + 1,
  checkClouds(Lines, Cols, NLines - NCols, AuxLine-0).

checkClouds(Lines, Cols, NLines - NCols, LineIndex-ColIndex):-
  LineIndex < NLines,
  ColIndex < NCols,


  checkIfIsFirst(LineIndex-ColIndex,Lines,IsFirst),

  checkIfCloudIsCorrect(Lines, Cols,NLines - NCols, LineIndex-ColIndex, Correct),

  Correct #<=> IsFirst,

  AuxCol is ColIndex + 1,
  checkClouds(Lines, Cols, NLines-NCols, LineIndex-AuxCol).



%% verify if is first and also verify if there is no other cloud  withou space

checkIfIsFirst(0 - 0, Matrix, IsFirst):-
  %caso seja o primeiro
  getBoardElem(0-0,Matrix,House),
  write(1),nl,
  (House #= 1) #<=> IsFirst.

checkIfIsFirst(0 - ColIndex, Matrix, IsFirst):-
  % caso esteja na primeira coluna e na tenha mais nada por cima pintado
  ColIndex > 0,

  AuxCol is ColIndex - 1,
  getBoardElem(0 - ColIndex,Matrix, House),
  getBoardElem(0 - AuxCol,Matrix, LeftHouse),
  write(2),nl,
  ((House #= 1) #/\ (LeftHouse #= 0)) #<=> IsFirst.

checkIfIsFirst(LineIndex - 0, Matrix, IsFirst):-
  % caso esteja na primeira coluna e na tenha mais nada por cima pintado
  LineIndex > 0,

  AuxLine is LineIndex - 1,
  getBoardElem(LineIndex - 0,Matrix, House),
  getBoardElem(AuxLine - 0,Matrix, UpHouse),
  write(3),nl,
  ((House #= 1) #/\ (UpHouse #= 0)) #<=> IsFirst.


checkIfIsFirst(LineIndex - ColIndex, Matrix, IsFirst):-
    LineIndex > 0,
    ColIndex > 0,

    AuxLine is LineIndex - 1,
    AuxCol is ColIndex - 1,

    getBoardElem(LineIndex-ColIndex,Matrix,House),
    getBoardElem(AuxLine-ColIndex,Matrix,UpHouse),
    getBoardElem(LineIndex-AuxCol,Matrix,LeftHouse),
    getBoardElem(AuxLine-AuxCol,Matrix,DiagonalHouse),
    write(4),nl,
    %% this way i can verify if the current house is the first when i look for it fromthe left to the right...up ..down
        write(House), write('-'),write(UpHouse), write('-'),write(LeftHouse), write('-'),write(DiagonalHouse),nl,
    ((House #= 1) #/\ (UpHouse #= 0) #/\ (LeftHouse #= 0) #/\ (DiagonalHouse #= 0)) #<=> IsFirst.

%% verify if the cloud as the proper  size
checkIfCloudIsCorrect(Lines, Cols,NLines - NCols, LineIndex-ColIndex, Correct):-
  % it is necessary tio check the width and the height on the begin and on the end of every cloud, because the clous should be a rectangle

  getCloudWidth(LineIndex-ColIndex, NLines-NCols, Lines, 0, WidthTop, 0),

  getCloudHeight(LineIndex-ColIndex, NLines-NCols, Lines, 0, HeightLeft, 0),

  AuxLine is LineIndex + HeightLeft -1,
write('sim .....'),write(WidthTop),write('-'), write(HeightLeft),nl,
  getCloudWidth(AuxLine-ColIndex, NLines-NCols, Lines, 0, WidthBottom, 0),

  AuxCol is ColIndex + WidthTop -1,
  getCloudHeight(LineIndex-AuxCol, NLines-NCols, Lines, 0, HeightRight, 0),

  ((WidthTop #>= 2) #/\ (HeightLeft #>= 2) #/\ (WidthTop #= WidthBottom) #/\ (HeightLeft #= HeightRight)) #<=> Correct.




% returns the width  of the cloud

getCloudWidth(_-_, _-_, _,Updated,Updated,1):-!.
getCloudWidth(LineIndex-ColIndex, NLines-NCols, Matrix,Aux, Final,0):-
  ColIndex #< NCols,
  getBoardElem(LineIndex-ColIndex, Matrix, Color),!,
  updateValue(Color,Aux, Updated, End),
  AuxCol is ColIndex + 1,
  getCloudWidth(LineIndex-AuxCol, NLines-NCols, Matrix,Updated, Final,End).

getCloudWidth(_-ColIndex, _-NCols, _,Aux, Aux,0):-
  ColIndex #= NCols.

% returns the height  of the cloud

getCloudHeight(_-_, _-_, _,Updated,Updated,1):-!.
getCloudHeight(LineIndex-ColIndex, NLines-NCols, Matrix,Aux, Final,0):-
  LineIndex #< NLines,
  getBoardElem(LineIndex-ColIndex, Matrix, Color),!,
  updateValue(Color,Aux, Updated, End),
  AuxLine is LineIndex + 1,
  getCloudHeight(AuxLine-ColIndex , NLines-NCols, Matrix,Updated, Final,End).

getCloudHeight(LineIndex-_, NLines-_, _,Aux, Aux,0):-
  LineIndex #= NLines.

updateValue(1,Aux, Updated, 0):-
  Updated is Aux + 1 .

updateValue(0,Aux, Aux, 1).




teste(Matrix, LineIndex,ColIndex, NLines,NCols, Width, Height):-
getCloudWidth(LineIndex-ColIndex, NLines-NCols, Matrix,0, Width,0),
getCloudHeight(LineIndex-ColIndex, NLines-NCols, Matrix,0, Height,0).

%% STATISTICS %%%

reset_timer :- statistics(walltime,_).
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.
