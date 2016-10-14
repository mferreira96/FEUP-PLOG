
tabuleiro( [
            ['!','!','x',' ',' ',' ',' ','#'],
            ['!','x',' ',' ',' ',' ',' ','#'],
            ['x',' ',' ',' ',' ',' ',' ','#'],
            [' ',' ',' ',' ',' ',' ',' ','#'],
            ['x',' ',' ',' ',' ',' ',' ','#'],
            ['!','x',' ',' ',' ',' ',' ','#'],
            ['!','!','x',' ',' ',' ',' ','#']
             ]
          ).


giveSpace(N) :-
 (N =:= 0; N =:= 6),
 write(' ').

giveSpace(N) :-
 (N =:= 1; N =:= 5),
write('  ').

giveSpace(N) :-
 (N =:= 2; N =:= 4),
 write('   ').

giveSpace(3) :- write('    ').
giveSpace(7) :- write('             ').
giveSpace(8) :- write('               ').



displayA('#', _):- write('').
displayA('x', N):- N > 3, write('  \\ ').
displayA(X, _):-(X = 'x'; X = '!'), write('    ').
displayA(' ', _):- write('  /\\ ').

displayB('#', _):- write('').
displayB('x', N):-  N > 3, write('   \\').
displayB(X, _):-(X = 'x'; X = '!'), write('    ').
displayB(' ', _):- write(' /  \\').

displayC('#', _):- write('|').
displayC(X, _):-(X = 'x'; X = '!'), write('    ').
displayC(' ',_):- write('|    ').

displayEnd1(0):-nl , giveSpace(8), displayEnd2(4).
displayEnd1(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write('\\   /'),
      displayEnd1(Counter1).


displayEnd2(0) :- nl.
displayEnd2(Counter) :-
      Counter > 0,
      Counter1 is Counter - 1,
      write('\\/   '),
      displayEnd2(Counter1).

displayLineA([X | Xs], Value) :- displayA(X, Value) , displayLineA(Xs, Value).
displayLineA([], N):- N > 3, write(' /'), nl.
displayLineA([], _T):- nl.

displayLineB([X | Xs], Value) :- displayB(X,Value), displayLineB(Xs,Value).
displayLineB([] ,N ):- N > 3, write('/'), nl.
displayLineB([], _T ):- nl.

displayLineC([X | Xs], Value) :- displayC(X, Value), displayLineC(Xs, Value).
displayLineC([], _T ):- nl.


displayLine(L, Value) :-
	giveSpace(Value),
	displayLineA(L, Value),
	giveSpace(Value),
	displayLineB(L, Value),
	giveSpace(Value),
	displayLineC(L, Value).

displayLine([], _T):- nl.


displayBoard([H | T], Count) :-
    displayLine(H,Count ),
    Count1 is Count + 1,
    displayBoard(T ,Count1).

displayBoard([], Count):- giveSpace(Count), displayEnd1(4).


menu(_X) :-
  tabuleiro(_X),
  displayBoard(_X, 0).
