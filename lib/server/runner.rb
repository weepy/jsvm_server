module JSS
  class Runner
    
    def initialize  
      start
    end
      
    def start
      puts "Starting JSS Server"
      
      trap("INT") {
        stop
        exit
      }
      trap("TERM"){
        stop
        exit
      }
      
      EM::run {
        EM::start_server(CONFIG[:host], CONFIG[:port], JSS::Server)
        # EM.set_effective_user( options[:user] ) if options[:user]
      }
    end

    def stop
      puts "Stopping JS server"
      #TODO kill all JS VMs
      EventMachine::stop
    end
    
  end
end