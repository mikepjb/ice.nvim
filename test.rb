require 'socket'
require_relative 'lib/bencode'
require_relative 'lib/nrepl_client'

include Bencode

clojure_namespaced_method =
  "(ns watermarker.core)"\
  "\n"\
  "(defn this-method [x]"\
  "   (+ 37 77 x))"


failing_method =
  "(ns watermarker.core)"\
  "\n"\
  "(defn stream-file"\
  "\"Takes an s3 url an creates an input stream for it's content\""\
  "[s3Url]"\
  "(io/input-stream (io/as-url s3Url)))"

socket = send(failing_method)
# socket = send(clojure_namespaced_method)

log = []

# while next_message = socket.recvmsg_nonblock
# while true
#   next_message = socket.recvmsg_nonblock
#   @messages << decode(next_message.first)
#   puts @messages
#   # puts @messages
# end

# XXX working code but not good for the project
# puts "first"
# puts decode(socket.recvmsg.first)
# puts "second"
# second_message = socket.recvmsg # msg.first
# puts second_message
# puts decode(second_message.first)

puts socket.class

catch (:complete) do
  while true
    message = socket.recvmsg.first
    # XXX probs [] for nil is in decoding...
    raw(message).each do |mess|
      p mess.to_s
      throw :complete if mess.to_s.include?('done')
    end
    # decode_all(message).each do |dict|
    #   log << dict
    #   throw :complete if dict['status'] == 'done'
    # end
  end
end

puts log
