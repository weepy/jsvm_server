
module JSS
  
  class << self
    def logger
      return @@logger if defined?(@@logger) && !@@logger.nil?
      FileUtils.mkdir_p(File.dirname(CONFIG[:log_path]))
      @@logger = Logger.new(CONFIG[:log_path])
      @@logger.level = Logger::INFO if options[:debug] == false
      @@logger
    rescue
      @@logger = Logger.new(STDOUT)
    end

  end
end
