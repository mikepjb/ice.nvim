require 'socket'

socket = TCPSocket.open('127.0.0.1', 9999)

socket.sendmsg 'd2:op5:clonee'
# socket.methods - Object.methods
response = socket.recvmsg.first

def decode_message(response)
  next_length = nil
  response_array = []

  response[1..-2].split(':').each do |message_part|
    if next_length.nil?
      next_length = message_part.to_i
    else
      payload = message_part[0..(next_length - 1)]
      response_array << payload
      next_meta = message_part[next_length..-1]
      if next_meta =~ /^[0-9].*/
        next_length = next_meta.to_i
      else
        next_length = next_meta[1..-1].to_i
      end
    end
  end
  Hash[*response_array]
end

decoded = decode_message(response)

puts decoded

session = decoded["new-session"]
session_length = decoded["new-session"].length

socket.sendmsg "d4:code11:(def s 666)2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"

response = socket.recvmsg.first
decoded = decode_message(response)
