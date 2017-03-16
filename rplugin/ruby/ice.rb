require_relative '../../lib/nrepl_client'

Neovim.plugin do |plug|
  plug.command(:TestSend, :nargs => 0) do |nvim, args|
    nvim.current.line = "response : #{test_clone}"
  end

  plug.command(:TT, :nargs => '?') do |nvim, args|
    nvim.current.line = "response: #{test_send}"
  end

  plug.command(:Eval, :nargs => '?') do |nvim, args|
    if args.nil?
      nvim.command("echo \"#{test_send["value"].gsub('"', '\"')}\"")
    else
      nvim.command("echo \"#{send(args)["value"].gsub('"', '\"')}\"")
    end
  end

  plug.command(:Methods, :nargs => 0) do |nvim, args|
    nvim.current.line = "methods: #{nvim.methods}"
  end

  plug.command(:Str, :nargs => '?') do |nvim, args|
    nvim.command "echo \"#{args}\""
  end
end
