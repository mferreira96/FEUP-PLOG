
tabuleiro( [
            ['1','x','x','x',' ',' ',' ',' ','#'],
            ['2','x','x',' ',' ',' ',' ',' ','#'],
            ['3','x',' ',' ',' ',' ',' ',' ','#'],
            ['4',' ',' ',' ',' ',' ',' ',' ','#'],
            ['3','x',' ',' ',' ',' ',' ',' ','#'],
            ['2','x','x',' ',' ',' ',' ',' ','#'],
            ['1','x','x','x',' ',' ',' ',' ','#']
             ]
          ).


giveSpace('1') :- write(' ').
giveSpace('2') :- write('  ').
giveSpace('3') :- write('   ').
giveSpace('4') :- write('    ').


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


displayLine([E1|Es]) :-
	giveSpace(E1),
	displayLineA(Es),
	giveSpace(E1),
	displayLineB(Es),
	giveSpace(E1),
	displayLineC(Es).

displayLine([]):- nl.


displayBoard([H | T]) :-
    displayLine(H),
    displayBoard(T).

displayBoard([]):- nl.
