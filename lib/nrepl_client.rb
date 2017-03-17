require 'socket'
require_relative 'bencode'

# XXX try catch when the connection is refused (repl is not running)
# XXX should not send test-id, try using something else like test-running etc
# XXX recvmsg only works for the first message - run_tests for example has multiple
# XXX when Eval'ing a (def x ...) - nil is returned to the prompt, return something more useful

def test_send
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code15:(def devil 777)2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  decoded["value"].gsub('"', '\"')
end

def send(code)
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code#{code.length}:#{code}2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  response = socket.recvmsg.first
  decoded = Bencode::decode(response)
  if decoded.has_key?("value")
    decoded["value"].gsub('"', '\"')
  else
    decoded.to_s.gsub('"', '\"')
  end
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
