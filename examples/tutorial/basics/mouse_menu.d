/* Modified by: 1100110
 * This one looks fun...
 * Today exercise: fix the bad coding habits...
 * kiddies, appreciate the effort that went into this one...
 *
 * This is... terrible.
 * Relies heavily on deprecated features...
 * Much must be rewritten.
 * Skipping for now.
 */
import std.string: toStringz;
import curses.ncurses;

//immutable maybe??
const int WIDTH 	= 30;
const int HEIGHT 	= 10;

int startx = 0;
int starty = 0;

//change this to a string, mayhaps?
//why are you global???
//hard coded sizes are asking for trouble...
//kids, ignore the bad coding habits...
int [char[]] choices = ['Choice 1', 'Choice 2', 'Choice 3','Choice 4', 'Exit'];

void main()
{
	int c;
	WINDOW* menu_win;
	MEVENT event;

	initscr();						//hopefully you've seen all of this before.
	clear();
	noecho();
	cbreak();
	keypad(stdscr, true);
	scope(exit) endwin();			//I'm not entirely sure...

	startx = (80 - WIDTH)  / 2;
	starty = (24 - HEIGHT) / 2;

	attron(A_REVERSE);				//not entirely sure...
	mvprintw(23, 1, toStringz("Click on Exit to quit"));
	attroff(A_REVERSE);
	refresh();

	menu_win = newwin(HEIGHT, WIDTH, starty, startx);
	keypad(menu_win, true);
	mousemask(ALL_MOUSE_EVENTS, null);

	print_menu(menu_win, 1);

//while_loop:  I'm not entirely sure why this was in there...
//oh god, please tell me he isn't using labels...  he is...
//trying to route around it...
	c = wgetch(menu_win);
	while(c != 'q')
	{
		switch(c)
		{
		case KEY_MOUSE:
			if(getmouse(&event) == OK)
			{
				mvprintw(21, 1, toStringz("x = %d y = %d bstate = %x"),
											event.x, event.y, event.bstate);
				refresh();

				if(event.bstate & BUTTON1_CLICKED)
				{
					int choice = report_choice(event.x+1, event.y+1);
					if(choice == -1)
					{
						c = 'q';
						break;
					}//if

					mvprintw(22, 1, toStringz("Choice made is: %d String Chosen is \"%10s\""),
								choice, (choices[choice]~'\0').ptr);
					refresh();
					print_menu(menu_win, choice + 1);
				}//inner if()
			}//outter if()
			break; 
            
		default:
			break;
    }//switch-case()
  }//while

}//main

void print_menu(WINDOW* menu_win, int highlight)
{
	int x, y = 2;

	box(menu_win, 0, 0);

	foreach(i, choice; choices)
	{
		if(highlight == i + 1)
			wattron(menu_win, A_REVERSE);

		mvwprintw(menu_win, y + i, x, "%s", (choice ~ '\0').ptr);
		wattroff(menu_win, A_REVERSE);
	}//foreach
	wrefresh(menu_win);
}//void print_menu()

int report_choice(int mouse_x, int mouse_y)
{
	//look into changing to auto
	int i = startx + 2;
	int j = starty + 3;
	int report = 0;
	foreach(choice, str; choices)
	{
		if((mouse_y == j + choice) && (mouse_x >= i) && (mouse_x <= i+str.length))
		{
			if(choice == choices.length - 1)
				report = -1;
		else
			report = choices;
		}//if
	}//foreach
	return report;
}//int report_choice()
