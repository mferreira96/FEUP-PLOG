
tabuleiro( [
            [!,!,x,vazio,vazio,vazio,vazio],
            [!,x,vazio,vazio,vazio,vazio,vazio],
            [x,vazio,vazio,vazio,vazio,vazio,vazio],
            [vazio, p - 0 - 0,vazio,vazio,vazio,b - 0 - 0,vazio],
            [x,vazio,vazio,vazio,vazio,vazio,vazio],
            [!,x,vazio,vazio,vazio,vazio,vazio],
            [!,!,x,vazio,vazio,vazio,vazio]
             ]
          ).

tabuleiro1( [
            [!,!,x,vazio,vazio,vazio,vazio],
            [!,x,vazio,vazio,vazio,vazio,vazio],
            [x,vazio,vazio,p - 2 - 1,vazio,vazio,vazio],
            [vazio,vazio,vazio,vazio,vazio,vazio,vazio],
            [x,vazio,vazio,vazio,vazio,p-2-3,vazio],
            [!,x,vazio,vazio,b - 5 - 1,b - 3 - 2 ,vazio],
            [!,!,x,vazio,vazio,vazio,vazio]
             ]
          ).


list([_X|_Xs]).
list([]).

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


displayMember([List|Rest]) :-
    write(List),
    displayMember(Rest).

displayMember([]).

displayA(x, N):- N > 3, write('  \\ ').
displayA(X, _):-(X = x; X = !), write('    ').
displayA(_, _):- write('  /\\ ').

displayB(x, N):-  N > 3, write('   \\').
displayB(X, _):-(X = x; X = !), write('    ').
displayB(_, _):-  write(' /  \\').

displayC(X, _):-(X = x; X = !), write('    ').
displayC(vazio,_):- write('|    ').
displayC(C - L - P, _):- write('| '), write(L),write(C),write(P), write('').

displayLineA([X | Xs], Value) :- displayA(X, Value) , displayLineA(Xs, Value).
displayLineA([], N):- N > 3, write(' /'), nl.
displayLineA([], _T):- nl.

displayLineB([X | Xs], Value) :- displayB(X,Value), displayLineB(Xs,Value).
displayLineB([] ,N ):- N > 3, write('/'), nl.
displayLineB([], _T ):- nl.

displayLineC([X | Xs], Value) :- displayC(X, Value), displayLineC(Xs, Value).
displayLineC([], _T ):- write('|'), nl.

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
