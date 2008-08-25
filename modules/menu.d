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
module menu;

public import ncurses, eti;

extern(C):

typedef void ITEM;
typedef void MENU;

/**
Set/get the foreground (selected) attribute of menu.

Returns: $(D_PARAM E_OK), $(D_PARAM E_SYSTEM_ERROR),
$(D_PARAM E_BAD_ARGUMENT).

See_also: man menu_attributes
*/
int set_menu_fore(MENU* menu, chtype attr);
///ditto
chtype menu_fore(MENU* menu);
/**
Set/get the background(unselected) attribute of menu.

Returns: $(D_PARAM E_OK), $(D_PARAM E_SYSTEM_ERROR),
$(D_PARAM E_BAD_ARGUMENT).
See_also: man menu_attributes
*/
int set_menu_back(MENU* menu, chtype attr);
///ditto
chtype menu_back(MENU* menu);
/**
Set/get the grey(disabled) attribute of menu.

Returns: $(D_PARAM E_OK), $(D_PARAM E_SYSTEM_ERROR),
$(D_PARAM E_BAD_ARGUMENT).

See_also: man menu_attributes
*/
int set_menu_grey(MENU* menu, chtype attr);
///ditto
chtype menu_grey(MENU* menu);
/**
Set/get padding character for the menu.

Returns: $(D_PARAM E_OK), $(D_PARAM E_SYSTEM_ERROR),
$(D_PARAM E_BAD_ARGUMENT).

See_also: man menu_attributes
*/
int set_menu_pad(MENU* menu, int pad);
///ditto
int menu_pad(MENU* menu);

/**
Move the cursor to the current position associated with the menu's selected
item.

Returns: $(D_PARAM E_OK), $(D_PARAM E_SYSTEM_ERROR),
$(D_PARAM E_BAD_ARGUMENT), $(D_PARAM E_NOT_POSTED).

See_also: man menu_cursor
*/
int pos_menu_cursor(MENU* menu);

/**
Routine to handle menu input.

See_also: man menu_driver
*/
int menu_driver(MENU* menu, int c);
//driver commands
enum :int
{
  ///move to item on the left
  REQ_LEFT_ITEM     = 0x200,
  ///move to item on the right
  REQ_RIGHT_ITEM    = 0x201,
  ///move to item above
  REQ_UP_ITEM       = 0x202,
  ///move to item below
  REQ_DOWN_ITEM     = 0x203,
  ///scroll up a line
  REQ_SCR_ULINE     = 0x204,
  ///scroll down a line
  REQ_SCR_DLINE     = 0x205,
  ///scroll down a page
  REQ_SCR_DPAGE     = 0x206,
  ///scroll up a page
  REQ_SCR_UPAGE     = 0x207,
  ///go to the first item
  REQ_FIRST_ITEM    = 0x208,
  ///go to the last item
  REQ_LAST_ITEM     = 0x209,
  ///go to the next item
  REQ_NEXT_ITEM     = 0x20A,
  ///go to the previous item
  REQ_PREV_ITEM     = 0x20B,
  ///toggle an items selection
  REQ_TOGGLE_ITEM   = 0x20C,
  ///clear the menu pattern buffer
  REQ_CLEAR_PATTERN = 0x20D,
  ///delete the last character from the pattern buffer
  REQ_BACK_PATTERN  = 0x20E,
  ///move to the next item matching the pattern match
  REQ_NEXT_MATCH    = 0x20F,
  ///move to the previous item matching the pattern match
  REQ_PREV_MATCH    = 0x210,

  MIN_MENU_COMMAND  = 0x200,
  MAX_MENU_COMMAND  = 0x210
}

/**
Set/get the max display size of a menu.

See_also: man menu_format
*/
int set_menu_format(MENU* menu, int rows, int cols);
///ditto
void menu_format(MENU* menu, int* rows, int* cols);

/**
Set/get the hook to be called when a menu posts and when the item
selection changes (after the change).

See_also: menu_hook
*/
int set_item_init(MENU* menu, void* function(MENU*) func);
///ditto
void* function(MENU*) item_init(MENU* menu);
/**
Set/get the hook to be called when a menu unposts and when the item
selection changes (before the change).

See_also: menu_hook
*/
int set_item_term(MENU* menu, void * function(MENU*) func);
///ditto
void* function(MENU*) item_term(MENU* menu);
/**
Set/get the hook to be called when a menu posts and after the top row on the
menu changes.

See_also: menu_hook
*/
int set_menu_init(MENU* menu, void* function(MENU*) func);
///ditto
void* function(MENU*) menu_init(MENU* menu);
/**
Set/get the hook to be called when a menu unposts and before the top row on
the menu changes.

See_also: menu_hook
*/
int set_menu_term(MENU* menu, void* function(MENU*) func);
///ditto
void* function(MENU*) menu_term(MENU* menu);

ITEM* new_item(char* name, char* description);
int free_item(ITEM* item);
MENU* new_menu(ITEM** items);
int free_menu(MENU* menu);
int post_menu(MENU* menu);
int unpost_menu(MENU* menu);
int set_menu_opts(MENU* menu, OPTIONS opts);
int menu_opts_on(MENU* menu, OPTIONS opts);
int menu_opts_off(MENU* menu, OPTIONS opts);
OPTIONS menu_opts(MENU* menu);
int set_menu_win(MENU* menu, WINDOW* win);
WINDOW* menu_win(MENU* menu);
int set_menu_sub(MENU* menu, WINDOW* sub);
WINDOW* menu_sub(MENU* menu);
int scale_menu(MENU* menu, int* rows, int* columns);
int set_menu_mark(MENU* menu, char* mark);
char* menu_mark(MENU* menu);
int set_menu_items(MENU* menu, ITEM** items);
ITEM **menu_items(MENU* menu);
int item_count(MENU* menu);
int set_item_value(ITEM* item, bool value);
bool item_value(ITEM* item);
char *item_name(ITEM* item);
char *item_description(ITEM* item);
int set_item_opts(ITEM* item, OPTIONS opts);
int item_opts_on(ITEM* item, OPTIONS opts);
int item_opts_off(ITEM* item, OPTIONS opts);
OPTIONS item_opts(ITEM* item);
int set_current_item(MENU* menu, ITEM* item);
ITEM* current_item(MENU* menu);
int set_top_row(MENU* menu, int row);
int top_row(MENU* menu);
int item_index(ITEM* item);
int set_item_userptr(ITEM* item, void* userptr);
void* item_userptr(ITEM* item);


enum :OPTIONS
{
  /* menu vals */
  O_ONEVALUE      = 0x01,
  O_SHOWDESC      = 0x02,
  O_ROWMAJOR      = 0x04,
  O_IGNORECASE    = 0x08,
  O_SHOWMATCH     = 0x10,
  O_NONCYCLIC     = 0x20,
  O_SELECTABLE    = 0x01,
}

