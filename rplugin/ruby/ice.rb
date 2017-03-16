require_relative '../../lib/nrepl_client'

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
    decoded = test_send
    nvim.current.line = "response: #{decoded}"
    # nvim.message("response: #{decoded}")
    # nvim.current.line = (nvim.methods - Object.methods).to_s
  end
end
