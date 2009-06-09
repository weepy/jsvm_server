require "socket"
require "json"
$:.unshift(File.dirname(__FILE__))
require "config"

module JSS
  class Client
    CR = "\0"
  
    #"#{RAILS_ROOT}/config/javascript_server.rb"
  
    def self.send_command(hash, respond = true)
    
      socket = nil
      response = nil

      begin
        hash[:secret] = CONFIG[:secret] if CONFIG[:secret]

        string = hash.to_json + CR
        #puts "sending #{string.length} bytes: #{string}"
           
        socket = TCPSocket.new CONFIG[:host], CONFIG[:port]
        socket.print(string)
        socket.flush
        if respond
          txt = socket.readline(CR)
          response = JSON.parse(txt.chomp!(CR))
        end
      
      ensure
        socket.close if socket and !socket.closed?
      end
    
      response if respond
    end
  
  end

end