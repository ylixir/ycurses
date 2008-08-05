/*
Copyright (c) 2008 Jon "ylixir" Allen <ylixir@gmail.com>

    Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

module ncurses;

version(Tango)
{
  import tango.stdc.stddef, tango.stdc.stdio, tango.stdc.stdarg;
}
else
{
  import std.c.stddef, std.c.stdio, std.c.stdarg;
}

extern (C):

/* types */
typedef uint mmask_t;
typedef uint  chtype;
typedef chtype   attr_t;
typedef void  SCREEN;
struct MEVENT
{
  short id;         /* ID to distinguish multiple devices */
  int x, y, z;      /* event coordinates */
  mmask_t bstate;   /* button state bits */
}
struct  WINDOW
{
  short   cury,
          curx,
          maxy,
          maxx,
          begy,
          begx,
          flags;
  attr_t  attrs;
  chtype  bkgd;
  bool    notimeout,
          clear,
          leaveok,
          scroll,
          idlok,
          idcok,
          immed,
          sync,
          use_keypad;
  int     delay;
  void*   line;
  short   regtop,
          regbottom;
  int     parx,
          pary;
  WINDOW* parent;

  struct pdat
  {
    short pad_y,      pad_x,
          pad_top,    pad_left,
          pad_bottom, pad_right;
  }
  pdat pad;

  short yoffset;
}
const size_t CCHARW_MAX = 5;
struct cchar_t
{
  attr_t attr;
  wchar_t chars[CCHARW_MAX];
}

/* global variables */
extern WINDOW* stdscr;
extern WINDOW* curscr;
extern WINDOW* newscr;

extern int     LINES;
extern int     COLS;
extern int     TABSIZE;

extern int     ESCDELAY;

extern chtype acs_map[256];

/* initialization functions */
WINDOW* initscr();
int endwin();
bool isendwin();
SCREEN* newterm(char* type, FILE* outfd, FILE* infd);
SCREEN* set_term(SCREEN* newscreen);
void delscreen(SCREEN* sp);

/* "kernel" functions */
int def_prog_mode();
int def_shell_mode();
int reset_prog_mode();
int reset_shell_mode();
int resetty();
int savetty();
int ripoffline(int line, int (*init)(WINDOW* win, int cols));
int curs_set(int visibility);
int napms(int ms);
void getsyx(T:int)(ref T y, ref T x)
{
  if(newscr.leaveok)
    y=x=-1;
  else
    getyx(newscr,y,x);
}
void setsyx(T:int)(T y, T x)
{
  if((y==-1) && (x==-1))
    newscr.leaveok=true;
  else
  {
    newscr.leaveok=false;
    wmove(newscr, y, x);
  }
}

/* window functions */
WINDOW* newwin(int nlines, int ncols, int begin_y, int begin_x);
int delwin(WINDOW* win);
int mvwin(WINDOW* win, int y, int x);
WINDOW* subwin(WINDOW* orig, int nlines, int ncols, int begin_y, int begin_x);
WINDOW* derwin(WINDOW* orig, int nlines, int ncols, int begin_y, int begin_x);
int mvderwin(WINDOW* win, int par_y, int par_x);
WINDOW* dupwin(WINDOW* win);
void wsyncup(WINDOW* win);
int syncok(WINDOW* win, bool bf);
void wcursyncup(WINDOW* win);
void wsyncdown(WINDOW* win);

/* border functions */
int border(chtype ls, chtype rs, chtype ts, chtype bs,
  chtype tl, chtype tr, chtype bl, chtype br);
int wborder(WINDOW* win, chtype ls, chtype rs,
  chtype ts, chtype bs, chtype tl, chtype tr,
  chtype bl, chtype br);
int box(WINDOW* win, chtype verch, chtype horch);
int hline(chtype ch, int n);
int whline(WINDOW* win, chtype ch, int n);
int vline(chtype ch, int n);
int wvline(WINDOW* win, chtype ch, int n);
int mvhline(int y, int x, chtype ch, int n);
int mvwhline(WINDOW* win, int y, int x, chtype ch, int n);
int mvvline(int y, int x, chtype ch, int n);
int mvwvline(WINDOW* win, int y, int x, chtype ch, int n);

