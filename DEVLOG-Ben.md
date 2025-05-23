# Dev Log:

This document must be updated daily every time you finish a work session.

## Benjamin Lim

### 2025-05-14 - Made to-do list, set up repo
Pulled repo, updated readme, looked into a [website](https://book.hacktricks.wiki/en/linux-hardening/privilege-escalation/index.html#useful-software) Jady found for linpeas.

### 2025-05-15 - Researched linpeas functionality
Looked into what it returns: info on system info, highlighting potential vulnerabilities.
Wrote in doc about Processes, Cronjobs, Services

### 2024-05-16 - Brief bash foray
Created a bash script that took the output of ls -l and put it in a variable, made an if statement: learned some bash. As well we planned a bit for the steps of our project and format: main file and several diff checks.

### 2024-05-18 - Added to Planning Doc
Added code and planned structure for Timers, Users, and Networks information gathering.

### 2024-05-19 - Pair programming on getting system info
Grabbed a bunch of env data into variables using bash in test.sh.
Watched [video](https://asciinema.org/a/309566) that showed the process of linpeas: it prints a whole lot of stuff w colorcoding for key names and highlights for potential vulnerabilities. Mostly keeps command input intact. The difficult part is definitely going to be writing the logic and conditions for the highlights.

### 2024-05-20 Working with path
Added code to echo path and pseudocoded a way to split the folders by colon, followed by checking if the given folder was vulnerable.

### 2024-05-21 Working more with path
Wrote part of the while loop, next step is to use string indices to grab the folder names and then check against a list of vulnerable folders.

### 2024-05-22 Working more with path (coding in bash is pain)
Using a lot of variables for indexing, got to the point where I loop through each of the folders in $PATH w their names: need to check them against a list now -- made a function (folderlist, folder) to do so

### 2024-05-23
Looking into tryhackme room for path to see what conditions need to be true. It is that the folder is in $PATH and writable: would then make an executable (e.g. for priv esc to root) + set SUID bit. Need to check if a folder writable to everyone but owned by my acct for example is a vulnerable or if it needs to be owned by root.

### 2024-05-19 - Pair programming on getting system info
