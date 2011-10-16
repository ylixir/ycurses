import ncurses;

int main()
{
	char hello = 'd';
  initscr();
  printw(hello);
  refresh();
  getch();
  endwin();

  return 0;
}