/* refresh functions */
int refresh();
int wrefresh(WINDOW* win);
int wnoutrefresh(WINDOW* win);
int doupdate();
int redrawwin(WINDOW* win);
int wredrawln(WINDOW* win, int beg_line, int num_lines);

/* clearing functions */
int erase();
int werase(WINDOW* win);
int clear();
int wclear(WINDOW* win);
int clrtobot();
int wclrtobot(WINDOW* win);
int clrtoeol();
int wclrtoeol(WINDOW* win);

/* screen <-> file functions */
int scr_dump(char *filename);
int scr_restore(char *filename);
int scr_init(char *filename);
int scr_set(char *filename);

/* window <-> file functions */
char* unctrl(chtype c);
char* wunctrl(cchar_t* c);
char* keyname(int c);
char* key_name(wchar_t w);
void filter();
void nofilter();
void use_env(bool f);
int putwin(WINDOW* win, FILE* filep);
WINDOW* getwin(FILE* filep);
int delay_output(int ms);
int flushinp();

/* window overlay functions */
int overlay(WINDOW* srcwin, WINDOW* dstwin);
int overwrite(WINDOW* srcwin, WINDOW* dstwin);
int copywin(WINDOW* srcwin, WINDOW* dstwin, int sminrow,
     int smincol, int dminrow, int dmincol, int dmaxrow,
     int dmaxcol, int overlay);

/* cursor movement */
int move(int y, int x);
int wmove(WINDOW* win, int y, int x);

/* printing functions */
int printw(char* fmt, ...);
int wprintw(WINDOW* win, char* fmt, ...);
int mvprintw(int y, int x, char* fmt, ...);
int mvwprintw(WINDOW* win, int y, int x, char* fmt, ...);
deprecated int vwprintw(WINDOW* win, char* fmt, va_list varglist);
int vw_printw(WINDOW* win, char* fmt, va_list varglist);

/* single char output functions */
int addch(chtype ch);
int waddch(WINDOW* win, chtype ch);
int mvaddch(int y, int x, chtype ch);
int mvwaddch(WINDOW* win, int y, int x, chtype ch);
int echochar(chtype ch);
int wechochar(WINDOW* win, chtype ch);

/* string output functions */
int addstr(char* str);
int addnstr(char* str, int n);
int waddstr(WINDOW* win, char* str);
int waddnstr(WINDOW* win, char* str, int n);
int mvaddstr(int y, int x, char* str);
int mvaddnstr(int y, int x, char* str, int n);
int mvwaddstr(WINDOW* win, int y, int x, char* str);
int mvwaddnstr(WINDOW* win, int y, int x, char* str, int n);

/* character get functions */
int getch();
int wgetch(WINDOW* win);
int mvgetch(int y, int x);
int mvwgetch(WINDOW* win, int y, int x);
int ungetch(int ch);
int has_key(int ch);

/* string input */
int getstr(char* str);
int getnstr(char* str, int n);
int wgetstr(WINDOW* win, char* str);
int wgetnstr(WINDOW* win, char* str, int n);
int mvgetstr(int y, int x, char* str);
int mvwgetstr(WINDOW* win, int y, int x, char* str);
int mvgetnstr(int y, int x, char* str, int n);
int mvwgetnstr(WINDOW* win, int y, int x, char* str, int n);

/* formatted input functions */
int scanw(char* fmt, ...);
int wscanw(WINDOW* win, char* fmt, ...);
int mvscanw(int y, int x, char* fmt, ...);
int mvwscanw(WINDOW* win, int y, int x, char* fmt, ...);
int vw_scanw(WINDOW* win, char* fmt, va_list varglist);
deprecated int vwscanw(WINDOW* win, char* fmt, va_list varglist);

/* mouse functions */
int getmouse(MEVENT* event);
int ungetmouse(MEVENT* event);
mmask_t mousemask(mmask_t newmask, mmask_t* oldmask);
bool wenclose(WINDOW* win, int y, int x);
bool mouse_trafo(int* pY, int* pX, bool to_screen);
bool wmouse_trafo(WINDOW* win, int* pY, int* pX,
    bool to_screen);
int mouseinterval(int erval);

