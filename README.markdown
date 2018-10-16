# pandoc-abbreviations.lua

This is a [pandoc lua
filter](https://pandoc.org/lua-filters.html) that replaces abbreviations
specified in the yaml metadata block. For example, supposing `example.md`
contains the following text: 

```
---
title: "An example"
author: "John Doe"
abbreviations:
   +jd: "John Doe"
   +yolo: "you only live once"
   +ex: "<http://example.com>"
...

It is true, +yolo! So you should visit +ex. Tell 'em +jd sent you.

```

when you process the file using the filter, 

```
pandoc --lua-filter pandoc-abbreviations.lua example.md
```

the result is this:

```
It is true, you only live once! So you should visit
<http://example.com>. Tell 'em John Doe sent you.
```

## Default abbreviations

If a file with the name `abbreviations.yml` is in the current directory, it
will also be processed. Likewise, if a file with the name `abbreviations.yml`
is in `$HOME/.pandoc/`, it will be processed. These files should be formatted
as pandoc-readable files, e.g.,

```
---
abbreviations:
   +lol: laugh out loud
   +rolf: roll on the floor laughing
...
```

There is no well-defined behavior for handling conflicting abbreviations.

## Punctuation

The filter tries to be smart about punctuation. (+lol) should get expanded, as
should +lol, +lol; +lol... But I am sure there are things that won't
work---+lol, for example.

## Abbreviation Keys

Abbreviation keys do not need to begin with `+`. That's just a convention I am
borrowing from [pandoc-abbreviations](https://github.com/scokobro/pandoc-abbreviations), which is implemented in python instead of lua. I *think* this implementation should be more reliable. It is certainly more lightweight.






