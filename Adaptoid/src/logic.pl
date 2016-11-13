
%%%%%%%%%%%%%%%%%%%%%%%%
%%% listManipulation %%%
%%%%%%%%%%%%%%%%%%%%%%%%

/*faz o update do tabuleiro, defenindo uma celula, com um novo elemento*/
setMatrixElement(0, Col, NewElement, [Head| Rest], [NewHead| Rest]):-
  setListElemt(Col, NewElement, Head , NewHead).

setMatrixElement(Row, Col, NewElement, [Head| Rest], [Head| RRest]):-
  Row >  0,
  Row1 is Row - 1,
  setMatrixElement(Row1, Col, NewElement, Rest, RRest).

/*faz o update de uma lista, defenindo uma celula, com um novo elemento*/
setListElemt(0, NewElem, [_|L], [NewElem|L]).
setListElemt(Col, NewElem, [H|L], [H|R]):-
  Col > 0,
  Col1 is Col -1,
  setListElemt(Col1, NewElem, L, R).

/*obtem o conteudo presente na celula presente na posição (Row-Column)
getElement(+ Board, + Player,+ (Row - Column), - Element)*/
getElement(Board, _, Row - Column, Element):-
    nth0(Row, Board, List),
    nth0(Column, List, Element).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Update Adaptoid %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*atualiza o corpo do adaptoid colocando uma perna ou uma pinça no adaptoid  e retornando o adaptoid atualizado
updateBodyOfAdaptoid(+Adaptoid,- NewAdaptoid, +Pincer, +Leg)*/
%%% Adaptoid -> C (color) - L (Leg) - P (Pincer)
updateBodyOfAdaptoid(C - L - P, C - L1 - P1, Pincer, Leg):-
      L1 is L + Leg,
      P1 is P + Pincer.

/* atualiza o adaptoid, atualizando a sua constituição e atualiza o adaptoid no tabukeiro
updateAdaptoid(+Board, +Player, +Posicao,+Pincer, +Leg, -NewBoard):-
*/

updateAdaptoid(Board, Player, Row-Column,Pincer, Leg, NewBoard):-
    getElement(Board, Player, Row - Column, C - L - P),
    updateBodyOfAdaptoid(C - L - P, C - L1 - P1 ,Pincer , Leg),
    setMatrixElement(Row, Column, C - L1 - P1, Board, NewBoard).


/*Obtem o numero de extremidades (pernas + pincas)
getNumberOfExtremities(+Board, +Posicao, -Number)*/

getNumberOfExtremities(Board, R-C, Number):-
  getElement(Board, _, R-C,_-L-P),
  Number is L + P.

/*Obtem o numero de pernas do Adaptoid
getNuberOfLegs(+Adaptoid, -Legs)*/

getNuberOfLegs(_-L-_, L).

