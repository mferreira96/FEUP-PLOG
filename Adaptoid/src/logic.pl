
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


getElement(Board, Player, Row, Column, Element):-
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
    getElement(Board, Player, Row, Column, C - L - P),
    updateBodyOfAdaptoid(C - L - P, C - L1 - P1 ,Pincer , Leg),
    setMatrixElement(Row, Column, C - L1 - P1, Board, NewBoard).

getNumberOfExtremities(C-L-P, Number):-
  Number is L + P.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Adaptoid moves %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


moveAdaptoid(Board, Player, Row-Column, FinalRow-FinalColumn, NewBoard):-
    getElement(Board, Player, Row, Column, Adaptoid),
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
    empetyCell(Boar, Player, Row-Column).

empetyCell(Board, Player, Row-Column):-
  getElement(Board, _, Row, Column, Element),
  Element = vazio.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Compare adaptoids %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% one adaptoid can capture another one if he has more pincers
%%% C1 - L1 - P1 is the adaptoid that was already on that position
compareAdaptoids(C-L-P, C1 - L1 - P1, Winners):-
  C \= C1,
  P > P1,
  append([C-L-P], [], Winners).

compareAdaptoids(C-L-P, C1-L1-P1, Winners):-
  C \= C1,
  P1 > P,
  append([C1-L1-P1], [], Winners).

compareAdaptoids(C-L-P, C1-L1-P1, Winners):-
    P =:= P1,
    append([C-L-P], [], TempList),
    append([C1-L1-P1], TempList, Winners).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Neighbours %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

neighbourAux(Board, _ , TempRow-TempColumn, R):-
  empetyCell(Board, _, TempRow - TempColumn),
  R is 1.

neighbourAux(Board, _ , TempRow-TempColumn, R):-
  R is 0.

neighbour(Board, Row, Column, DiffRow, DiffColumn, Res):-
    TempRow is Row + DiffRow,
    TempColumn is Column + DiffColumn,
    validateCell(TempRow,TempColumn),
    neighbourAux(Board, _ , TempRow-TempColumn, Res).

getEmpetyNeighbours(Board, Row, Column, Res):-
  neighbour(Board, Row, Column,1 ,0, Res1),
  neighbour(Board, Row, Column,1 ,1, Res2),
  neighbour(Board, Row, Column,0 ,1, Res3),
  neighbour(Board, Row, Column,-1, 0, Res4),
  neighbour(Board, Row, Column,-1, -1, Res5),
  neighbour(Board, Row, Column,0, -1, Res6),
  somarRes([Res1, Res2, Res3, Res4, Res5, Res6],0 ,Res).

somarRes([],TRes, TRes).
somarRes([Head | R],TRes, Res):-
  TempRes is Head + TRes,
  somarRes(R, TempRes, Res).


updateRowAndColumn(PR-PC, FR-FC):-
    TemCol is PC + 1,
    TempCol =:= 7,
    FC is 0,
    FR is PR + 1.

updateRowAndColumn(PR-PC, FR-FC):-
    FR =:= PR,
    FC is PC +1.


removeStarvingAdaptoids(Board,StartRow, StartCol, NewBoard):-
  \+ empetyCell(Board, _ ,StartRow-StarCol ),
  getEmpetyNeighbours(Board, StartRow, StartCol, Res),
  EmpetyHome is Res,
  getElement(Board, _, StartRow, StartCol, C - L - P),
  getNumberOfExtremities(C-L-P, Number),
  Number < EmpetyHome,
  updateRowAndColumn( StartRow-StarCol, NewRow-NewCol),
  removeStarvingAdaptoids(Board,StartRow, StartCol, NewBoard).

removeStarvingAdaptoids(Board,StartRow, StartCol, NewBoard):-
  \+ empetyCell(Board, _ ,StartRow-StarCol ),
  getEmpetyNeighbours(Board, StartRow, StartCol, Res),
  EmpetyHome is Res,
  getElement(Board, _, StartRow, StartCol, C - L - P),
  getNumberOfExtremities(C-L-P, NumberExtremities),
  NumberExtremities > EmpetyHome,
  removeAdaptoid(Board,_, StartRow-StartColumn, NewBoard),
  updateRowAndColumn( StartRow-StarCol, NewRow-NewCol),
  removeStarvingAdaptoids(NewBoard ,StartRow, StartCol, NewBoard).


removeStarvingAdaptoids(Board,StartRow, StartCol, NewBoard):-
  updateRowAndColumn( StartRow-StarCol, NewRow-NewCol),
  removeStarvingAdaptoids(Board,StartRow, StartCol, NewBoard).
