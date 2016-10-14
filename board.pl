
tabuleiro( [
            ['x','x','x',' ',' ',' ',' ','#'],
            ['x','x',' ',' ',' ',' ',' ','#'],
            ['x',' ',' ',' ',' ',' ',' ','#'],
            [' ',' ',' ',' ',' ',' ',' ','#'],
            ['x',' ',' ',' ',' ',' ',' ','#'],
            ['x','x',' ',' ',' ',' ',' ','#'],
            ['x','x','x',' ',' ',' ',' ','#']
             ]
          ).


giveSpace(0) :- write(' ').
giveSpace(1) :- write('  ').
giveSpace(2) :- write('   ').
giveSpace(3) :- write('    ').


displayA('#'):- write('').
displayA('x'):- write('    ').
displayA(' '):- write('  /\\ ').


displayB('#'):- write('').
displayB('x'):- write('    ').
displayB(' '):- write(' /  \\').


displayC('#'):- write('|').
displayC('x'):- write('    ').
displayC(' '):- write('|    ').



displayLineA([X | Xs]) :- displayA(X) , displayLineA(Xs).
displayLineA([]):- nl.

displayLineB([X | Xs]) :- displayB(X), displayLineB(Xs).
displayLineB([]):- nl.

displayLineC([X | Xs]) :- displayC(X), displayLineC(Xs).
displayLineC([]):- nl.


displayLine(L, Value) :-
	giveSpace(Value),
	displayLineA(L),
	giveSpace(Value),
	displayLineB(L),
	giveSpace(Value),
	displayLineC(L).

displayLine([], _T):- nl.


displayBoard([H | T], Count) :-
    displayLine(H,Count),
    Count1 is Count + 1,
    displayBoard(T ,Count1).

displayBoard([], _T):- nl.


menu(_X) :-
  tabuleiro(_X),
  displayBoard(_X, 0).
