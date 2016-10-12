
tabuleiro( [
            ['1','x','x','x',' ',' ',' ',' ','x','x'],
            ['2','x','x',' ',' ',' ',' ',' ','x','x'],
            ['3','x',' ',' ',' ',' ',' ',' ','x'],
            ['4',' ',' ',' ',' ',' ',' ',' '],
            ['3','x',' ',' ',' ',' ',' ',' ','x'],
            ['2','x','x',' ',' ',' ',' ',' ','x','x'],
            ['1','x','x','x',' ',' ',' ',' ','x','x']
             ]
          ).

          /*
          4
          5
          6
          7
          6
          5
          4
          */


giveSpace(1) :- write(' ').
giveSpace(2) :- write('  ').
giveSpace(3) :- write('   ').
giveSpace(4) :- write('    ').


displayA('x'):- write('    ').
displayA(' '):- write('  /\\ ').

displayB('x'):- write('    ').
displayB(' '):- write(' /  \\').

displayC('x'):- write('    ').
displayC(' '):- write('|    ').



displayLineA([X | Xs]) :- displayA(X) , displayLineA(Xs).
displayLineA([]):- nl.

displayLineB([X | Xs]) :- displayB(X), displayLineB(Xs).
displayLineB([]):- nl.

displayLineC([X | Xs]) :- displayC(X), displayLineC(Xs).
displayLineC([]):- nl.


displayLine(E) :- 
	giveSpace(E),	
	displayLineA(E), 
	giveSpace(E),
	displayLineB(E), 
	giveSpace(E),	
	displayLineC(E).

displayLine([]):- nl.


displayBoard([H | T], X) :-
    displayLine(H),
    displayBoard(T).

displayBoard([]):- nl.
