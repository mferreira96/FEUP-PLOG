:- use_module(library(clpfd)).

generator(Nlines,Ncols,Clue_Lines,Clue_Cols,):-
        length(Clue_Lines,Nlines),
        length(Clue_Cols,Ncols),
        domain(Clue_Lines,0,Nlines),
        domain(Clue_Cols,0,Ncols),
        labeling([],Clue_Lines),
        labeling([],Clue_Cols).