getColorOfAdpatoid(C-_-_, C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Adaptoid moves %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*Movimenta o adaptoid para a Posicao pretendida, atualizando o tabuleiro
moveAdaptoid(+Board, +Player, +PosicaoInicial, +PosicaoFinal, -NewBoard)*/

moveAdaptoid(Board, Player, Row-Column, FinalRow-FinalColumn, NewBoard):-
    getElement(Board, Player, Row - Column, Adaptoid),
    setMatrixElement(Row, Column, vazio, Board, TempBoard),
    setMatrixElement(FinalRow, FinalColumn, Adaptoid, TempBoard, NewBoard).

/*retira o adaptoid do tabuleiro
removeAdaptoid(+Board, +Player, +Posicao, -NewBoard)*/

removeAdaptoid(Board, _, Row-Column, NewBoard):-
      setMatrixElement(Row, Column, vazio, Board, NewBoard).



/*valida as coordenadas da celula*/
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

/*verifica se a celula esta vazia
empetyCell(+Board, +Player, +Posicao)*/

empetyCell(Board, _, Row-Column):-
  getElement(Board, _, Row - Column, Element),
  Element = vazio.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Compare adaptoids %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*compara dois adaptoids e escolhe o adaptod que vence*/

compareAdaptoids(Element,vazio, Winners):-
      append([Element], [], Winners).

compareAdaptoids(vazio,Element, Winners):-
      append([Element], [], Winners).

compareAdaptoids(C-L-P, C1 -_- P1, Winners):-
  \+sameColor(C,C1),
  P > P1,
  append([C-L-P], [], Winners).

compareAdaptoids(C-_-P, C1-L1-P1, Winners):-
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


/*verifica se a celulda vizinha esta vazia*/
empetyNeighbour(Board,R-C , NeighbourRow-NeghbourColumn):-
  neighbourRowColumn(R-C, NeighbourRow-NeghbourColumn),
  getElement(Board,_,NeighbourRow-NeghbourColumn, vazio).

/*elimina os Adaptoids que estao esfomeados,ou seja, que o numero de extremidades do mesmo e superior ao numero de
celulas vizinhas vazias*/

removeStarvingAdaptoids(Board, Color, NewBoard, PlayerOut):-
  findall(R-C, getElement(Board,_,R-C, Color-_-_ ), Adaptoids),
  turnColor(AuxColor),
  getPlayerByIsColor(PlayerIn, AuxColor),
  captureStarvingAdaptoid(Adaptoids, Board, NewBoard,Count),
  updatePlayerScore(Count,PlayerIn, PlayerOut).


captureStarvingAdaptoid([], Board, Board,0).
captureStarvingAdaptoid([R-C|Rest], Board, NewBoard,Count):-
  findall(NR-NC, empetyNeighbour(Board, R-C, NR-NC), Neighbours),
  length(Neighbours, NumOfNeighbours),
  getNumberOfExtremities(Board, R-C, NumberOfExtremities),
  captureAdaptoid(Board,TempBoard, R-C, NumOfNeighbours, NumberOfExtremities, Answer),
  captureStarvingAdaptoid(Rest, TempBoard, NewBoard, Number),
  Count is Number + Answer.


captureAdaptoid(Board,NewBoard, R-C, NumOfNeighbours, NumberOfExtremities, 1):-
  NumberOfExtremities > NumOfNeighbours,
  removeAdaptoid(Board,_, R-C, NewBoard).

captureAdaptoid(Board,Board, _, NumOfNeighbours, NumberOfExtremities, 0):-
    NumberOfExtremities =< NumOfNeighbours.

/*da nos as coordenadas das celulas vizinhas
neighbourRowColumn(+PosicaoAdaptoid,-PosicaoVizinhos)*/

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

/*o vizinho tem a mesma cor */
neighbourIsSameColor(Board, Row-Column, Color):-
  neighbourRowColumn(Row-Column, FinalRow-FinalColumn),
  getElement(Board, _, FinalRow - FinalColumn, C-_-_),
  sameColor(Color, C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% New adaptoid %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*cria um novo adaptoid que e posicionado junto a um outro adaptoid desse jogador,
o novo adaptopid começa sem pernas nem pincas
createNewAdaptoid(+Board, +Color,+Posicao, -NewBoard):-*/

createNewAdaptoid(Board, Color,R-C, NewBoard):-
  empetyCell(Board, _, R-C),!,
  neighbourIsSameColor(Board, R-C, Color),
  setMatrixElement(R, C, Color-0-0,Board, NewBoard).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% PATH %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


updatePlayerOnCapture(PlayerIn, PlayerOut):-
  updatePlayerScore(1,PlayerIn, PlayerOut),
  updatePlayer(PlayerOut).

moveWithPossibleCaptureAux(1, Winners,NewBoard, NewestBoard,FinalRow-FinalColumn,Player, PlayerOut):-
  nth0(0,Winners, Winner),
  updatePlayerOnCapture(Player, PlayerOut),
  setMatrixElement(FinalRow, FinalColumn, Winner, NewBoard, NewestBoard).

moveWithPossibleCaptureAux(2, Winners,NewBoard, NewestBoard,FinalRow-FinalColumn,Player, PlayerOut):-
  nth0(0,Winners, Winner),
  getColorOfAdpatoid(Winner, Color),
  getPlayerByIsColor(PlayerIn , Color),
  updatePlayerOnCapture(PlayerIn, Player2),
  nth0(1,Winners, Winner1),
  getColorOfAdpatoid(Winner1, Color1),
  getPlayerByIsColor(PlayerIn1 , Color1),
  updatePlayerOnCapture(PlayerIn1, PlayerOut),
  setMatrixElement(FinalRow, FinalColumn, vazio, NewBoard, NewestBoard).


moveWithPossibleCapture(Board,StartRow-StartCol, FinalRow-FinalColumn, NewestBoard, PlayerOut):-
  turnColor(C),
  getElement(Board, _ , StartRow-StartCol, C-L-P),!,
  findPath(Board,StartRow-StartCol, FinalRow-FinalColumn,L, NewBoard),
  getElement(Board, _ , FinalRow-FinalColumn, Element),
  compareAdaptoids(C-L-P, Element, Winners),
  removeAdaptoid(Board,_, StartRow-StartCol, NewBoard),
  length(Winners, SizeOfWinners),
  getPlayerByIsColor(PlayerIn , Color),
  moveWithPossibleCaptureAux(SizeOfWinners, Winners,NewBoard, NewestBoard,FinalRow-FinalColumn, PlayerIn, PlayerOut).

findPath(Board,StartRow-StartCol, FinalRow-FinalColumn, DistMax, NewBoard):-
  getElement(Board, _ , StartRow-StartCol, C-_-_),
  (empetyCell(Board,_,FinalRow-FinalColumn); (getElement(Board,_,FinalRow - FinalColumn, C1-L-P), \+sameColor(C,C1))),
  auxiliarPath(Board,StartRow-StartCol, FinalRow-FinalColumn, DistMax, [StartRow-StartCol], FinalList).


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
