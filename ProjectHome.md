What it is:
  * A set of modules that provide an extremely thin binding for the curses library in D.

Please take a look at the [project home page](http://sites.google.com/site/ylixir/projects/ycurses) for more information. Or see the current status of the project by looking at the [roadmap](http://sites.google.com/site/ylixir/projects/ycurses/ycurses-roadmap-1).

**Caveats:**
  1. D arrays != C arrays. If your program seg faults, it's probably related to an array issue. Make sure all your arrays (including strings) are `null` terminated, and make sure you are passing a pointer to the array data.
  1. `ACS_` "constants".  This can't be implemented as far as i can tell without adding a separate library to link, which i don't want to do. Instead of `ACS_whatever` use `acs_map[ACS.whatever]`
  1. D strings != C char[.md](.md) or even const char.ptr.  D strings are by default immutable char.ptr.  D char[.md](.md)s and strings may or may not be null terminated.