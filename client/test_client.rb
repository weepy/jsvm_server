require "client"

def send js, env
#  d = Time.now
  response = JSS::Client::send_command :env => env, :context => nil, :cmd => "evaluate", :js => js
  #puts response.inspect
#  puts (Time.now - d)*1000
end