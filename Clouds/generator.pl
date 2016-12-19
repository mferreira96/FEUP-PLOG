:- use_module(library(clpfd)).       

generator(Nlines,Ncols,Llines,Lcols,Lfinal):-
        length(Llines,Nlines),
        length(Lcols,Ncols),
        domain(Llines,0,Nlines),
        domain(Lcols,0,Ncols),
        labeling([],Llines),
        labeling([],Lcols),
        append(Llines,Lcols,Lfinal).
