dofile("../lib/stdlib.nut")

local mystrings = ["BCD","ABC","ACB","BDC"]
mystrings.sort(@(a,b) a <=> b)

foreach(s in mystrings) printl(s)