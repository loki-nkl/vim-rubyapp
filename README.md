# VIM rubyapp #

VIM shortcuts to start, stop and restart rack-based ruby app.

Some assumption first
  - You are working on a rack-based ruby app
  - Your vim is compiled with ruby-interp enabled
  - Your linux has xdotool and wmctrl installed

This plugin is well tested on ubuntu 10.04 and 12.04.


## Installation ##

You may install vim-rubyapp with [vundle] (https://github.com/gmarik/vundle). Let's add a line into your .vimrc:

    Bundle "loki-nkl/vim-rubyapp"
    
And execute BundleInstall.


## Usage ##

Below is the default key bindings.

    <leader>r    Launch a terminal (terminator by default) and rackup the ruby app
    <leader>fa   Raise the window that contains the terminal
    <leader>k    Kill the rackup and close the terminal
    <leader>c    Launch a terminal and start the console, eg. rails c for rails


## Customization ##

Basic setup for starting up a ruby app

    let g:rubyapp_terminal="terminator"
    let g:rubyapp_server="thin"
    let g:rubyapp_port="9292"

Script to run before starting console / app server

    let g:rubyapp_prescript=""

Script to start up your console, feel free to use 'rails c' for rails
    
    let g:rubyapp_console="rake c"

