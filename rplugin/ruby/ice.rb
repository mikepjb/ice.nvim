require_relative '../../lib/nrepl_client'

def parse_command_arguments(nvim, args) # extract and unit test this
  code_to_evaluate = []
  if args.length == 3
    code_to_evaluate << args[0]
  else
    (args[0].to_i..args[1].to_i).each do |line_number|
      code_to_evaluate << nvim.get_current_buffer.get_line(line_number - 1)
    end
  end
  code_to_evaluate.join("\n")
end

Neovim.plugin do |plug|
  # XXX E116: Invalid arguments for function remote#define#CommandBootstrap where quotes are used "
  # XXX note that this error does not occur after the first Eval without " occurs, then including " is fine?!?
  # XXX Also note that this error ONLY occurs when passed in to Eval as 
  # XXX can you collect all args like &args or similar?
  plug.command(:Eval, :nargs => '?', :range => true) do |nvim, *args|
    code = parse_command_arguments(nvim, args)
    nvim.command("echo \"#{send(code)}\"")
  end

  plug.command(:Methods, :nargs => 0) do |nvim, args|
    nvim.current.line = "methods: #{nvim.methods}"
    # nvim.current.line = "methods: #{nvim.get_current_buffer.methods}"
  end

  plug.command(:TT, :nargs => '?') do |nvim, args|
    nvim.current.line = "response: #{test_send}"
  end
end
