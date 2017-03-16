require 'socket'

socket = TCPSocket.open('127.0.0.1', 9999)

def decode_message(response) # XXX Mike: unit test this
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

Neovim.plugin do |plug|
  # Define a command called "SetLine" which sets the contents of the current
  # line. This command is executed asynchronously, return value ignored.
  plug.command(:SetLine, :nargs => 1) do |nvim, str|
    nvim.current.line = str
  end

  plug.command(:TestSend, :nargs => 0) do |nvim, str|
    # socket.sendmsg 'd4:code11:(def s 345)2:id7:test-id2:op4:eval7:session7:test-ide'
    socket.sendmsg 'd2:op5:clonee'
    response = socket.recvmsg.first
    nvim.current.line = "response : #{socket.recvmsg}"
  end

  plug.command(:TT, :nargs => 0) do |nvim, str|
    socket.sendmsg 'd2:op5:clonee'
    response = socket.recvmsg.first
    decoded = decode_message(response)
    session = decoded["new-session"]
    session_length = decoded["new-session"].length
    socket.sendmsg "d4:code15:(def devil 666)2:id7:test-id2:op4:eval7:session#{session_length}:#{session}e"
    response = socket.recvmsg.first
    decoded = decode_message(response)
    nvim.current.line("response: #{decoded}")
  end
end
