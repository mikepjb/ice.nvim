require 'socket'
require_relative 'lib/bencode'
require_relative 'lib/nrepl_client'

include Bencode

clojure_namespaced_method =
  "(ns watermarker.core)"\
  "\n"\
  "(defn this-method [x]"\
  "   (+ 37 77 x))"\

socket = send(clojure_namespaced_method)

@messages = []

# while next_message = socket.recvmsg_nonblock
while true
  begin
    next_message = socket.recvmsg_nonblock
    @messages << decode(next_message.first)
  rescue
  end
  # puts @messages
end

# puts "first"
# puts decode(socket.recvmsg.first)
# puts "second"
# second_message = socket.recv # msg.first
# puts second_message
# puts decode(socket.recvmsg.first)

# puts socket.methods - Object.methods
