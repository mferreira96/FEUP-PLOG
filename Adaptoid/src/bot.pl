
computer(Color, Mode, Board, FinalBoard):-
    chooseBestMove(Board, Mode, Color, FinalBoard).


chooseBestMove(Board, Move, Color, FinalBoard):-
    findall(TempBoard,computerMove(Board, Color,R-C,TempBoard), PossibleMovements),
    evaluateMove(Board, Color, Mode,PossibleMovements, FinalBoard).

computerMove(Board, ColorIn, R-C, FinalBoard):-
  moveWithPossibleCapture(Board,R-C, Row-Column, NewBoard, PlayerOut),
  botUpdateAdaptoid(ColorIn,R-C ,NewBoard, FinalBoard1),
  toEliminateStarvingAdaptoids(FinalBoard1,ColorIn, FinalBoard).


botUpdateAdaptoid(Color,R-C ,Board, NewBoard):-
    createNewAdaptoid(Board, Color,R-C, NewBoard).

botUpdateAdaptoid(Color,R-C ,Board, NewBoard):-
    updateAdaptoid(Board, _, R-C,0, 1, NewBoard).

botUpdateAdaptoid(Color,R-C ,Board, NewBoard):-
    updateAdaptoid(Board, _, R-C,1, 0, NewBoard).


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
    Max > Total,
    TempMax = Max,
    FinalTempBoard = TempBoard.

updateAux(PossibleBoard,TempBoard, FinalTempBoard, Max, TempMax, Total):-
    Max < Total,
    TempMax = Total,
    FinalTempBoard = PossibleBoard.


getValueOfLegs(Board,Color,ValueLegs, Value):-
    getTotalNumberOfLegs(Board, Color, Legs),
    ValueLegs is Value * Legs.

getValueOfPincers(Board,Color,ValuePincers, Value):-
    getTotalNumberOfPincers(Board, Color,Pincers),
    ValuePincers is Value * Pincers.

getValueOfAdaptoids(Board, Color, ValueAdaptoids, Value):-
    getNumberOfAdaptoidsFromTheSameplayer(Board, Color,NumberOfAdaptoids),
    ValueAdaptoids is Value * NumberOfAdaptoids.

%verificar aqui qual e a cor que se passa
getValueOfStarvingAdaptoids(Board, Color, ValueOfStarvingAdaptoids, Value):-
    getNumberOfStarvingAdaptoids(Board,Color, NumberOfStarving),
    ValueOfStarvingAdaptoids is Value * NumberOfStarving.


value(Board, Color, Total):-
    getValueOfLegs(Board,Color,Value1, 1),
    getValueOfPincers(Board,Color,Value2, 2),
    getValueOfAdaptoids(Board, Color, Value3, 3),
    getValueOfStarvingAdaptoids(Board, Color, Value4, 4),
    list_sum([Value1,Value2, Value3,Value4], Total).

getTotalNumberOfLegs(Board, Color, TotalNumberOfLegs):-
  findall(L, getElement(Board,_,R-C,Color-L-_), Total),
  list_sum(Total, TotalNumberOfLegs).

getTotalNumberOfPincers(Board, Color, TotalNumberOfLegs):-
  findall(P, getElement(Board, _,R-C,Color-_-P), Total),
  list_sum(Total, TotalNumberOfLegs).

getNumberOfAdaptoidsFromTheSameplayer(Board,Color,NumberOfAdaptoids):-
  findall(Number, getElement(Board, _,R-C,Color-_-_), Total),
  length(Total, NumberOfAdaptoids).


getNumberOfStarvingAdaptoids(Board, Color, Count):-
  findall(R-C, getElement(Board,_,R-C, Color-_-_ ), Adaptoids),
  starvingAux(Adaptoids, Board, Count).

starvingAux([], _, 0).
starvingAux([R-C|Rest], Board, Count):-
  findall(NR-NC, empetyNeighbour(Board, R-C, NR-NC), Neighbours),
  length(Neighbours, NumOfNeighbours),
  getNumberOfExtremities(Board, R-C, NumberOfExtremities),
  checkIfAdaptoidIsHungry( NumberOfExtremities, NumOfNeighbours, Answer),
  starvingAux(Rest,Board,Number),
  Count is Number + Answer.

checkIfAdaptoidIsHungry( NumberOfExtremities, NumOfNeighbours, 1):-
  NumberOfExtremities > NumOfNeighbours.

checkIfAdaptoidIsHungry( NumberOfExtremities, NumOfNeighbours, 0):-
  NumberOfExtremities =< NumOfNeighbours.

list_sum([],0).
list_sum([Head|Tail],Result) :-
    list_sum(Tail,SumOfTail),
    Result is Head + SumOfTail.
