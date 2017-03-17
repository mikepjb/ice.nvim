require_relative '../../lib/nrepl_client'

def parse_command_arguments(nvim, arg1, arg2)
  code_to_evaluate = []
  if arg1.to_i == 0
    code_to_evaluate << arg1
  else
    (arg1.to_i..arg2.to_i).each do |line_number|
      code_to_evaluate << nvim.get_current_buffer.get_line(line_number - 1)
    end
  end
  code_to_evaluate.join("\n")
end

Neovim.plugin do |plug|
  # XXX E116: Invalid arguments for function remote#define#CommandBootstrap where quotes are used "
  # XXX note that this error does not occur after the first Eval without " occurs, then including " is fine?!?
  # plug.command(:Eval, :nargs => '?') do |nvim, args|
  # XXX can you collect all args like &args or similar?
  plug.command(:Eval, :nargs => '?', :range => true) do |nvim, arg1, arg2|
    code = parse_command_arguments(nvim, arg1, arg2)
    nvim.command("echo \"#{send(code)}\"")
  end

  plug.command(:Methods, :nargs => 0) do |nvim, args|
    # nvim.current.line = "methods: #{nvim.methods}"
    nvim.current.line = "methods: #{nvim.get_current_buffer.methods}"
  end

  plug.command(:GetLine, :nargs => 0) do |nvim, args|
    # nvim.current.line = "methods: #{nvim.methods}"
    nvim.current.line = "line: #{nvim.get_current_buffer.get_line(1)}"
  end

  plug.command(:Str, :nargs => '?') do |nvim, args|
    nvim.command "echo \"#{args}\""
  end

  plug.command(:TT, :nargs => '?') do |nvim, args|
    nvim.current.line = "response: #{test_send}"
  end
end
