
/*Menu inicial*/
exit.


startMenu:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Play'), nl,
  write('2 - Tuturial'),nl,
  write('3 - About'), nl,
  write('4 - Exit'),nl,
  nl,
  write('Press Enter to continue'),nl,
  get_char(Answer), discardInput,
  (Answer = '1' -> play;
   Answer = '2' -> tuturialMenu;
   Answer = '3' -> aboutMenu;
   Answer = '4' -> exit;
   startMenu).

%  fazer o switch case aqui

/*Opcoes de jogo*/
play:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Computer vs Computer'), nl,
  write('2 - Computer vs Human'),nl,
  write('3 - Human vs Human'), nl,
  write('4 - Exit'),nl,
  nl,
  write('Press Enter to continue'),nl,
  get_char(Answer), discardInput,
  (Answer = '1' -> choose2ComputerLevel;
   Answer = '2' -> chooseComputerLevel;
   Answer = '3' -> game(hh,_);
   Answer = '4' -> startMenu;
   play).

/*nivel de dificuldade do computador, quando o jogo e entre humano e computador*/

chooseComputerLevel:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Hard'), nl,
  write('2 - Medium'),nl,
  write('3 - Exit'),nl,
  nl,
  write('Press Enter to continue'),nl,
  get_char(Answer), discardInput,
  (Answer = '1' -> game(ch,hard);
   Answer = '2' -> game(ch,medium);
   Answer = '3' -> startMenu;
   chooseComputerLevel).

/*nivel de dificuldade do computador, quando o jogo e entre dois computadores*/
choose2ComputerLevel:- clearScreen(20),
  write('Choose one of the follow options'), nl,
  write('1 - Hard vs Hard'), nl,
  write('2 - Hard vs Medium'),nl,
  write('3 - Medium vs Medium'),nl,
  write('4 - Exit'),nl,
  nl,
  write('Press Enter to continue'),nl,
  get_char(Answer), discardInput,
  (Answer = '1' -> game(cc,hard-hard);
   Answer = '2' -> game(cc,hard-medium);
   Answer = '3' -> game(cc,medium-medium);
   Answer = '4' -> startMenu;
   choose2ComputerLevel).

/* para eliminar possiveis inputs*/
discardInput:-
  get_code(_).

/*limpa o ecra*/
clearScreen(0).
clearScreen(N):-
  nl,
  N1 is N - 1,
  clearScreen(N1).
