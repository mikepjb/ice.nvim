require 'neovim'

module NeovimClient
  class Neovim::Client
    def echo(message)
      command("echom \"#{message}\"")
    end
  end

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
end
