
%%% addLeg(Board, Player, Coords, NewBoard).

%%% addPincer(Board, Player, Coords, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%
%%% listManipulation %%%
%%%%%%%%%%%%%%%%%%%%%%%%

setMatrixElement(0, Col, NewElement, [Head| Rest], [NewHead| Rest]):-
  setListElemt(Col, NewElement, Head , NewHead).

setMatrixElement(Row, Col, NewElement, [Head| Rest], [Head| RRest]):-
  Row >  0,
  Row1 is Row - 1,
  setMatrixElement(Row1, Col, NewElement, Rest, RRest).

setListElemt(0, NewElem, [_|L], [Elem|L]).
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



getAdaptoid(Board, Player, Row, Column, Adaptoid):-
    findElement(Row, Board, List),
    findElement(Column, List, Adaptoid).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Update Adaptoid %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Adaptoid -> C (color) - L (Leg) - P (Pincer)
updateAdaptoid(C - L - P, C - L1 - P1, Pincer, Leg):-
      L1 is L + Leg,
      P1 is P + Pincer.

moveAdaptoid(Board, Player, Row-Column, FinalRow-FinalColumn, NewBoard):-
    getAdaptoid(Board, Player, Row, Column, Adaptoid),
    setMatrixElement(Row, Column, [vazio], Board, TempBoard),
    setMatrixElement(FinalRow, FinalColumn, Adaptoid, TempBoard, NewBoard).
