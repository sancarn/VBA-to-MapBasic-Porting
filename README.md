# VBA-to-MapBasic-Porting
Porting VBA routines to MapBasic


## Basic Porting Routine:

```
RegexReplace "\bInteger\b" with "SmallInt"
RegexReplace "\bLong\b" with "Integer"
RegexReplace "\bBoolean\b" with "Logical"
RegexReplace "\bMid(" with "Mid$("
RegexReplace "\bLeft(" with "Left$("
RegexReplace "\bRight(" with "Right$("
RegexReplace "\bvbNullChar\b" with "chr$(0)"
RegexReplace "\bchr(" with "chr$("
RegexReplace "\b(\w+\s+as\s+\w+)\s+\*\s+.+\s+" with "\1\r\n"
... TBC
```
