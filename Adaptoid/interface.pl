readCommand(Line):-
  get0(Ch),
  readAll(Ch, Chars),
  name(Line,Chars).

readAll(13, []).
readAll(10, [])
readAll(Ch,[Ch,Chars]):-
  get0(NewCh),
  readAll(NewCh, Chars).


name(Line, Chars):-
  Line = Chars.
