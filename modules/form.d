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

module form;

import ncurses:chtype;

extern(C):

typedef void FIELD;
typedef void FORM;
enum OPTIONS
{
  O_VISIBLE  = 0x0001,
  O_ACTIVE   = 0x0002,
  O_PUBLIC   = 0x0004,
  O_EDIT     = 0x0008,
  O_WRAP     = 0x0010,
  O_BLANK    = 0x0020,
  O_AUTOSKIP = 0x0040,
  O_NULLOK   = 0x0080,
  O_PASSOK   = 0x0100,
  O_STATIC   = 0x0200,

  O_NL_OVERLOAD = 0x0001,
  O_BS_OVERLOAD = 0x0002
}

FIELD* new_field(int height, int width,
                int toprow, int leftcol,
                int offscreen, int nbuffers);
FIELD* dup_field(FIELD* field, int toprow, int leftcol);
FIELD* link_field(FIELD* field, int toprow, int leftcol);
int free_field(FIELD* field);
FORM* new_form(FIELD** fields);
int free_form(FORM* form);
int post_form(FORM* form);
int unpost_form(FORM* form);
int form_driver(FORM* form, int c);
int set_field_fore(FIELD* field, chtype attr);
chtype field_fore(FIELD* field);
int set_field_back(FIELD* field, chtype attr);
chtype field_back(FIELD* field);
int set_field_pad(FIELD* field, int pad);
int field_pad(FIELD* field);
int set_field_opts(FIELD* field, OPTIONS opts);
int field_opts_on(FIELD* field, OPTIONS opts);
int field_opts_off(FIELD* field, OPTIONS opts);
OPTIONS field_opts(FIELD* field);
int field_info(FIELD* field, int* rows, int* cols,
   int* frow, int* fcol, int* nrow, int* nbuf);
int  dynamic_field_info(FIELD* field, int* rows, int* cols,
   int* max);
int set_form_fields(FORM* form, FIELD** fields);
FIELD** form_fields(FORM* form);
int field_count(FORM* form);
int move_field(FIELD* field, int frow, int fcol);
int set_field_just(FIELD* field, int justification);
int field_just(FIELD* field);


enum
{
  REQ_NEXT_PAGE         = 0x200,
  REQ_PREV_PAGE         = 0x201,
  REQ_FIRST_PAGE        = 0x202,
  REQ_LAST_PAGE         = 0x203,

  REQ_NEXT_FIELD        = 0x204,
  REQ_PREV_FIELD        = 0x205,
  REQ_FIRST_FIELD       = 0x206,
  REQ_LAST_FIELD        = 0x207,
  REQ_SNEXT_FIELD       = 0x208,
  REQ_SPREV_FIELD       = 0x209,
  REQ_SFIRST_FIELD      = 0x20A,
  REQ_SLAST_FIELD       = 0x20B,
  REQ_LEFT_FIELD        = 0x20C,
  REQ_RIGHT_FIELD       = 0x20D,
  REQ_UP_FIELD          = 0x20E,
  REQ_DOWN_FIELD        = 0x20F,

  REQ_NEXT_CHAR         = 0x210,
  REQ_PREV_CHAR         = 0x211,
  REQ_NEXT_LINE         = 0x212,
  REQ_PREV_LINE         = 0x213,
  REQ_NEXT_WORD         = 0x214,
  REQ_PREV_WORD         = 0x215,
  REQ_BEG_FIELD         = 0x216,
  REQ_END_FIELD         = 0x217,
  REQ_BEG_LINE          = 0x218,
  REQ_END_LINE          = 0x219,
  REQ_LEFT_CHAR         = 0x21A,
  REQ_RIGHT_CHAR        = 0x21B,
  REQ_UP_CHAR           = 0x21C,
  REQ_DOWN_CHAR         = 0x21D,

  REQ_NEW_LINE          = 0x21E,
  REQ_INS_CHAR          = 0x21F,
  REQ_INS_LINE          = 0x220,
  REQ_DEL_CHAR          = 0x221,
  REQ_DEL_PREV          = 0x222,
  REQ_DEL_LINE          = 0x223,
  REQ_DEL_WORD          = 0x224,
  REQ_CLR_EOL           = 0x225,
  REQ_CLR_EOF           = 0x226,
  REQ_CLR_FIELD         = 0x227,
  REQ_OVL_MODE          = 0x228,
  REQ_INS_MODE          = 0x229,
  REQ_SCR_FLINE         = 0x22A,
  REQ_SCR_BLINE         = 0x22B,
  REQ_SCR_FPAGE         = 0x22C,
  REQ_SCR_BPAGE         = 0x22D,
  REQ_SCR_FHPAGE        = 0x22E,
  REQ_SCR_BHPAGE        = 0x22F,
  REQ_SCR_FCHAR         = 0x230,
  REQ_SCR_BCHAR         = 0x231,
  REQ_SCR_HFLINE        = 0x232,
  REQ_SCR_HBLINE        = 0x233,
  REQ_SCR_HFHALF        = 0x234,
  REQ_SCR_HBHALF        = 0x235,

  REQ_VALIDATION        = 0x236,
  REQ_NEXT_CHOICE       = 0x237,
  REQ_PREV_CHOICE       = 0x238,

  MIN_FORM_COMMAND      = 0x200,
  MAX_FORM_COMMAND      = 0x238
}
enum
{
  NO_JUSTIFICATION = 0,
  JUSTIFY_LEFT     = 1,
  JUSTIFY_CENTER   = 2,
  JUSTIFY_RIGHT    = 3
}
