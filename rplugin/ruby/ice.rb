require_relative '../../lib/nrepl_client'

Neovim.plugin do |plug|
  plug.command(:TestSend, :nargs => 0) do |nvim, str|
    nvim.current.line = "response : #{test_clone}"
  end

  plug.command(:TT, :nargs => '?') do |nvim, str|
    nvim.current.line = "response: #{test_send}"
  end

  plug.command(:Eval, :nargs => '?') do |nvim, str|
    nvim.command("echo \"#{test_send["value"].gsub('"', '\"')}\"")
  end

  plug.command(:Methods, :nargs => 0) do |nvim, str|
    nvim.current.line = "methods: #{nvim.methods}"
  end
end
