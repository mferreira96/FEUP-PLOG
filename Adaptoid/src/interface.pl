
% needed to be tested
askCoord:-
  write('Write the row of the adaptoid:'),
  getInt(Row),
  validateRow(Row),
  write('Write the column of the adaptoid:'),
  getInt(column),
  validateColumn(Column),
  \+empetyCell(Board, _ , Row-Column).


askNextCoords:-
  write('write the next position of adaptoid:').

discardInput:-
  get_code(_).
