require 'neovim'
require_relative '../../lib/neovim_client'

@log = []

Neovim.plugin do |plug|
  plug.command(:Eval, :nargs => '?', :range => true) do |nvim, *args|
    NeovimClient::eval(nvim, args, @log)
  end

  plug.command(:RunTests, :nargs => 0) do |nvim|
    nvim.echo(run_tests)
  end

  plug.command(:Log, :nargs => 0) do |nvim|
    nvim.current.line = "logs: #{@log}"
  end

  # XXX :StackTrace - show the last stacktrace in @received_messages
  # XXX :Require should use the load-file op - or maybe eval (load-file "currentfile")
end
