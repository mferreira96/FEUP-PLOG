
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


findElement(0, [Head|Rest], Result):-
    Result = Head.

findElement(Pos, [Head|Rest], Result):-
  Pos > 0,
  Pos1 is Pos - 1,
  findElement(Pos1, Rest, Result).


getElement(Board, Player, Row, Column, Element):-
    findElement(Row, Board, List),
    findElement(Column, List, Element).

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
    getElement(Board, Player, Row, Column, Element),
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
