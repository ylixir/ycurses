/**
 * Authors: Jon "ylixir" Allen, ylixir@gmail.com
 * Copyright: Copyright (c) 2008 ylixir. All rights reserved.
 * License:
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
alias   chtype   attr_t;
typedef int OPTIONS;
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
  cchar_t bkgrnd;
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

/**
 * Add a complex character to a window, and advance the cursor.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_add_wch
 */
int add_wch(C:cchar_t)(C* wch)
{
  return wadd_wch(stdscr, wch);
}
int wadd_wch(WINDOW* win, cchar_t* wch);                        ///ditto
int mvadd_wch(N:int, C:cchar_t)(N y, N x, C* wch)               ///ditto
{
  return mvwadd_wch(stdscr, y, x, wch);
}
int mvwadd_wch(W:WINDOW, N:int, C:cchar_t)
      (W* win, N y, N x, C* wch)                                ///ditto
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wadd_wch(win, wch);
}

/**
 * Add a complex character to a window, advance the cursor,
 * and display it immediately.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_add_wch
 */
int echo_wchar(C:cchar_t)(C* wch )
{
  return wecho_wchar(stdscr, wch);
}
int wecho_wchar(WINDOW* win, cchar_t* wch);                     ///ditto

/**
 * Dump a string of complex characters out to a window.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_add_wchstr
 */
int add_wchstr(C:cchar_t)(C* wchstr)
{
  return wadd_wchstr(stdscr, wchstr);
}
int add_wchnstr(C:cchar_t, N:int)(C* wchstr, N n)       ///ditto
{
  return wadd_wchnstr(stdscr, wchstr, n);
}
int wadd_wchstr(W:WINDOW, C:cchar_t)(W* win, C* wchstr) ///ditto
{
  return wadd_wchnstr(win, wchstr, -1);
}
int wadd_wchnstr(WINDOW* win, cchar_t* wchstr, int n);  ///ditto
int mvadd_wchstr(N:int, C:cchar_t)(N y, N x, C* wchstr) ///ditto
{
  return mvwadd_wchstr(stdscr, y, x, wchstr);
}
int mvadd_wchnstr(N:int,C:cchar_t)(N y, N x, C* wchstr, N n)    ///ditto
{
  return mvwadd_wchnstr(stdscr, y, x, wchstr, n);
}
int mvwadd_wchstr(W:WINDOW, N:int, C:cchar_t)
  (W* win, N y, N x, C* wchstr)                         ///ditto
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wadd_wchstr(win, wchstr);
}
int mvwadd_wchnstr(W:WINDOW, N:int, C:cchar_t)
  (W* win, N y, N x, C* wchstr, N n)                         ///ditto
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wadd_wchnstr(win, wchstr, n);
}

/**
 * Add a character to a window, and advance the cursor.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_addch
 */
int addch(C:chtype)(C ch)
{
  return waddch(stdscr, ch);
}
int waddch(WINDOW* win, chtype ch);             ///ditto
int mvaddch(N:int, C:chtype)(N y, N x, C ch)    ///ditto
{
  return mvwaddch(stdscr, y, x, ch);
}
int mvwaddch(W:WINDOW, N:int, C:chtype)(W* win, N y, N x, C ch) ///ditto
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  waddch(win, ch);
}

/**
 * Add a character to a window, advance the cursor,
 * and display it immediately.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_addch
 */
int echochar(C:chtype)(C ch)
{
  return wechochar(stdscr, ch);
}
int wechochar(WINDOW* win, chtype ch);          ///ditto

/**
 * Dump a string of characters out to a window.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_addchstr
 */
