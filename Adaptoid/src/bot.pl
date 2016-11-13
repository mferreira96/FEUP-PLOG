
computer(Color, Mode, Board, FinalBoard):-
    %displayBoard(Board, 0),
    chooseBestMove(Board, Mode, Color, FinalBoard).


chooseBestMove(Board, Move, Color, FinalBoard):-
    findall(FinalBoard,computerMove(Board, Color,R-C,FinalBoard), PossibleMovements),
    evaluateMove(Board, Color, Mode,PossibleMovements, FinalBoard).

computerMove(Board, ColorIn, R-C, FinalBoard):-
  moveWithPossibleCapture(Board,R-C, Row-Column, NewBoard),
  botUpdateAdaptoid(Color,R-C ,NewBoard, NewBoard1),
  toEliminateStarvingAdaptoids(NewBoard1,ColorIn, FinalBoard).


botUpdateAdaptoid(Color,R-C ,Board, NewBoard):-
    createNewAdaptoid(Board, Color,R-C, NewBoard).

botUpdateAdaptoid(Color,R-C ,Board, NewBoard):-
    updateAdaptoid(Board, _, R-C,0, 1, NewBoard).

botUpdateAdaptoid(Color,R-C ,Board, NewBoard):-
    updateAdaptoid(Board, _, R-C,0, 1, NewBoard).


evaluateMove(Board, Color, hard,PossibleMovements, FinalBoard):-
  sortPossibilities(PossibleMovements, FinalBoard).

evaluateMove(Board, Color, medium,PossibleMovements, FinalBoard):-
  random_member(FinalBoard, PossibleMovements).


sortPossibilities(PossibleMovements,FinalBoard):-
    turnColor(Color),
    sortAux(PossibleMovements,Color,[],FinalBoard, 0).

sortAux([],_, TempBoard, TempBoard, _).
sortAux([Possible| Rest], Color, TempBoard, FinalBoard, Max):-
    value(Possible, Color, Total),
    updateAux(PossibleBoard, TempBoard, FinalTempBoard, Max,TempMax ,Total),
    sortAux(Rest, Color, FinalTempBoard, FinalBoard, TempMax).


updateAux(PossibleBoard,TempBoard, FinalTempBoard, Max, TempMax, Total):-
    Max > Tolal,
    TempMax is Max,
    FinalTempBoard is TempBoard.

updateAux(PossibleBoard,TempBoard, FinalTempBoard, Max, TempMax, Total):-
    Max < Tolal,
    TempMax is Total,
    FinalTempBoard is PossibleBoard.


getValueOfLegs(Board,Color,ValueLegs, Value):-
    getTotalNumberOfLegs(Board, Color, Legs),
    ValueLegs is Value * Legs.

getValueOfLegs(Board,Color,ValuePincers, Value):-
    getTotalNumberOfPincers(Board, Color,Pincers),
    ValuePicers is Value * Pincers.

getValueOfAdaptoids(Board, Color, ValueAdaptoids, Value):-
    getNumberOfAdaptoidsFromTheSameplayer(Board, Color,NumberOfAdaptoids),
    ValueAdaptoids is Value * NumberOfAdaptoids.

%verificar aqui qual e a cor que se passa
getValueOfStarvingAdaptoids(Board, Color, ValueOfStarvingAdaptoids, Value):-
    getNumberOfStarvingAdaptoids(Board,Color, NumberOfStarving),
    ValueOfStarvingAdaptoids is Value * NumberOfStarving.


value(Board, Color, Total):-
    getTotalNumberOfLegs(Board,Color,Value1, 1),
    getTotalNumberOfPincers(Board,Color,Value2, 2),
    getValueOfAdaptoids(Board, Color, Value3, 3),
    getValueOfStarvingAdaptoids(Board, Color, Value4, 4),
    sumList([Value1,Value2, Value3,Value4], Total).

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


  list_sum([], 0).
  list_sum([Head | Tail], TotalSum) :-
      list_sum(Tail, Sum1),
      Total is Head + Sum1.
