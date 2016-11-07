
startMenu:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Play'), nl,
  write('2 - Tuturial'),nl,
  write('3 - About'), nl,
  write('4 - Exit'),nl,
  nl,
  write('Press Enter to continue'),
  get_char(Answer), discardInput.

%  fazer o switch case aqui

gameOption:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Computer vs Computer'), nl,
  write('2 - Computer vs Human'),nl,
  write('3 - Human vs Human'), nl,
  write('4 - Exit'),nl,
  nl,
  write('Press Enter to continue'),
  get_char(Answer), discardInput.


chooseComputerLevel:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Hard'), nl,
  write('2 - Medium'),nl,
  write('3 - Exit'),nl,
  nl,
  write('Press Enter to continue'),
  get_char(Answer), discardInput.

choose2ComputerLevel:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Hard vs Hard'), nl,
  write('2 - Hard vs Medum'),nl,
  write('3 - Medium vs Medum'),nl,
  write('4 - Exit'),nl,
  nl,
  write('Press Enter to continue'),
  get_char(Answer), discardInput.


discardInput:-
  get_code(_).

clearScreen(0).
clearScreen(N):-
  nl,
  N1 is N - 1,
  clearScreen(N1).