int addchstr(C:chtype)(C* chstr)
{
  return waddchstr(stdscr, str);
}
int addchnstr(C:chtype, N:int)(C* chstr, N n)///ditto
{
  return waddchnstr(stdscr, chstr, n);
}
int waddchstr(W:WINDOW, C:chtype)(W* win, C* chstr)///ditto
{
  return waddchnstr(win, chstr, -1);
}
int waddchnstr(WINDOW* win, chtype* chstr, int n);///ditto
int mvaddchstr(N:int, C:chtype)(N y, N x, C* chstr)///ditto
{
  return mvwaddchstr(stdscr, y, x, str);
}
int mvaddchnstr(N:int, C:chtype)(N y, N x, C* chstr, N n)///ditto
{
  return mvwaddchnstr(stdscr, y, x, chstr, n);
}
int mvwaddchstr(W:WINDOW, N:int, C:chtype)
  (W* win, N y, N x, C* chstr)///ditto
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return waddchnstr(win, chstr, -1);
}
int  mvwaddchnstr(W:WINDOW, N:int, C:chtype)
  (W* win,  N y, N x, C* chstr, N n)///ditto
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return waddchnstr(win, chstr, n);
}

/**
 * Dump a string of characters out to a window.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_addstr
 */
int addstr(C:char)(C* str)
{
  return waddnstr(stdscr, str, -1);
}
///ditto
int addnstr(C:char, N:int)(C* str, N n)
{
  return waddnstr(stdscr, str, n);
}
///ditto
int waddstr(W:WINDOW, C:char)(W* win, C* str)
{
  return waddnstr(win, str, -1);
}
///ditto
int waddnstr(WINDOW* win, char* str, int n);
///ditto
int mvaddstr(N:int, C:char)(N y, N x, C* str)
{
  return mvwaddstr(stdscr, y, x, str);
}
///ditto
int mvaddnstr(N:int, C:char)(N y, N x, C* str, N n)
{
  return mvwaddnstr(stdscr, y, x, str, n);
}
///ditto
int mvwaddstr(W:WINDOW, N:int, C:char)(W* win, N y, N x, C* str)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return waddnstr(win, str, -1);
}
///ditto
int mvwaddnstr(W:WINDOW, N:int, C:char)(W* win, N y, N x, C* str, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return waddnstr(win, str, n);
}

/**
 * Dump a string of wide characters out to a window.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * See_also: man curs_addwstr
 */
int addwstr(WC:wchar_t)(WC* wstr)
{
  return waddwstr(stdscr, wstr);
}
///ditto
int addnwstr(WC:wchar_t, N:int)(WC* wstr, N n)
{
  return waddnwstr(stdscr, wstr);
}
///ditto
int waddwstr(W:WINDOW, WC:wchar_t)(W* win, WC* wstr)
{
  return waddnwstr(win, wstr, -1);
}
///ditto
int waddnwstr(WINDOW* win, wchar_t* wstr, int n);
///ditto
int mvaddwstr(N:int, WC:wchar_t)(N y, N x, WC* wstr)
{
  return mvwaddwstr(stdscr, y, x, wstr);
}
///ditto
int mvaddnwstr(N:int, WC:wchar_t)(N y, N x, WC* wstr, N n)
{
  return mvwaddnwstr(stdscr, y, x, wstr, n);
}
///ditto
int mvwaddwstr(W:WINDOW, N:int, WC:wchar_t)(W* win, N y, N x, WC* wstr)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return waddwstr(win, wstr);
}
///ditto
int mvwaddnwstr(W:WINDOW, N:int, WC:wchar_t)
  (W* win, N y, N x, WC* wstr, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return waddnwstr(win, wstr, n);
}

/**
 * Turn off specific window attributes.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * Params:
 *     opts = reserved for future use.  Always use null.
 * See_also: man curs_attr
 */
int attroff(N:int)(N attrs)
{
  return wattroff(stdscr, attrs);
}
///ditto
int wattroff(W:WINDOW, N:int)(W* win, N attrs)
{
  return wattr_off(win, attrs, null);
}
///ditto
int attr_off(A:attr_t, V:void)(A attrs, V* opts)
{
  return wattr_off(stdscr, attrs, opts);
}
///ditto
int wattr_off(WINDOW* win, attr_t attrs, void* opts);
/**
 * Turn on specific window attributes.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * Params:
 *     opts = reserved for future use.  Always use null.
 * See_also: man curs_attr
 */
