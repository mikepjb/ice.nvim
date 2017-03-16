require 'socket'

socket = TCPSocket.open('127.0.0.1', 9999)

Neovim.plugin do |plug|
  # Define a command called "SetLine" which sets the contents of the current
  # line. This command is executed asynchronously, return value ignored.
  plug.command(:SetLine, :nargs => 1) do |nvim, str|
    nvim.current.line = str
  end

  plug.command(:TestSend, :nargs => 0) do |nvim, str|
    # socket.sendmsg 'd4:code11:(def s 345)2:id7:test-id2:op4:eval7:session7:test-ide'
    socket.sendmsg 'd2:op5:clonee'
    nvim.current.line = "response : #{socket.recvmsg}"
  end

  plug.command(:TT, :nargs => 0) do |nvim, str|
    socket.sendmsg 'd4:code11:(def s 345)2:id7:test-id2:op4:eval7:session7:test-ide'
    nvim.current.line = "response : #{socket.recvmsg.first}"
  end
end
