# ice.nvim

Integrated Clojure Evaluator for Neovim.

### Installation
    - Make sure the ruby on your path has the 'neovim' gem

### Issues
    - :UpdateRemotePlugins will fail if you don't have ruby with access to the 'neovim' gem
    - When 'neovim' gem is not available the failure message is SO unhelpful - solution?
    - Eval doesn't work the first time if double quotes are used, autocmd :Eval quick fix?

### Debugging
    `export NVIM_RUBY_LOG_FILE=~/helpful.log`