int attron(N:int)(N attrs)
{
  return wattron(stdscr, attrs);
}
///ditto
int wattron(W:WINDOW, N:int)(W* win, N attrs)
{
  return wattr_on(win, cast(attr_t)attrs, null);
}
///ditto
int attr_on(A:attr_t, V:void)(A attrs, V* opts)
{
  return wattr_on(stdscr, attrs, opts);
}
///ditto
int wattr_on(WINDOW* win, attr_t attrs, void* opts);
/**
 * Sets all window attributes.
 *
 * Returns: The new set of attributes.
 * Params:
 *     opts = reserved for future use.  Always use null.
 * See_also: man curs_attr
 */
int attrset(N:int)(N attrs)
{
  return wattrset(stdscr, attrs);
}
///ditto
int wattrset(W:WINDOW, N:int)(W* win, N attrs)
{
  return win.attrs = attrs;
}
///ditto
int attr_set(A:attr_t, S:short, V:void)(A attrs, S pair, V* opts)
{
  return wattr_set(stdscr, attrs, pair, opts);
}
///ditto
int wattr_set(W:WINDOW, A:attr_t, S:short, V:void)
  (W* win, A attrs, S pair, V* opts)
{
  return win.attrs = (attrs & ~A_COLOR) | COLOR_PAIR(pair);
}
/**
 * Sets the window's fore/back color attributes.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * Params:
 *      color_pair_number = the color_pair that represents
 *                          what the new attributes are to be.
 *                   opts = reserved for future use.  Always use null.
 * See_also: man curs_attr
 */
int color_set(N:short, V:void)(N color_pair_number, V* opts)
{
  return wcolor_set(stdscr, color_pair_number, opts);
}
///ditto
int wcolor_set(WINDOW* win, short color_pair_number, void* opts);
/**
 * Turns off all attributes.
 *
 * Returns: A_NORMAL.
 * See_also: man curs_attr
 */
int standend()()
{
  return wstandend(stdscr);
}
///ditto
int wstandend(W:WINDOW)(W* win)
{
  return wattrset(win, A_NORMAL);
}
/**
 * Sets the standout window attribute eg. attrset(A_STANDOUT).
 *
 * Returns: A_STANDOUT.
 * See_also: man curs_attr
 */
int standout()()
{
  return wstandout(stdscr);
}
///ditto
int wstandout(W:WINDOW)(W* win)
{
  return wattrset(win, A_STANDOUT);
}
/**
 * Gets the current attributes and color pair.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * Params:
 *       pair = this will hold the color pair.
 *      attrs = this will hold the attributes.
 *       opts = reserved for future use.  Always use null.
 * See_also: man curs_attr
 */
int attr_get(A:attr_t, S:short, V:void)(A* attrs, S* pair, V* opts)
{
  return wattr_get(stdscr, attrs, pair, opts);
}
///ditto
int wattr_get(W:WINDOW, A:attr_t, S:short, V:void)
  (W* win, A* attrs, S* pair, V* opts)
{
  if(attrs == null || pair == null)
    return ERR;

  *attrs = win.attrs;
  *pair = PAIR_NUMBER(win.attrs);
  return OK;
}
/**
 * Changes attributes for n characters.
 *
 * Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
 * Params:
 *          n = number of characters to change
 *       pair = this will hold the color pair.
 *       attr = this will hold the attributes.
 *       opts = reserved for future use.  Always use null.
 * See_also: man curs_attr
 */
int chgat(N:int, A:attr_t, S:short, V:void)(N n, A attr, S color, V* opts)
{
  return wchgat(stdscr, n, attr, color, opts);
}
///ditto
int wchgat(WINDOW* win, int n, attr_t attr, short color, void* opts);
///ditto
int mvchgat(N:int, A:attr_t, S:short, V:void)
  (N y, N x, N n, A attr, S color, V* opts)
{
  return mvwchgat(stdscr, y, x, n, attr, color, opts);
}
///ditto
int mvwchgat(W:WINDOW, N:int, A:attr_t, S:short, V:void)
  (W* win, N y, N x, N n, A attr, S color, V* opts)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wchgat(win, n, attr, color, opts);
}
/**
  Returns color pair n.
  */
chtype COLOR_PAIR(N:int)(N n)
{
  return cast(chtype)(n<<8);
}
/**
  Inverse of COLOR_PAIR
  */
