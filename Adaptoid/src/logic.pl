
%%%%%%%%%%%%%%%%%%%%%%%%
%%% listManipulation %%%
%%%%%%%%%%%%%%%%%%%%%%%%

setMatrixElement(0, Col, NewElement, [Head| Rest], [NewHead| Rest]):-
  setListElemt(Col, NewElement, Head , NewHead).

setMatrixElement(Row, Col, NewElement, [Head| Rest], [Head| RRest]):-
  Row >  0,
  Row1 is Row - 1,
  setMatrixElement(Row1, Col, NewElement, Rest, RRest).

setListElemt(0, NewElem, [_|L], [NewElem|L]).
setListElemt(Col, NewElem, [H|L], [H|R]):-
  Col > 0,
  Col1 is Col -1,
  setListElemt(Col1, NewElem, L, R).


getElement(Board, Player, Row - Column, Element):-
    nth0(Row, Board, List),
    nth0(Column, List, Element).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Update Adaptoid %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Adaptoid -> C (color) - L (Leg) - P (Pincer)
updateBodyOfAdaptoid(C - L - P, C - L1 - P1, Pincer, Leg):-
      L1 is L + Leg,
      P1 is P + Pincer.

updateAdaptoid(Board, Player, Row-Column,Pincer, Leg, NewBoard):-
    getElement(Board, Player, Row - Column, C - L - P),
    updateBodyOfAdaptoid(C - L - P, C - L1 - P1 ,Pincer , Leg),
    setMatrixElement(Row, Column, C - L1 - P1, Board, NewBoard).

getNumberOfExtremities(Board, R-C, Number):-
  getElement(Board, _, R-C,_-L-P),
  Number is L + P.

getNuberOfLegs(C-L-P, Legs):-
  Legs is L.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Adaptoid moves %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


moveAdaptoid(Board, Player, Row-Column, FinalRow-FinalColumn, NewBoard):-
    getElement(Board, Player, Row - Column, Adaptoid),
    setMatrixElement(Row, Column, vazio, Board, TempBoard),
    setMatrixElement(FinalRow, FinalColumn, Adaptoid, TempBoard, NewBoard).


removeAdaptoid(Board, Player, Row-Column, NewBoard):-
      setMatrixElement(Row, Column, vazio, Board, NewBoard).

validateColumn(Column, Row):-
  Row < 4,
  Column < 7,
  (Row + Column) > 2.

validateColumn(Column, Row):-
  Row > 3,
  Column < 7,
  (Row - Column) < 4.

validateRow(Row):-
    Row > -1,
    Row < 7.

validateCell(Row, Column):-
  validateRow(Row),
  validateColumn(Column, Row).

validateMove(Board,Player, Row-Column):-
    validateCell(Row, Column),
    empetyCell(Board, Player, Row-Column).

empetyCell(Board, Player, Row-Column):-
  getElement(Board, _, Row - Column, Element),
  Element = vazio.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Compare adaptoids %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% one adaptoid can capture another one if he has more pincers
%%% C1 - L1 - P1 is the adaptoid that was already on that position
compareAdaptoids(C-L-P, C1 - L1 - P1, Winners):-
  \+sameColor(C,C1),
  P > P1,
  append([C-L-P], [], Winners).

compareAdaptoids(C-L-P, C1-L1-P1, Winners):-
  \+sameColor(C,C1),
  P1 > P,
  append([C1-L1-P1], [], Winners).

compareAdaptoids(C-L-P, C1-L1-P1, Winners):-
    P =:= P1,
    append([C-L-P], [], TempList),
    append([C1-L1-P1], TempList, Winners).

sameColor(Color, ColorEnemy):-
      Color = ColorEnemy.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Neighbours %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



empetyNeighbour(Board,R-C , NeighbourRow-NeghbourColumn):-
  neighbourRowColumn(R-C, NeighbourRow-NeghbourColumn),
  getElement(Board,_,NeighbourRow-NeghbourColumn, vazio).


