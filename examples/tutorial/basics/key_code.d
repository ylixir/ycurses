import ncurses;
import std.stdio: writefln;
void main()
{	int ch;

	initscr();
	cbreak();
	noecho();
	keypad(stdscr, true);

	ch = getch();
	endwin();
	writefln("The key pressed is %d", ch);
}
