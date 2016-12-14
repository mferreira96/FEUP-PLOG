:- use_module(library(clpfd)).


solver(Line_Clues, Column_Clues, SolvedBoard):-
  %create a matrix with the correct size

  length(Line_Clues,NLines),
  length(Column_Clues,NCols),
  length(SolvedBoard,NLines),
  defineMatrix(SolvedBoard,NCols),


  



createMatrix([],_).
createMatrix([Line|Ls],NCols):-
	length(Line,NCols),
	domain(Line,0,1),
	createMatrix(Ls,NCols).
