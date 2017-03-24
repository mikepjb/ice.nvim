require_relative '../../lib/nrepl_client'
require_relative '../../lib/message'

#--------------------------------------------------
# XXX Next sprint
# We are in a current state where
#   - evaluating code is always done in the namespace of the current file
#     - event when using :Eval (def inline-function 123)
#   - Also when successfully evaluating the message returned has a value of nil
#     - We want e.g #boot.user/inline-function
#   - We also want to carry a log of all previous messages in the session
#   - :Require should use the load-file op - or maybe eval (load-file "currentfile")
#
#   The most important thing to address is the messaging returning nil for a successful eval
#   until we get a status node that has says ['done'] we should keep blocking?
#   XXX I think this is a good approach, we are currently getting an error
#   that seems to be caused by an improper decoding of bencode
#--------------------------------------------------

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

class Neovim::Client
  def echo(message)
    command("echom \"#{message}\"")
  end
end

@received_messages = []

Neovim.plugin do |plug|
  # XXX E116: Invalid arguments for function remote#define#CommandBootstrap where quotes are used "
  # XXX note that this error does not occur after the first Eval without " occurs, then including " is fine?!?
  # XXX Also note that this error ONLY occurs when passed in to Eval as 
  plug.command(:Eval, :nargs => '?', :range => true) do |nvim, *args|
    include Message
    code = parse_command_arguments(nvim, args)
    filename = nvim.get_current_buffer.name
    code_with_ns = prefix_namespace(filename, code)
    # nvim.echo(send(code_with_ns, @received_messages))
    send(code_with_ns, @received_messages, nvim)
    catch (:complete) do
      @received_messages.reverse.each do |x|
        if x.has_key?('value')
          if !x['value'].empty?
            nvim.echo(x['value'].gsub('"', '\"'))
            throw :complete
          end
        end
      end
    end
  end

  plug.command(:RunTests, :nargs => 0) do |nvim, args|
    nvim.echo(run_tests)
  end

  plug.command(:Log, :nargs => 0) do |nvim, args|
    # raise "#{@received_messages}"
    nvim.current.line = "logs: #{@received_messages}"
  end

  # XXX command :StackTrace - show the last stacktrace in @received_messages

  plug.command(:Methods, :nargs => 0) do |nvim, args|
    # nvim.current.line = "methods: #{nvim.methods}"
    nvim.current.line = "methods: #{nvim.get_current_buffer.methods}"
  end
end