/* get coordinate info */
void getyx(U:WINDOW*, T: int)(U win, ref T y, ref T x)
{
  y = getcury(win);
  x = getcurx(win);
}
void getparyx(U:WINDOW*, T: int)(U win, ref T y, ref T x)
{
  y = getpary(win);
  x = getparx(win);
}
void getbegyx(U:WINDOW*, T: int)(U win, ref T y, ref T x)
{
  y = getbegy(win);
  x = getbegx(win);
}
void getmaxyx(U:WINDOW*, T: int)(U win, ref T y, ref T x)
{
  y = getmaxy(win);
  x = getmaxx(win);
}
int getcurx(U:WINDOW*)(U win)
{
  return win ? win.curx : ERR;
}
int getcury(U:WINDOW*)(U win)
{
  return win ? win.cury : ERR;
}
int getbegy(U:WINDOW*)(U win)
{
  return win ? win.begy : ERR;
}
int getbegx(U:WINDOW*)(U win)
{
  return win ? win.begx : ERR;
}
int getpary(U:WINDOW*)(U win)
{
  return win ? win.pary : ERR;
}
int getparx(U:WINDOW*)(U win)
{
  return win ? win.parx : ERR;
}
int getmaxy(U:WINDOW*)(U win)
{
  return win ? win.maxy : ERR;
}
int getmaxx(U:WINDOW*)(U win)
{
  return win ? win.maxx : ERR;
}

/* input option functions */
int cbreak();
int nocbreak();
int echo();
int noecho();
int halfdelay(int tenths);
int intrflush(WINDOW* win, bool bf);
int keypad(WINDOW* win, bool bf);
int meta(WINDOW* win, bool bf);
int nodelay(WINDOW *win, bool bf);
int raw();
int noraw();
void noqiflush();
void qiflush();
int notimeout(WINDOW *win, bool bf);
void timeout(int delay);
void wtimeout(WINDOW *win, int delay);
int typeahead(int fd);

/* attribute functions */
int attroff(int attrs);
int wattroff(WINDOW* win, int attrs);
int attron(int attrs);
int wattron(WINDOW* win, int attrs);
int attrset(int attrs);
int wattrset(WINDOW* win, int attrs);
int color_set(short color_pair_number, void* opts);
int wcolor_set(WINDOW* win, short color_pair_number, void* opts);
int standend();
int wstandend(WINDOW* win);
int standout();
int wstandout(WINDOW* win);
int attr_get(attr_t* attrs, short* pair, void* opts);
int wattr_get(WINDOW* win, attr_t* attrs, short* pair, void* opts);
int attr_off(attr_t attrs, void* opts);
int wattr_off(WINDOW* win, attr_t attrs, void* opts);
int attr_on(attr_t attrs, void* opts);
int wattr_on(WINDOW* win, attr_t attrs, void* opts);
int attr_set(attr_t attrs, short pair, void* opts);
int wattr_set(WINDOW* win, attr_t attrs, short pair, void* opts);
int chgat(int n, attr_t attr, short color, void* opts);
int wchgat(WINDOW* win, int n, attr_t attr, short color, void* opts);
int mvchgat(int y, int x, int n, attr_t attr, short color, void* opts);
int mvwchgat(WINDOW* win, int y, int x, int n, attr_t attr, short color, void* opts);

/* color functions */
int start_color();
int init_pair(short pair, short f, short b);
int init_color(short color, short r, short g, short b);
bool has_colors();
bool can_change_color();
int color_content(short color, short* r, short* g, short* b);
int pair_content(short pair, short* f, short* b);

/* error codes */
enum
{
  OK = 0,
  ERR = -1
}

