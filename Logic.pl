moveAdaptoid(Board, Player, ListInitialCoords, ListFinalCoords, NewBoard).

addLeg(Board, Player, Coords, NewBoard).

addPincer(Board, Player, Coords, NewBoard).

getAdaptoid(Board, Player, CoordX, CoordY, Adaptoid).

removeAdaptoid(Board, Player, Coords, NewBoard).

putAdaptoid(Board, Player, Coords, NewBoard).

editCell(Board, Remove, Put, Coords, NewBoard).

updateAdaptoid(Adaptoid, NewAdaptoid, Pincer, Leg).


%%% listManipulation %%%
%%% This Way we can find our adaptoid ont the required position, this predicate allow us to search verticaly and horizontaly %%%

findElement(PosXY, [Head|Rest], Result, Counter):-
  PosXY =/= Counter,
  Counter1 is Counter + 1,
  findElement(PosXY, Rest, list, Counter1).

findElement(PosXY, [Head|Rest], Result ,Counter):-
    CoordX =:= Counter,
    List = Head.

getAdaptoid(Board, Player, CoordX, CoordY, Adaptoid):-
    findElement(CoordX, Board, List, 1),
    findElement(CoordY, List, Adaptoid, 1).

%%% Adaptoid -> C (color) - L (Leg) - P (Pincer)
updateAdaptoid(C - L - P, C - L1 - P1, Pincer, Leg):-
      L1 is L + Leg,
      P1 is P + Pincer.
