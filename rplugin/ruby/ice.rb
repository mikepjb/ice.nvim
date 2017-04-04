require 'neovim'
require_relative '../../lib/neovim_client'

@log = []

Neovim.plugin do |plug|
  plug.command(:Eval, :nargs => '?', :range => true) do |nvim, *args|
    NeovimClient::eval(nvim, args, @log)
  end

  plug.command(:Require, :nargs => 0) do |nvim|
    NeovimClient::require(nvim, @log)
  end

  plug.command(:Log, :nargs => 0) do |nvim|
    NeovimClient::log(nvim, @log)
  end

  plug.command(:Trace, :nargs => 0) do |nvim|
    NeovimClient::trace(nvim, @log)
  end
end
