% List of horizontal and vertical clues, to the presentation

getBoard(N, Vertical_clues, Horizontal_Clues):-
	(
		N =:= 1 -> testBoard1(Vertical_clues, Horizontal_Clues);
		N =:= 2 -> testBoard2(Vertical_clues, Horizontal_Clues);
		N =:= 3 -> testBoard3(Vertical_clues, Horizontal_Clues);
    N =:= 4 -> testBoard4(Vertical_clues, Horizontal_Clues);
    N =:= 5 -> testBoard5(Vertical_clues, Horizontal_Clues);
    N =:= 6 -> testBoard6(Vertical_clues, Horizontal_Clues);
		nl,
		write('Error: the specified board does not exist.'),
		fail
	).


testBoard1([2,2,0],[2,2,0]).

testBoard2([5,7,4,0,3,6,3,2,5,5],[2,6,6,4,3,3,5,5,4,2]).

testBoard3([7,9,9,2,6,4,3,6,6,6,5,2],[0,0,2,3,0,4,5,0,6,7,0,0]).

testBoard4([2,2,3,6,6,0,5,5],[2,6,6,0,5,5,5,0]).

testBoard5([2,5,3,5,2,0,6,0,4,0,4],[3,5,2,5,3,0,4,0,6,0,6]).

testBoard6([6,6,3,2,0,4,0,2],[6,6,3,0,5,2,6,0]).
