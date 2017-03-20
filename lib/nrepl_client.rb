require 'socket'
require_relative 'bencode'

# XXX try catch when the connection is refused (repl is not running)
# XXX should not send test-id, try using something else like test-running etc
# XXX !!! recvmsg only works for the first message - run_tests for example has multiple
# XXX when Eval'ing a (def x ...) - nil is returned to the prompt, return something more useful

def send(code, log=[])
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code#{code.length}:#{code}2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  # socket # XXX uncomment for test.rb

  # XXX log no longer prints after eval call
  # something is fucking up here...
  while true
    begin
      next_message = socket.recvmsg_nonblock
      if !next_message.first.nil?
        decoded_result = decode(next_message.first)
        log << decoded_result
        # puts decoded_result
      end
    rescue IO::EAGAINWaitReadable
    end
  end

  # raise "#{socket.methods - Object.methods}"
  # XXX here we should load messages into a list to retrieve later
  # response = socket.recvmsg.first
  # log << response
  # decoded = Bencode::decode(response)
  # while response = Bencode::decode(socket.recvmsg.first)
  # while response = socket.recvmsg
  #   log << response
  # end
  # if decoded.has_key?("value")
  #   decoded["value"].gsub('"', '\"')
  # else
  #   decoded.to_s.gsub('"', '\"')
  # end
end

# XXX doesn't pick up tests

def run_tests
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code24:(clojure.test/run-tests)2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  socket.recvmsg # Run the first time, ignore the 'started' message
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  decoded["out"].to_s.gsub('"', '\"')
end
