# VIM rubyapp #

VIM shortcuts to start, stop and restart rack-based ruby app.

Some assumption first
  - we are working on a rack-based ruby app
  - your vim is compiled with ruby-interp enabled
  - your linux has xdotool and wmctrl installed


## Installation ##

I recommand you to install this plugin with Vundle, just add this line to your .vimrc:

    Bundle "loki-nkl/vim-rubyapp"


## Usage ##

Below is the default key bindings.

    <leader>r restart_rubyapp
    <leader>fa focus_rubyapp
    <leader>k kill_rubyapp
    <leader>c start_console
    <leader>sb svn_blame


## Customization ##

    let g:rubyapp_terminal="terminator"
    let g:rubyapp_server="thin"
    let g:rubyapp_port="9292"

    " script to run before starting console / app server
    let g:rubyapp_prescript=""

    " normally I map this to my redmine repository root
    let g:rubyapp_blame_url="please override me"

    " override to 'rails c' if you want
    let g:rubyapp_console="rake c"

