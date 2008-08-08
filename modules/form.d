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

version(Tango)
{
  import tango.stdc.stdarg;
}
else
{
  import std.c.stdarg;
}

public import ncurses;

extern(C):

typedef void FIELD;
typedef void FORM;
typedef void FIELDTYPE;

extern FIELDTYPE* TYPE_ALNUM;
extern FIELDTYPE* TYPE_ALPHA;
extern FIELDTYPE* TYPE_ENUM;
extern FIELDTYPE* TYPE_INTEGER;
extern FIELDTYPE* TYPE_NUMERIC;
extern FIELDTYPE* TYPE_REGEXP;
extern FIELDTYPE* TYPE_IPV4;

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
int set_current_field(FORM* form, FIELD* field);
FIELD* current_field(FORM* form);
int set_form_page(FORM* form, int n);
int form_page(FORM* form);
int field_index(FIELD* field);
int set_field_buffer(FIELD* field, int buf, char* value);
char *field_buffer(FIELD* field, int buffer);
int set_field_status(FIELD* field, bool status);
bool field_status(FIELD* field);
int set_max_field(FIELD* field, int max);
int set_field_userptr(FIELD* field, void* userptr);
void* field_userptr(FIELD* field);
int set_form_win(FORM* form, WINDOW* win);
WINDOW* form_win(FORM* form);
int set_form_sub(FORM* form, WINDOW* sub);
WINDOW* form_sub(FORM* form);
int scale_form(FORM* form, int* rows, int* columns);
int set_field_type(FIELD* field, FIELDTYPE* type, ...);
FIELDTYPE* field_type(FIELD* field);
void* field_arg(FIELD* field);
int set_new_page(FIELD* field, bool new_page_flag);
bool new_page(FIELD* field);
FIELDTYPE* new_fieldtype(
   bool function(FIELD*, void*) field_check,
   bool function(int, void*) char_check);
int free_fieldtype(FIELDTYPE* fieldtype);
int set_fieldtype_arg(
   FIELDTYPE* fieldtype,
   void* function(va_list*) make_arg,
   void* function(void*) copy_arg,
   void  function(void*) free_arg);
int set_fieldtype_choice(
   FIELDTYPE *fieldtype,
   bool function(FIELD*, void*) next_choice,
   bool function(FIELD*, void*) prev_choice);
FIELDTYPE* link_fieldtype(FIELDTYPE* type1,
                         FIELDTYPE* type2);

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
