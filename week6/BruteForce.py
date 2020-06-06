#!/usr/bin/python3
import hashlib
from itertools import product
#Parts of code derived from code provided by author: Thijs van Dien
#https://stackoverflow.com/questions/47952987/how-to-make-all-of-the-permutations-of-a-password-for-brute-force
#Hashes used for testing
#passwordHash = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824" #hello
#passwordHash = "807172cb27fffa2985bb5097ff31c1ec16d6b657eff07d49744e3a0b3e571a8b" #helloh
#passwordHash = "0ebdc3317b75839f643387d783535adc360ca01f33c75f7c1e7373adcd675c0b" #hell
#passwordHash = "8b7df143d91c716ecfa5fc1730022f6b421b05cedee8fd52b1fc65a96030ad52" #blah
passwordHash = "cd6357efdd966de8c0cb2f876cc89ec74ce35f0968e11743987084bd42fb8944" #dog
#passwordHash = "cf04119a706e2c45f587f799676a22b234f349f260e293920a04bdd8e71d73bb" #oh
#passwordHash = "4ccb297e23e645d15888cc9202987f8b6bcaabea8649dcb0909ff429ecd845b5" #a"
#passwordHash = "" #testing
min_length = 1  #minimum length of passowrd to check
max_length = 3  #maximum length of password to check
#character set to iterate through. CAn be expaneded to include symbols
chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" #`~!@#$%^&*()_+|}{\":?><,./;' []\=-"
#Counts the number of hashes calculated
count = 0

def brute_force():
    global count
    for length in range(min_length, max_length + 1): #repeat for the length of proposed password
        for p in product(chars, repeat=length): #returns the cartesian product of the provided itrable with itself for the number of times specified by "repeat"
            string = ''.join(p)                 #join characters in to a string with no separator ''
            print(string)                       #display the current string
            string=string.rstrip()              #strip newline from string
            guess = hashlib.sha256(string.encode("utf-8")).hexdigest() #hash the string
            print(guess)                        #display the hash
            count += 1                          #counts hashes compared
            if guess == passwordHash:           #compare calculated hash with captured hash
                print(guess)                    #display hash
                return string                   #if found, return the  password to the calling function

print("password discovered: %s" %brute_force())
print("number of hashes compared %d" %count)