short PAIR_NUMBER(A:attr_t)(A attrs)
{
  return (attrs & A_COLOR) >> 8;
}
/**
  Attributes that can be passed to attron, attrset, attroff or OR'd with
  the characters passed to addch.
  */
enum :chtype
{
///Normal
  A_NORMAL      = 0x0,
///ditto
  WA_NORMAL     = A_NORMAL,
///Best highlighting
  A_STANDOUT    = 0x10000,
///ditto
  WA_STANDOUT   = A_STANDOUT,
///Underlined
  A_UNDERLINE   = 0x20000,
///ditto
  WA_UNDERLINE  = A_UNDERLINE,
///Reverse Video
  A_REVERSE     = 0x40000,
///ditto
  WA_REVERSE    = A_REVERSE,
///Blinking
  A_BLINK       = 0x80000,
///ditto
  WA_BLINK      = A_BLINK,
///Half as bright
  A_DIM         = 0x100000,
///ditto
  WA_DIM        = A_DIM,
///Bold
  A_BOLD        = 0x200000,
///ditto
  WA_BOLD       = A_BOLD,
///Protected
  A_PROTECT     = 0x1000000,
///ditto
  WA_PROTECT    = A_PROTECT,
///Invisible/Blank
  A_INVIS       = 0x800000,
///ditto
  WA_INVIS      = A_INVIS,
///Alternate character set
  A_ALTCHARSET  = 0x400000,
///ditto
  WA_ALTCHARSET = A_ALTCHARSET,
///Bitmask to get only the character
  A_CHARTEXT    = 0xFF,
///Bitmask to get everything but the character
  A_ATTRIBUTES  = 0xFFFFFF00,
///ditto
  WA_ATTRIBUTES = A_ATTRIBUTES,
///Bitmask to get the color
  A_COLOR       = 0xFF00,
///Unimplemented?
  A_HORIZONTAL  = 0x2000000,
///ditto
  WA_HORIZONTAL = A_HORIZONTAL,
///ditto
  A_LEFT        = 0x4000000,
///ditto
  WA_LEFT       = A_LEFT,
///ditto
  A_LOW         = 0x8000000,
///ditto
  WA_LOW        = A_LOW,
///ditto
  A_RIGHT       = 0x10000000,
///ditto
  WA_RIGHT      = A_RIGHT,
///ditto
  A_TOP         = 0x20000000,
///ditto
  WA_TOP        = A_TOP,
///ditto
  A_VERTICAL    = 0x40000000,
///ditto
  WA_VERTICAL   = A_VERTICAL
}
/**
Routines to ring bell, or flash screen

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_beep
  */
int beep();
///ditto
int flash();

/**
Manipulate the background characters of a window. The bkgd routines
apply the setting to every character on the screen.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_bkgd
  */
void bkgdset(C:chtype)(C ch)
{
  return wbkgdset(stdscr, ch);
}
///ditto
void wbkgdset(WINDOW* win, chtype ch);
///ditto
int bkgd(C:chtype)(C ch)
{
  return wbkgd(stdscr, ch);
}
///ditto
int wbkgd(WINDOW* win, chtype ch);
///ditto
chtype getbkgd(W:WINDOW)(W* win)
{
  return win.bkgd;
}

/**
Manipulate the complex background characters of a window. The bkgrnd
routines apply the setting to every character on the screen.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_bkgrnd
  */
int bkgrnd(C:cchar_t)(C* wch)
{
  return wbkgrnd(stdscr, wch);
}
///ditto
int wbkgrnd(WINDOW* win, cchar_t* wch);
///ditto
void bkgrndset(C:cchar_t)(C* wch )
{
  wbkgrndset(stdscr, wch);
}
///ditto
void wbkgrndset(WINDOW* win, cchar_t* wch);
///ditto
int getbkgrnd(C:cchar_t)(C* wch)
{
  return wgetbkgrnd(stdscr, wch);
}
///ditto
int wgetbkgrnd(W:WINDOW, C:cchar_t)(W* win, C* wch)
{
  *wch=win.bkgrnd;
  return OK;
}

