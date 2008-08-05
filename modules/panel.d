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

module panel;

import ncurses:WINDOW;

extern (C):
typedef void PANEL;

PANEL* new_panel(WINDOW *win);;
int bottom_panel(PANEL *pan);
int top_panel(PANEL *pan);
int show_panel(PANEL *pan);
void update_panels();;
int hide_panel(PANEL *pan);
WINDOW* panel_window(PANEL *pan);
int replace_panel(PANEL *pan, WINDOW *window);
int move_panel(PANEL *pan, int starty, int startx);
int panel_hidden(PANEL *pan);
PANEL* panel_above(PANEL *pan);
PANEL* panel_below(PANEL *pan);
int set_panel_userptr(PANEL *pan, void *ptr);
void* panel_userptr(PANEL *pan);
int del_panel(PANEL *pan);

