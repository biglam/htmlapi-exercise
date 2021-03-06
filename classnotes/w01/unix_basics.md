# UNIX – what is it?

"Unix is a family of multitasking, multiuser computer operating systems that derive from the original AT&T Unix, developed in the 1970s at the Bell Labs research center." (Thanks, Wikipedia)

[Unix Family Tree](http://www.computerworld.com/article/2524660/operating-systems/the-unix-family-tree.html)

Many computer systems run a flavour of Unix (Linux, Mac OSX, your home broadband router will be most likely running a version too). Unix powers around [70% of the world's web servers][1], and as such, software developers who need to be polyglots need to know about using Unix.


## The Command Line

- ["in the beginning... was the command line"](http://en.wikipedia.org/wiki/In_the_Beginning..._Was_the_Command_Line)

Before we had a GUI (graphical user interface -- mouse pointers and windows) all we had was a command line interface to interact with the computer. The command line is still a prefered way for quick access to your computer's functionality. We will be using this frequently in the course as it will greatly speed up our development process. So we need to get comfortable with it quickly.

- The command line shell is a program that accepts commands as text input and converts commands to appropriate operating system functions.


## Navigating the command prompt

All of the files on your computer are organised into a directory structure (or tree) that starts from the root (referred to as "/"). Directories within directories give us the branching structure that engenders the 'tree' analogy (albeit, upsidedown in most representations).

We will use the command line to find a path through this tree to navigate to the files and directories we need.


## Typing commands

When you first open a Terminal window, the command prompt will be located in your user's "home" directory. You can find out what directory you are in by using `pwd` to show the name of the "present working directory".

The home directory is referred to in shortcuts with the tilde symbol: "~"

`ls` - lists items in current directory
`ls -l` - Will give you a long list of item in the current directory including permissions, size and last modified date.
`ls -a` - will list all items in the current directory including hidden files (files with a dot in front of their names).
`ls -la` - will combine the two options to show a long listing of all files.

`.` - Is a pointer to the current directory (whatever directory you happen to be in)
`..` - Is a pointer to the parent directory (of whatever directory you happen to be in). For instance use `cd ..` to change directory into the parent.

To find out what options a command can accept, use "man" (short for 'manual').

`man ls` - passing 'ls' as an argument to 'man'

To change directory, we use the `cd` command.

`cd <directory name>` - will move us into the specified directory path.
`cd` - Without a specified directory this will take us to our home directory.

The terminal gives you autocomplete functionality, and 'history' of the commands you type.

  - Use the TAB and 'up' key in the command line to increase your speed by using this functionality.

`history` - Will list your entire commands history (use `!line_number` to retrieve a specific command)


## Digging deeper

`grep` - "Global regular expression parser" -- can be used with history to search -- `history | grep <search item>`

The "pipe" symbol is a way of joining commands together in the command line. It takes the output of one command, and uses it as the input for the next.

`df -h` - display free disk space

You can also increase speed further by using aliases (added to the '~/.zshrc' or '~/.bashrc' file) to create personal shortcuts for common commands

```
  alias working='cd ~/project_working'
```


## Managing files

`mkdir <directory name>` - Will create the specified directory.

`touch <filename>` - Will create the specified file

`mv <source> <target>` - Is used for both moving files and renaming them

`rm <filename>` - removes the specified file

`rm -rf <directory name>` - removes the specified directory and all subdirectories and files (use with extreme caution, make sure you are in the right place. "-rf" stands for recursive forced, and you can imagine **how bad the results could be if you did that in your home folder!** Be _very_ careful with this command)

`cp <source> <target>` - Will copy first file to the name of the second file if specified

Be aware, that any files you delete in the terminal *do not* go into the trash/recycle bin -- there is no recovery if you don't have backups.


## Keyboard shortcuts

As you use the terminal more, you will discover many key combinations that speed your productivity.

```
  |keypress|action|
  |--------|------|
  |Ctrl + A|  Go to the beginning of the line you are currently typing on
  |Ctrl + E|  Go to the end of the line you are currently typing on
  |Ctrl + L|  Clears the Screen, similar to the `clear` command
  |Ctrl + H|  Same as backspace
  |Ctrl + R|  Lets you search through previously used commands
  |Ctrl + C|  'Kill' whatever you are running
  |Ctrl + D|  Exit the current shell
  |Ctrl + Z|  Puts whatever you are running into a suspended background process. `fg` restores it.
  |Ctrl + W|  Delete the word before the cursor
  |Ctrl + K|  Clear the line after the cursor
  |Ctrl + T|  Swap the last two characters before the cursor
  |Tab     |  Auto-complete files and folder names
```

Continue to discover commands and shortcuts to improve your days -- there are many resources online: [http://ss64.com/osx/]()


### **Special case **

If you end up in Vim (a command line text editor). Press esc, esc, esc, until we are off the main body area and then `:wq` (colon is a command, w stands for write, and q for quit). If we do not want to save our changes, we use esc, esc, esc, until we are off the main body area and then `:q!`

If you end up in pager (the program that displays multiple pages of text in the terminal - general clues are a colon as a cursor in the bottom-left, and the name "pager" in the window bar), press space to page-down, the arrows move up/down one line at a time, and pressing 'q' quits.


[1]: http://en.wikipedia.org/wiki/Usage_share_of_operating_systems#Public_servers_on_the_Internet

