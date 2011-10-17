/*	hello_world.d
 * You will either need to use the makefile or fix the import path.
 * Note that you will need to place any variables that you send to ncurses
 * in the global address space, since D2 currently defaults to Thread Local Storage.
 * this is explained below.
 * Also see http://d-programming-language.org/arrays.html for more info
 * on strings and char[]s
 */

import curses.ncurses;

void main()
{
	//char[] hello = ['h','e','l','l','o',' ','w','o','r','l','d','!'];
	char[] hello = "Hello World";
	
	/* D strings are not 0 terminated, so you'll probably want to do that manually
	 * with hello ~= '\0';
	 */
	hello ~= '\0';
	
	initscr();				//initialize the screen
	printw(hello.ptr);		//prints the char[] hello to the screen
	refresh();				//actually does the writing to the physical screen
	getch();				//gets a single character from the screen. 
	endwin();				//Routine to call before exitting, or leaving curses mode temporarily
}