/* key codes */
enum
{
 KEY_CODE_YES  = 0x100,
 KEY_MIN       = 0x101,
 KEY_BREAK     = 0x101,
 KEY_SRESET    = 0x158,
 KEY_RESET     = 0x159,
 KEY_DOWN      = 0x102,
 KEY_UP        = 0x103,
 KEY_LEFT      = 0x104,
 KEY_RIGHT     = 0x105,
 KEY_HOME      = 0x106,
 KEY_BACKSPACE = 0x107,
 KEY_F0        = 0x108,
 KEY_DL        = 0x148,
 KEY_IL        = 0x149,
 KEY_DC        = 0x14A,
 KEY_IC        = 0x14B,
 KEY_EIC       = 0x14C,
 KEY_CLEAR     = 0x14D,
 KEY_EOS       = 0x14E,
 KEY_EOL       = 0x14F,
 KEY_SF        = 0x150,
 KEY_SR        = 0x151,
 KEY_NPAGE     = 0x152,
 KEY_PPAGE     = 0x153,
 KEY_STAB      = 0x154,
 KEY_CTAB      = 0x155,
 KEY_CATAB     = 0x156,
 KEY_ENTER     = 0x157,
 KEY_PRINT     = 0x15A,
 KEY_LL        = 0x15B,
 KEY_A1        = 0x15C,
 KEY_A3        = 0x15D,
 KEY_B2        = 0x15E,
 KEY_C1        = 0x15F,
 KEY_C3        = 0x160,
 KEY_BTAB      = 0x161,
 KEY_BEG       = 0x162,
 KEY_CANCEL    = 0x163,
 KEY_CLOSE     = 0x164,
 KEY_COMMAND   = 0x165,
 KEY_COPY      = 0x166,
 KEY_CREATE    = 0x167,
 KEY_END       = 0x168,
 KEY_EXIT      = 0x169,
 KEY_FIND      = 0x16A,
 KEY_HELP      = 0x16B,
 KEY_MARK      = 0x16C,
 KEY_MESSAGE   = 0x16D,
 KEY_MOVE      = 0x16E,
 KEY_NEXT      = 0x16F,
 KEY_OPEN      = 0x170,
 KEY_OPTIONS   = 0x171,
 KEY_PREVIOUS  = 0x172,
 KEY_REDO      = 0x173,
 KEY_REFERENCE = 0x174,
 KEY_REFRESH   = 0x175,
 KEY_REPLACE   = 0x176,
 KEY_RESTART   = 0x177,
 KEY_RESUME    = 0x178,
 KEY_SAVE      = 0x179,
 KEY_SBEG      = 0x17A,
 KEY_SCANCEL   = 0x17B,
 KEY_SCOMMAND  = 0x17C,
 KEY_SCOPY     = 0x17D,
 KEY_SCREATE   = 0x17E,
 KEY_SDC       = 0x17F,
 KEY_SDL       = 0x180,
 KEY_SELECT    = 0x181,
 KEY_SEND      = 0x182,
 KEY_SEOL      = 0x183,
 KEY_SEXIT     = 0x184,
 KEY_SFIND     = 0x185,
 KEY_SHELP     = 0x186,
 KEY_SHOME     = 0x187,
 KEY_SIC       = 0x188,
 KEY_SLEFT     = 0x189,
 KEY_SMESSAGE  = 0x18A,
 KEY_SMOVE     = 0x18B,
 KEY_SNEXT     = 0x18C,
 KEY_SOPTIONS  = 0x18D,
 KEY_SPREVIOUS = 0x18E,
 KEY_SPRINT    = 0x18F,
 KEY_SREDO     = 0x190,
 KEY_SREPLACE  = 0x191,
 KEY_SRIGHT    = 0x192,
 KEY_SRSUME    = 0x193,
 KEY_SSAVE     = 0x194,
 KEY_SSUSPEND  = 0x195,
 KEY_SUNDO     = 0x196,
 KEY_SUSPEND   = 0x197,
 KEY_UNDO      = 0x198,
 KEY_MOUSE     = 0x199,
 KEY_RESIZE    = 0x19A,
 KEY_EVENT     = 0x19B,
 KEY_MAX       = 0x1FF
}
int KEY_F(N:int)(N n)
in
{
  assert (n>=0, "Invalid value for KEY_F(n)");
}
out (result)
{
  assert (result < KEY_DL, "Invalid value for KEY_F(n)");
}
body
{
  return KEY_F0 + n;
}

