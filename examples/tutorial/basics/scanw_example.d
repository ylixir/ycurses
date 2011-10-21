//Modified by: 1100110

import std.string: toStringz;
import ncurses;						/* ncurses.h includes stdio.h */  
 
void main()
{
	string mesg = "Enter a string: ";		//message to appear on the screen
	char str[80];							//way bigger than it needs to be
	int row, col;							//to store the number of rows and
											//columns on the screen
					 
	initscr();								//start the curses mode
	getmaxyx(stdscr, row, col);				//get the number of rows and columns

    //print the message at the center of the screen 
	mvprintw(row/2, (col-(mesg.length-1))/2, "%s", toStringz(mesg));
	getstr(str.ptr);

	mvprintw(LINES - 2, 0, toStringz("You Entered: %s"), str.ptr);
	getch();
	endwin();
}