removeStarvingAdaptoids(Board, Color, NewBoard):-
  findall(R-C, getElement(Board,_,R-C, Color-_-_ ), Adaptoids),
  length(Adaptoids, Tamanho),
  format('Adaptoids -- ~d',[Tamanho]),nl,
  captureStarvingAdaptoid(Adaptoids, Board, NewBoard).

captureStarvingAdaptoid([], Board, Board).
captureStarvingAdaptoid([R-C|Rest], Board, NewBoard):-
  findall(NR-NC, empetyNeighbour(Board, R-C, NR-NC), Neighbours),
  length(Neighbours, NumOfNeighbours),
  format('tamanho ~d', [NumOfNeighbours]),nl ,
  getNumberOfExtremities(Board, R-C, NumberOfExtremities),
  captureAdaptoid(Board,TempBoard, R-C, NumOfNeighbours, NumberOfExtremities),
  captureStarvingAdaptoid(Rest, TempBoard, NewBoard).

%% depois é necessario mudar a pontuação dos jogadores aqui

captureAdaptoid(Board,NewBoard, R-C, NumOfNeighbours, NumberOfExtremities):-
  NumberOfExtremities > NumOfNeighbours,
  format('extremiites ~d Neighbours ~d', [NumberOfExtremities,NumOfNeighbours]),
  removeAdaptoid(Board,_, R-C, NewBoard).

captureAdaptoid(Board,Board, _, NumOfNeighbours, NumberOfExtremities):-
    NumberOfExtremities =< NumOfNeighbours.


neighbourRowColumn(PR-PC, FR-FC):-
  FR is PR + 1, FC is PC.
neighbourRowColumn(PR-PC, FR-FC):-
  FR is PR + 1, FC is PC + 1.
neighbourRowColumn(PR-PC, FR-FC):-
  FR is PR , FC is PC + 1.
neighbourRowColumn(PR-PC, FR-FC):-
  FR is PR - 1, FC is PC.
neighbourRowColumn(PR-PC, FR-FC):-
  FR is PR - 1, FC is PC -1.
neighbourRowColumn(PR-PC, FR-FC):-
  FR is PR, FC is PC -1.


neighbourIsSameColor(Board, Row-Column, Color):-
  neighbourRowColumn(Row-Column, FinalRow-FinalColumn),
  getElement(Board, _, FinalRow - FinalColumn, C-L-P),
  sameColor(Color, C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% New adaptoid %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


createNewAdaptoid(Board, Color,R-C, NewBoard):-
  empetyCell(Board, _, R-C),!,
  neighbourIsSameColor(Board, R-C, Color),
  setMatrixElement(R, C, Color-0-0,Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% PATH %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% check

findPath(Board,StartRow-StartCol, FinalRow-FinalColumn, DistMax, NewBoard):-
  getElement(Board, _ , StartRow-StartCol, C-_-_),
  (empetyCell(Board,_,FinalRow-FinalColumn); (getElement(Board,_,FinalRow - FinalColumn, C1-L-P), \+sameColor(C,C1))),
  auxiliarPath(Board,StartRow-StartCol, FinalRow-FinalColumn, DistMax, [StartRow-StartCol], FinalList),
  moveAdaptoid(Board, _, StartRow-StartCol, FinalRow-FinalColumn, NewBoard).


auxiliarPath(Board,StartNode, FinalNode, Dist, List, FinalList):-
  Dist > 1,
  neighbourRowColumn(StartNode, NextNode),
  (NextNode \= FinalNode ),
  getElement(Board,_,NextNode,Element),
  Element = vazio,
  \+(member(NextNode, List)),
  append(List, [NextNode], TempList),
  TempDist is Dist - 1,
  auxiliarPath(Board, NextNode, FinalNode, TempDist, TempList, FinalList).

auxiliarPath(Board,StartNode, FinalNode, Dist, List, FinalList):-
  Dist >= 0,
  neighbourRowColumn(StartNode, FinalNode),
  append(List, [FinalNode], FinalList).
