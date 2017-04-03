require 'neovim'
require 'tempfile'
require_relative 'nrepl_client'
require_relative 'message'

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


  def self.clean_error(message)
    message.gsub('"', '\"').
      gsub(/\033\[(([0-9]?)\;?)+m/, '').
      strip.
      split("\n").
      first
  end

  def self.output_response(nvim, log=[])
    catch (:complete) do
      log.reverse.each do |x|
        if x.has_key?('value')
          nvim.echo(x['value'].gsub('"', '\"'))
          throw :complete
        elsif x.has_key?('out')
          # XXX would be nice to use echoerr
          nvim.echo(clean_error(x['out']))
          throw :complete
        end
      end
    end
  end

  # XXX unit test this
  def self.require(nvim, log=[])
    filename = nvim.get_current_buffer.name
    NreplClient::send("(load-file \"#{filename}\")", log, nvim)
    output_response(nvim, log)
  end

  def self.eval(nvim, args, log=[])
    code = parse_command_arguments(nvim, args)
    filename = nvim.get_current_buffer.name
    code_with_ns = Message::prefix_namespace(filename, code)
    NreplClient::send(code_with_ns, log, nvim)
    output_response(nvim, log)
  end

  # XXX tmp file should not stay on vim buffer list (like Gblame etc)
  def self.log(nvim, log=[])
    log_view = Tempfile.new('log_view')
    log.each do |line|
      log_view << "#{line}\n"
    end
    log_view.flush
    nvim.command("below 15 split #{log_view.path}")
    log_view.close
  end
end
