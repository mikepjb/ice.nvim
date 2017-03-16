require_relative '../../lib/nrepl_client'

Neovim.plugin do |plug|
  # Define a command called "SetLine" which sets the contents of the current
  # line. This command is executed asynchronously, return value ignored.
  plug.command(:SetLine, :nargs => 1) do |nvim, str|
    nvim.current.line = str
  end

  plug.command(:TestSend, :nargs => 0) do |nvim, str|
    nvim.current.line = "response : #{test_clone}"
  end

  plug.command(:TT, :nargs => 0) do |nvim, str|
    nvim.current.line = "response: #{test_send}"
    # nvim.message("response: #{decoded}")
  end
end