/* mouse events */
enum
{
  BUTTON1_RELEASED          = 0x1,
  BUTTON1_PRESSED           = 0x2,
  BUTTON1_CLICKED           = 0x4,
  BUTTON1_DOUBLE_CLICKED    = 0x8,
  BUTTON1_TRIPLE_CLICKED    = 0x10,
  BUTTON2_RELEASED          = 0x40,
  BUTTON2_PRESSED           = 0x80,
  BUTTON2_CLICKED           = 0x100,
  BUTTON2_DOUBLE_CLICKED    = 0x200,
  BUTTON2_TRIPLE_CLICKED    = 0x400,
  BUTTON3_RELEASED          = 0x1000,
  BUTTON3_PRESSED           = 0x2000,
  BUTTON3_CLICKED           = 0x4000,
  BUTTON3_DOUBLE_CLICKED    = 0x8000,
  BUTTON3_TRIPLE_CLICKED    = 0x10000,
  BUTTON4_RELEASED          = 0x40000,
  BUTTON4_PRESSED           = 0x80000,
  BUTTON4_CLICKED           = 0x100000,
  BUTTON4_DOUBLE_CLICKED    = 0x200000,
  BUTTON4_TRIPLE_CLICKED    = 0x400000,
  BUTTON_CTRL               = 0x1000000,
  BUTTON_SHIFT              = 0x2000000,
  BUTTON_ALT                = 0x4000000,
  REPORT_MOUSE_POSITION     = 0x8000000,
  ALL_MOUSE_EVENTS          = 0x7FFFFFF
}

/* attribute mask constants */
const chtype  A_NORMAL      = 0x0;
const chtype  A_ATTRIBUTES  = 0xFFFFFF00;
const chtype  A_CHARTEXT    = 0xFF;
const chtype  A_COLOR       = 0xFF00;
const chtype  A_STANDOUT    = 0x10000;
const chtype  A_UNDERLINE   = 0x20000;
const chtype  A_REVERSE     = 0x40000;
const chtype  A_BLINK       = 0x80000;
const chtype  A_DIM         = 0x100000;
const chtype  A_BOLD        = 0x200000;
const chtype  A_ALTCHARSET  = 0x400000;
const chtype  A_INVIS       = 0x800000;
const chtype  A_PROTECT     = 0x1000000;
const chtype  A_HORIZONTAL  = 0x2000000;
const chtype  A_LOW         = 0x8000000;
const chtype  A_RIGHT       = 0x10000000;
const chtype  A_TOP         = 0x20000000;
const chtype  A_VERTICAL    = 0x40000000;

const chtype  COLOR_BLACK   = 0;
const chtype  COLOR_RED     = 1;
const chtype  COLOR_GREEN   = 2;
const chtype  COLOR_YELLOW  = 3;
const chtype  COLOR_BLUE    = 4;
const chtype  COLOR_MAGENTA = 5;
const chtype  COLOR_CYAN    = 6;
const chtype  COLOR_WHITE   = 7;

chtype COLOR_PAIR(N:int)(N n)
{
  return cast(chtype)(n<<8);
}
/* acs symbols */
enum ACS
{
  ULCORNER      = 'l',
  LLCORNER      = 'm',
  URCORNER      = 'k',
  LRCORNER      = 'j',
  LTEE          = 't',
  RTEE          = 'u',
  BTEE          = 'v',
  TTEE          = 'w',
  HLINE         = 'q',
  VLINE         = 'x',
  PLUS          = 'n',
  S1            = 'o',
  S9            = 's',
  DIAMOND       = '`',
  CKBOARD       = 'a',
  DEGREE        = 'f',
  PLMINUS       = 'g',
  BULLET        = '~',
  LARROW        = ',',
  RARROW        = '+',
  DARROW        = '.',
  UARROW        = '-',
  BOARD         = 'h',
  LANTERN       = 'i',
  BLOCK         = '0',
  S3            = 'p',
  S7            = 'r',
  LEQUAL        = 'y',
  GEQUAL        = 'z',
  PI            = '{',
  NEQUAL        = '|',
  STERLING      = '}',
  BSSB          = ACS.ULCORNER,
  SSBB          = ACS.LLCORNER,
  BBSS          = ACS.URCORNER,
  SBBS          = ACS.LRCORNER,
  SBSS          = ACS.RTEE,
  SSSB          = ACS.LTEE,
  SSBS          = ACS.BTEE,
  BSSS          = ACS.TTEE,
  BSBS          = ACS.HLINE,
  SBSB          = ACS.VLINE,
  SSSS          = ACS.PLUS
}

