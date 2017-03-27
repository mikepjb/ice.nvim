require 'neovim'
require_relative 'nrepl_client'
require_relative 'message'

include NreplClient
include Message

module NeovimClient
  class Neovim::Client
    def echo(message)
      command("echom \"#{message}\"")
    end
  end

  def self.parse_command_arguments(nvim, args) # unit test this
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

  # XXX unit test this, generalise with eval code
  # XXX also make sure error is surfaced to neovim if filename not found
  def self.require(nvim, log=[])
    filename = nvim.get_current_buffer.name
    send("(load-file \"#{filename}\")", log, nvim)

    catch (:complete) do
      log.reverse.each do |x|
        if x.has_key?('value')
          if !x['value'].empty?
            nvim.echo(x['value'].gsub('"', '\"'))
            throw :complete
          end
        end
      end
    end
  end

  def self.eval(nvim, args, log=[])
    code = parse_command_arguments(nvim, args)
    filename = nvim.get_current_buffer.name
    code_with_ns = Message::prefix_namespace(filename, code)
    send(code_with_ns, log, nvim)

    catch (:complete) do
      log.reverse.each do |x|
        if x.has_key?('value')
          if !x['value'].empty?
            nvim.echo(x['value'].gsub('"', '\"'))
            throw :complete
          end
        end
      end
    end
  end
end
