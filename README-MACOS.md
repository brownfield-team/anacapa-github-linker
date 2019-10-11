# `README-MACOS.md`

This file provides some information on setting up your computer to run the anacapa-github-linker locally for development under MacOS.

It is not intended to replace the information in README.md, which you will also need.  It's more the Mac specific stuff
you may need to do before you start reading that document.

# Step 1: Get `rvm`, the Ruby Version Manager on your Mac.

Just kidding.   In order to get `rvm`, you'll probably first need to get gpg2 working.

And to do that, you'll probably need either `brew` or `macports`.

Here's why: if you visit <https://rvm.io/> which is the link where you install `rvm`, the first instruction
is to run a `gpg2` command.   And you'll need `brew` or `macports` to install `gpg2`.

What are `brew` and `macports`?  They are package managers (similar to `apt-get` on Linux) for MacOS, for all of the open source software that comes from 
places such as GNU, but for MacOS.

* To get brew, visit <https://brew.sh>
* To get macports, visit <https://www.macports.org/>

Once you have either `brew` or `macports`, then make sure that you have `gpg2`.  

* TODO: Figure out the command for that and put it here.

# Step 2: Put the Postgres.app on your Mac (the Elephant)

Visit: <https://postgresapp.com/> and install the "Elephant" version of Postgres (a SQL database) on your Mac.

Why Postgres and not MySQL, or `sqlite`, etc.?  Because: Heroku.

# That's it!  You are ready for [README.md](README.md)
