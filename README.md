# ice.nvim

Integrated Clojure Evaluator for Neovim.

This is a neovim plugin that communicates with a local nRepl on port 9999

### How do I use ice.nvim?
You can send code via the command with with
  `Eval (def my-new-function 123)`
And via visual mode by calling `Eval` again

### Installation
    - Make sure the ruby on your path has the 'neovim' gem
    - Install this plugin with your preferred plugin manager
      e.g `Plug 'michaelbruce/ice.nvim'`
    - Run `:UpdateRemotePlugins`
    - Use the plugin, test by running a clojure repl on port 9999 and try `:Eval (def hello-world 123)`

### Issues
    - :UpdateRemotePlugins will fail if you don't have ruby with access to the 'neovim' gem
    - When 'neovim' gem is not available the failure message is SO unhelpful - solution?
    - Eval doesn't work the first time if double quotes are used e.g (def newvar "hello"), autocmd :Eval quick fix?
      # XXX E116: Invalid arguments for function remote#define#CommandBootstrap where quotes are used "
      # XXX note that this error does not occur after the first Eval without " occurs, then including " is fine?!?
      # XXX Also note that this error ONLY occurs when passed in to Eval as 

### Debugging
    `export NVIM_RUBY_LOG_FILE=~/helpful.log`

### Feature Requests
  - better display of the message log
  - display error messages when they are returned in the ex command line
  - run tests should run tests
  - StackTrace should show the last stacktrace in the message log
