require_relative '../../lib/nrepl_client'

Neovim.plugin do |plug|
  plug.command(:TestSend, :nargs => 0) do |nvim, args|
    nvim.current.line = "response : #{test_clone}"
  end

  plug.command(:TT, :nargs => '?') do |nvim, args|
    nvim.current.line = "response: #{test_send}"
  end

  # plug.command(:Eval, :nargs => '?', :range => true) do |nvim, args, range_from, range_to, other|
  # XXX E116: Invalid arguments for function remote#define#CommandBootstrap where quotes are used "
  # XXX note that this error does not occur after the first Eval without " occurs, then including " is fine?!?
  plug.command(:Eval, :nargs => '?') do |nvim, args|
    nvim.current.line = "args: #{args}"
    # nvim.current.line = "args: #{args}, range: #{range_from}-#{range_to}, other: #{other}"
    # if args.nil?
    #   nvim.command("echo \"#{test_send}\"")
    # else
    #   # XXX doesn't work the first time if there is a space in args?!?
    #   nvim.command("echo \"#{send(args)}\"")
    # end
  end

  plug.command(:Methods, :nargs => 0) do |nvim, args|
    nvim.current.line = "methods: #{nvim.methods}"
  end

  plug.command(:Str, :nargs => '?') do |nvim, args|
    nvim.command "echo \"#{args}\""
  end
end
