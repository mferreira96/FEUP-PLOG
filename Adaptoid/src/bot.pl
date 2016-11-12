getTotalNumberOfLegs(Board, Color, TotalNumberOfLegs):-
  findall(L, getElement(Board, _,R-C,Color-L-_), Total),
  sumList(Total, TotalNumberOfLegs).

getTotalNumberOfPincers(Board, Color, TotalNumberOfLegs):-
  findall(P, getElement(Board, _,R-C,Color-_-P), Total),
  sumList(Total, TotalNumberOfLegs).

getNumberOfAdaptoidsFromTheSameplayer(Board,Color,NumberOfAdaptoids):-
  findall(Number, getElement(Board, _,R-C,Color-_-_), Total),
  length(Total, NumberOfAdaptoids).


getNumberOfStarvingAdaptoids(Board,Color, NumberOfStarvingAdaptoids).
  findall(R-C, starving(Board, Color, R-C), Adaptoids),
  length(Adaptoids, NumberOfStarvingAdaptoids).


starving(Board, Color, R-C):-
  getElement(Board,_,R-C, Color,_,_),!,
  findall(NR-NC, empetyNeighbour(Board, R-C, NR-NC), Neighbours),
  length(Neighbours, NumOfNeighbours),
  getNumberOfExtremities(Board, R-C,NumberOfExtremities),
  NumberOfExtremities > NumOfNeighbours.


sumList([],0).
sumList([Header|Rest], Result):-
      Value is ?Rest + Header,
      sumList(Rest, Value)
