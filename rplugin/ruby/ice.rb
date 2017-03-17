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
    # parse_command_arguments => collect_payload/code
    # nvim.current.line = "args: #{args}"
    # All from line 1
    # '<,'>Eval on single line == arg1: 1, arg2: 1
    # Eval (def hello 345) == arg1: (def hello 345), arg2: 1
    # .,.+1Eval == arg1: 1, arg2: 2

    code = parse_command_arguments(nvim, arg1, arg2)
    nvim.command("echo \"#{code}\"")
    # nvim.current.line = "code: #{options}"

    # nvim.current.line = "arg1: #{arg1}, arg2: #{arg2}"

    # if args.nil?
    #   nvim.command("echo \"#{test_send}\"")
    # else
    #   # XXX doesn't work the first time if there is a space in args?!?
    #   nvim.command("echo \"#{send(args)}\"")
    # end
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
