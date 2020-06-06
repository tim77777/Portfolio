#!/bin/bash
grep --color -r  ' sed' ../w*          #shows all lines that contain sed statements
grep --color -r '^m' ../w*            #Shows all lines starting with m
grep --color -rE '[0-9]{3,}' ../w*    #shows all lines containg three digits
grep --color -rE 'echo([[:space:]]+[^[:space:]]+[^e-][^-n]){3,}' ../w*    #shows all lines ontaining echo and followed by at least 3 words
grep --color -rP '^(?=.{8,32}$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*' ../w* #shows all lines containing a complex character string 