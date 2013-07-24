"
" Author: Loki Ng
" Date: 24 July 2013
"
" =================================================================================
"
" Some assumption first
"   - we are working on a rack-based ruby app
"   - your vim is compiled with ruby-interp enabled
"   - your linux has xdotool and wmctrl installed
"
"
if !exists("g:rubyapp")
  let g:rubyapp = 1
endif

let g:rubyapp_terminal="terminator"
let g:rubyapp_server="thin"
let g:rubyapp_port="9292"

" script to run before starting console / app server
let g:rubyapp_prescript=""

" normally I map this to my redmine repository root
let g:rubyapp_blame_url="please override me"

" override to 'rails c' if you want
let g:rubyapp_console="rake c"

" web app management
" ============================================================================
nnoremap <leader>r :ruby RubyApp::restart_rubyapp<cr>
nnoremap <leader>fa :ruby RubyApp::focus_rubyapp<cr>
nnoremap <leader>k :ruby RubyApp::kill_rubyapp<cr>
nnoremap <leader>c :ruby RubyApp::start_console<cr>
nnoremap <leader>sb :ruby RubyApp::svn_blame<cr>

" please note that you may implement #post_restart_rubyapp and #post_kill_rubyapp
" to setup / cleanup env

ruby << EOF
module RubyApp
  instance_eval {
    %w[console terminal server port prescript blame_url].each { |key|
      define_singleton_method key.to_sym do
        VIM::evaluate "g:rubyapp_#{key}"
      end
    }

    def exec cmd
      VIM::command "silent ! #{cmd} &"
    end

    def app_name
      paths = Dir.pwd.split('/')
      last = paths[-1]
      name = last == "trunk" ? paths[-2] : last
      name.gsub /-/, '_'
    end

    def start_cmd
      "#{prescript} rackup -s #{server} -p #{port}"
    end

    def console_cmd
      "#{prescript} #{console}"
    end

    def window_name
      "Rackup #{app_name}"
    end

    def key_in key
      "xdotool key --clearmodifiers --window #{window_id} '#{key}'"
    end

    def type_in text
      "xdotool type --window #{window_id} '#{text}'"
    end

    def window_id
      `xdotool search --name "#{window_name}" | head -n1`.strip
    end

    def restart_real cmd
      system [
        key_in('ctrl+c'),
        type_in(cmd),
        key_in('Return'),
      ].join(';')
    end

    def restart_rubyapp
      if window_id == ""
        exec "#{terminal} --title='#{window_name}'"
        sleep 1
      end
      restart_real start_cmd
      post_restart_rubyapp if respond_to? :post_restart_rubyapp
    end

    def kill_rubyapp
      if window_id != ""
        system key_in('ctrl+c')
        sleep 1
        system key_in('ctrl+d')
      end
      post_kill_rubyapp if respond_to? :post_kill_rubyapp
    end

    def start_console
      id = "#{app_name} console"
      exec "wmctrl -a '#{id}' || #{terminal} --title='#{id}' -e '#{console_cmd}'"
    end

    def focus_rubyapp
      system("wmctrl", "-a", "Rackup #{app_name}")
    end

    def svn_blame
      path  = VIM::evaluate('expand("%:p")')
      base  = VIM::evaluate('getcwd()')
      url   = blame_url + path.sub(base, '')
      exec  "google-chrome #{url}"
    end
  }
end
EOF