/**
Draw a box around the window. A zero parameter for any of the character
parameters will draw with the default ACS character for a line/corner.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
Params:
ls = left side,
rs = right side,
ts = top side,
bs = bottom side,
tl = top left-hand corner,
tr = top right-hand corner,
bl = bottom left-hand corner, and
br = bottom right-hand corner.

See_also: man curs_border
  */
int border(C:chtype)(C ls, C rs, C ts, C bs, C tl, C tr, C bl, C br)
{
  return wborder(stdscr, ls, rs, ts, bs, tl, tr, bl, br);
}
///ditto
int wborder(WINDOW* win, chtype ls, chtype rs,
  chtype ts, chtype bs, chtype tl, chtype tr,
  chtype bl, chtype br);
/**
Same as wborder(win, verch, verch, horch, horch, 0, 0, 0, 0)

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_border
*/
int box(W:WINDOW, C:chtype)(W* win, C verch, C horch)
{
  return wborder(win, verch, verch, horch, horch, 0, 0, 0, 0);
}
/**
Draw a horizontal or vertical line in the window.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_border
*/
int hline(C:chtype, N:int)(C ch, N n)
{
  return whline(stdscr, ch, n);
}
///ditto
int whline(WINDOW* win, chtype ch, int n);
///ditto
int vline(C:chtype, N:int)(C ch, N n)
{
  return wvline(stdscr, ch, n);
}
///ditto
int wvline(WINDOW* win, chtype ch, int n);
///ditto
int mvhline(N:int, C:chtype)(N y, N x, C ch, N n)
{
  return mvwhline(stdscr, y, x, ch, n);
}
///ditto
int mvwhline(W:WINDOW, N:int, C:chtype)(W* win, N y, N x, C ch, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return whline(win, ch, n);
}
///ditto
int mvvline(N:int, C:chtype)(N y, N x, C ch, N n)
{
  return mvwvline(stdscr, y, x, ch, n);
}
///ditto
int mvwvline(W:WINDOW, N:int, C:chtype)(W* win, N y, N x, C ch, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wvline(win, ch, n);
}

/**
Draw a box around the window. A null parameter for any of the character
parameters will draw with the default ACS character for a line/corner.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
Params:
ls = left side,
rs = right side,
ts = top side,
bs = bottom side,
tl = top left-hand corner,
tr = top right-hand corner,
bl = bottom left-hand corner, and
br = bottom right-hand corner.

See_also: man curs_border_set
  */
int border_set(C:cchar_t)
  (C* ls, C* rs, C* ts, C* bs, C* tl, C* tr, C* bl, C* br)
{
  return wborder_set(stdscr, ls, rs, ts, bs, tl, tr, bl, br);
}
///ditto
int wborder_set(
  WINDOW* win,
  cchar_t* ls, cchar_t* rs, cchar_t* ts, cchar_t* bs,
  cchar_t* tl, cchar_t* tr, cchar_t* bl, cchar_t* br);
/**
Same as wborder_set(win, verch, verch, horch, horch, null, null, null,
null)

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_border_set
*/int box_set(W:WINDOW, C:cchar_t)(W* win, C* verch, C* horch)
{
  return wborder_set
    (win, verch, verch, horch, horch, null, null, null, null);
}
/**
Draw a horizontal or vertical line in the window.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_border_set
*/
int hline_set(C:cchar_t, N:int)(C* wch, N n)
{
  return whline_set(stdscr, wch, n);
}
///ditto
int whline_set(WINDOW* win, cchar_t* wch, int n);
///ditto
int mvhline_set(N:int, C:cchar_t)(N y, N x, C* wch, N n)
{
  return mvwhline_set(stdscr, y, x, wch, n);
}
///ditto
int mvwhline_set(W:WINDOW, N:int, C:cchar_t)
  (W* win, N y, N x, C* wch, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return whline_set(win, wch, n);
}
///ditto
int vline_set(C:cchar_t, N:int)(C* wch, N n)
{
  return wvline_set(stdscr, wch, n);
}
///ditto
int wvline_set(WINDOW* win, cchar_t* wch, int n);
///ditto
int mvvline_set(N:int, C:cchar_t)(N y, N x, C* wch, N n)
{
  return mvwvline_set(stdscr, y, x, wch, n);
}
///ditto
int mvwvline_set(W:WINDOW, N:int, C:cchar_t)
  (W* win, N y, N x, C* wch, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wvline_set(win, wch, n);
}

