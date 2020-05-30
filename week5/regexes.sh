#!/bin/bash
grep --color -r  ' sed' ../w*          #all sed statements
grep --color -r '^m' ../w*            #all lines starting with m
grep --color -rE '[0-9]{3,}' ../w*    #all lines containg three digits
grep --color -rE 'echo([[:space:]]+[^[:space:]]+[^e-][^-n]){3,}' ../w*    #contains echo and followed by at least 3 words
grep --color -rP '^(?=.{8,32}$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*' ../w* 