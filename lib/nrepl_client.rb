require 'socket'
require_relative 'bencode'

module NreplClient
  def self.session(socket, log=[])
    socket.sendmsg 'd2:op5:clonee'
    response = socket.recvmsg.first
    decoded = Bencode::decode(response)
    log << decoded
    decoded["new-session"]
  end

  def self.message(id, session, code)
    "d4:code#{code.length}:#{code}"\
    "2:id#{id.length}:#{id}"\
    "2:op4:eval7:session#{session.length}:#{session}e"
  end

  def self.send(code, log=[], nvim=:none)
    begin
      socket = TCPSocket.open('127.0.0.1', 9999)
      socket.sendmsg message('ice', session(socket, log), code)
    rescue Errno::ECONNREFUSED
      nvim.echo("There is no nREPL to connect to on port 9999")
    end

    catch (:complete) do
      while true
        message = socket.recvmsg.first
        Bencode::decode_all(message).each do |dict|
          log << dict
          throw :complete if dict['status'] == 'done'
        end
      end
    end
  end

  def self.run_tests(log=[])
    send("(clojure.test/run-tests)", log)
  end
end