/**
Write blanks to the whole window.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_clear
*/
int erase()()
{
  return werase(stdscr);
}
///ditto
int werase(WINDOW* win);
/**
Similar to erase, but also forces the window to repaint from scratch on
the next refresh.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_clear
*/
int clear()()
{
  return wclear(stdscr);
}
///ditto
int wclear(WINDOW* win);
/**
Clears from cursor to bottom of the screen.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_clear
*/
int clrtobot()()
{
  return wclrtobot(stdscr);
}
///ditto
int wclrtobot(WINDOW* win);
/**
Clears from cursor to end of the line.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_clear
*/
int clrtoeol()()
{
  return wclrtoeol(stdscr);
}
///ditto
int wclrtoeol(WINDOW* win);

///Maximum number of colors supported
extern int COLORS;
///Maximum number of color pairs supported
extern int COLOR_PAIRS;
/**
Call before using any other color manipulation routines.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_color
*/
int start_color();
/**
Initialize a new color pair.

Params:
pair=index of the new pair
f=foreground color
b=background color

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_color
*/
int init_pair(short pair, short f, short b);
/**
Changes the definition of a color.  When used all colors on the
screen with that color change to the new definition.

Params:
color=the color to define ranged 0..COLORS
r=red component ranged 0..1000
g=green component ranged 0..1000
b=blue component ranged 0..1000

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_color
*/
int init_color(short color, short r, short g, short b);
/**
Check to see whether the terminal can manipulate colors.

See_also: man curs_color
*/
bool has_colors();
/**
Check to see whether you can change the color definitions.

See_also: man curs_color
*/
bool can_change_color();
/**
Get the color components for the specified color.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_color
*/
int color_content(short color, short* r, short* g, short* b);
/**
Get the foreground and background colors of the specified pair.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_color
*/
int pair_content(short pair, short* f, short* b);
enum :chtype
{
///Predefined colors
  COLOR_BLACK   = 0,
///ditto
  COLOR_RED     = 1,
///ditto
  COLOR_GREEN   = 2,
///ditto
  COLOR_YELLOW  = 3,
///ditto
  COLOR_BLUE    = 4,
///ditto
  COLOR_MAGENTA = 5,
///ditto
  COLOR_CYAN    = 6,
///ditto
  COLOR_WHITE   = 7
}

/**
Delete a character. Shifts characters to the right of the character over.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_delch
*/
int delch()()
{
  return wdelch(stdscr);
}
///ditto
int wdelch(WINDOW* win);
///ditto
int mvdelch(N:int)(N y, N x)
{
  return mvwdelch(stdscr, y, x);
}
///ditto
int mvwdelch(W:WINDOW, N:int)(W* win, N y, N x)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wdelch(win);
}

/**
Delete line, moving lines below up.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_deleteln
*/
int deleteln()()
{
  return winsdelln(stdscr, -1);
}
///ditto
int wdeleteln(W:WINDOW)(W* win)
{
  return winsdelln(win, -1);
}
/**
For n>0, insert n lines above the current line. For n<0 delete n lines
and move the remaining lines up.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_deleteln
*/
int insdelln(N:int)(N n)
{
  return winsdelln(stdscr, n);
}
///ditto
int winsdelln(WINDOW* win, int n);
/**
Insert a blank line above the current line.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.
See_also: man curs_deleteln
*/
int insertln()()
{
  return winsdelln(stdscr, 1);
}
///ditto
int winsertln(W:WINDOW)(W* win)
{
  return winsdelln(win, 1);
}

/**
Get the version number of the ncurses library.

See_also: man curs_extend
*/
char* curses_version();
/**
Controls whether the calling app can use nonstandard names from terminfo.

See_also: man curs_extend;
*/
int use_extended_names(bool enable);

