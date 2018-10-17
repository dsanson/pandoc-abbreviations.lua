# pandoc-abbreviations.lua

This is a [pandoc lua
filter](https://pandoc.org/lua-filters.html) that expands abbreviations
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
is in `$HOME/.pandoc/`, it will be processed. Each file should contain
a yaml metadata block, formatted just as it would be if it were in a pandoc
markdown file:

```
---
abbreviations:
   +lol: laugh out loud
   +rolf: roll on the floor laughing
...
```

Abbreviations in the source file take precedence, followed by abbreviations in
the local `abbreviations.yml` file, followed by abbreviations in
`$HOME/.pandoc/abbreviations.yml`.

## Punctuation

Pandoc does most of the heavy lifting for us. The one thing the filter has to
handle is surrounding (non-markdown related) punctuation, and it tries to do
that with regexes.

The current regex should handle:

-   trailing punctuation: `+ymmv,`, `+ymmv.`, `+ymmv!`, `+ymmv...` etc.
-   opening or closing parentheses or brackets: `(+ymmv `, `+ymmv)`, `(+ymmv)`
-   closing parentheses or brackets followed by punctuation
-   closing parentheses preceded by punctuation

The current regex does not do very well with m-dashes and n-dashes.

## Abbreviation Keys

Abbreviation keys do not need to begin with `+`. That's just a convention I am
borrowing from
[pandoc-abbreviations](https://github.com/scokobro/pandoc-abbreviations), a
filter written in python that aims to do much the same thing as this filter.

