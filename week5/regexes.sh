#!/bin/bash
grep -r  ' sed' ../w*         #all sed statements
grep -r '^m' ../w*           #all lines starting with m
grep -rE '[0-9]{3,}' ../w*   #all lines containg three digits
grep -rE 'echo([[:space:]]+[^[:space:]]+[^e-][^-n]){3,}' ../w*   #contains echo and followed by at least 3 words
grep -rP '^(?=.{8,32}$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*' ../w*