require 'socket'
require 'neovim'
require_relative 'bencode'

module NreplClient
  class Neovim::Client
    def echo(message)
      command("echom \"#{message}\"")
    end
  end

  def session(socket, log=[])
    socket.sendmsg 'd2:op5:clonee'
    response = socket.recvmsg.first
    decoded = Bencode::decode(response)
    log << decoded
    decoded["new-session"]
  end

  def message(id, session, code)
    "d4:code#{code.length}:#{code}"\
    "2:id#{id.length}:#{id}"\
    "2:op4:eval7:session#{session.length}:#{session}e"
  end

  def send(code, log=[], nvim=:none)
    include Bencode
    begin
      socket = TCPSocket.open('127.0.0.1', 9999)
      socket.sendmsg message('ice', session(socket, log), code)
    rescue Errno::ECONNREFUSED
      nvim.echo("There is no nREPL to connect to on port 9999")
    end

    catch (:complete) do
      while true
        message = socket.recvmsg.first
        decode_all(message).each do |dict|
          log << dict
          throw :complete if dict['status'] == 'done'
        end
      end
    end
  end

  def run_tests(log=[])
    send("(clojure.test/run-tests)", log)
  end
end
