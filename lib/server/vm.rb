


#TODO - add in MUTEX's to make it thread safe

module JSS
  
  class VM

    def initialize name, context
      @name = name
      @johnson = Johnson::Runtime.new
      @mutex = nil
      evaluate(File.read(context)) if context
    end

    def evaluate(js)
      ret = nil
      now = Time.now

      logger.info "Evaluating: #{js.slice(0,160)} "

      begin
        ret = @johnson.evaluate(js)
      rescue Exception => e
        logger.info "   Caught exception: #{e.inspect}"
        raise e #reraise 
      end

      logger.info "   returned: #{ret.to_json}"
      logger.info "   took #{(Time.now - now)*1000}ms"

      ret
    end

    def logger
      JSS.logger
    end

  end
end