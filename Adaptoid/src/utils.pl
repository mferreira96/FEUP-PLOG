readCommand(Line):-
   get_code(Ch),
   readAll(Ch, Chars),
   name(Line,Chars).

readAll(13, []).
readAll(10, []).
readAll(Ch,[Ch,Chars]):-
  get_code(NewCh),
  readAll(NewCh, Chars).


name(Line, [Char,_]):-
    Line is Char.


%ainda nao esta a funcionar corretamente
