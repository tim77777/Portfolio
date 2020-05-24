#!/bin/bash
grep -r ' sed' ..         #all sed statements
grep -r '^m' ..           #all lines starting with m
grep -rE '[0-9]{3,}' ..   #all lines containg three digits
grep -rE 'echo([[:space:]]+[^[:space:]]+[^e-][^-n]){3,}' ..   #contains echo and followed by at least 3 words
grep -rP '^(?=.{8,32}$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).*' ..