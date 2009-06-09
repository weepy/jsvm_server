module JSS
  
  class Server < EventMachine::Connection
    
    @@VMs = {}
    CR = "\0"

    def initialize
      @buffer = ''
      JSS::logger.info "STARTING SERVER"
    end
    
    def receive_data(data)
      @buffer << data
      @buffer = process_whole_messages(@buffer)
    end
  
    # process any whole messages in the buffer,
    # and return the new contents of the buffer
    def process_whole_messages(data)
      
      return data if data !~ /\0/ # only process if data contains a \0 char
     
      messages = data.split("\0")
      if data =~ /\0$/
        data = ''
      else
        # remove the last message from the list (because it is incomplete) before processing
        data = messages.pop
      end
      messages.each {|message| process_message(message.strip)}
      return data
    end
  
    # destroy_env_command, shutdown_command
    def process_message message
      ret = nil
      success = nil
      
      begin    
        msg = ActiveSupport::JSON.decode(message)
        
        msg.symbolize_keys!
        raise "bad auth" unless msg[:secret] == CONFIG[:secret]
        result = self.method(msg[:cmd] + "_command").call(msg)
        ret = { :result => result }
      rescue Exception => e
        JSS.logger.info e.backtrace
        ret = { :error => e.to_s.slice(0,100), :error_type => e.class.to_s }
      end

      send_data ret.to_json + CR
    end
  
    def evaluate_command msg
      vm = get_VM(msg)
      vm.evaluate msg[:js]
    end


    protected
  
    def get_VM(msg)
      return @@VMs[msg[:env]] if @@VMs[msg[:env]]
      create_VM msg[:env], msg[:context]
    end
  
    def create_VM key, context
      @@VMs[key] = VM.new key, context 
    end
   
   
  end

end