/**
Read a character from the terminal.

Returns: $(D_PARAM KEY_CODE_YES) when a function key is pressed. $(D_PARAM OK) when a wide character is reported. $(D_PARAM ERR) otherwise.

See_also: man curs_get_wch
*/
int get_wch(WN:wint_t)(WN* wch)
{
  return wget_wch(stdscr, wch);
}
///ditto
int wget_wch(WINDOW* win, wint_t* wch);
///ditto
int mvget_wch(N:int, WN:wint_t)(N y, N x, WN* wch)
{
  return mvwget_wch(stdscr, y, x, wch);
}
///ditto
int mvwget_wch(W:WINDOW, N:int, WN:wint_t)(W* win, N y, N x, WN* wch)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wget_wch(win, wch);
}
/**
Pushes a character back onto the input queue. Only one push back is
guaranteed.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_get_wch
*/
int unget_wch(wchar_t wch);

/**
Read input into a string until a newline, end of line, or end of file
is reached. Functions that take an n parameter read at most n characters.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_get_wstr
*/
int get_wstr(WN:wint_t)(WN* wstr)
{
  return wget_wstr(stdscr, wstr);
}
///ditto
int getn_wstr(WN:wint_t, N:int)(WN* wstr, N n)
{
  return wgetn_wstr(stdscr, wstr, n);
}
///ditto
int wget_wstr(W:WINDOW, WN:wint_t)(W* win, WN* wstr)
{
  return wgetn_wstr(win, wstr, -1);
}
///ditto
int wgetn_wstr(WINDOW* win, wint_t* wstr, int n);
///ditto
int mvget_wstr(N:int, WN:wint_t)(N y, N x, WN* wstr)
{
  return mvwget_wstr(stdscr, y, x, wstr);
}
///ditto
int mvgetn_wstr(N:int, WN:wint_t)(N y, N x, WN* wstr, N n)
{
  return mvwgetn_wstr(stdscr, y, x, wstr, n);
}
///ditto
int mvwget_wstr(W:WINDOW, N:int, WN:wint_t)(W* win, N y, N x, WN* wstr)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wget_wstr(win, wstr);
}
///ditto
int mvwgetn_wstr(W:WINDOW, N:int, WN:wint_t)
  (W* win, N y, N x, WN* wstr, N n)
{
  if(wmove(win, y, x) == ERR)
    return ERR;
  return wgetn_wstr(win, wstr, n);
}

/**
Gets a wide character string and rendering data from a cchar_t.
If wch is not null getcchar fills out the other parameters.
If wch is null, getcchar doesn't fill anything out, but returns
the number of characters in the cchar_t

Params:
opts=Reserved for future use. Always null.

Returns: $(D_PARAM OK) or length of string when successful and $(D_PARAM ERR) when not.

See_also: man curs_getcchar
*/
int getcchar(cchar_t* wcval, wchar_t* wch, attr_t* attrs,
    short* color_pair, void* opts);
/**
Fills out a cchar_t with color, attribute, and string data. The string
needs to be null terminated

Params:
opts=Reserver for future use. Use null.

Returns: $(D_PARAM OK) when successful and $(D_PARAM ERR) when not.

See_also: man curs_getcchar
*/
int setcchar(cchar_t *wcval, wchar_t* wch, attr_t attrs,
    short color_pair, void* opts );

/* character get functions */
int getch();
int wgetch(WINDOW* win);
int mvgetch(int y, int x);
int mvwgetch(WINDOW* win, int y, int x);
int ungetch(int ch);
int has_key(int ch);

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

/* refresh functions */
int refresh();
int wrefresh(WINDOW* win);
int wnoutrefresh(WINDOW* win);
int doupdate();
int redrawwin(WINDOW* win);
int wredrawln(WINDOW* win, int beg_line, int num_lines);

/* output options */
int clearok(WINDOW* win, bool bf);
int idlok(WINDOW* win, bool bf);
void idcok(WINDOW* win, bool bf);
void immedok(WINDOW* win, bool bf);
int leaveok(WINDOW* win, bool bf);
int wsetscrreg(WINDOW* win, int top, int bot);
int setscrreg(N:int)(N top, N bot)
{
  return wsetscrreg(stdscr, top, bot);
}
int scrollok(WINDOW* win, bool bf);
int nl();
int nonl();

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

