require 'socket'
require_relative 'bencode'

def test_clone
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  socket.recvmsg.first
end

def test_send
  include Bencode
  socket = TCPSocket.open('127.0.0.1', 9999)
  socket.sendmsg 'd2:op5:clonee'
  response = socket.recvmsg.first
  decoded = Bencode::decode_message(response)
  session = decoded["new-session"]
  session_length = decoded["new-session"].length
  socket.sendmsg "d4:code15:(def devil 777)2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
  response = socket.recvmsg.first
  decoded = Bencode::decode_message(response)
  decoded
end
