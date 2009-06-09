module Johnson 
  module SpiderMonkey 
    class RubyLandProxy
      def to_json(arg=nil)
        RubyLandProxy.to_json(self)
      end
      
      def RubyLandProxy.to_jsonable_object proxy
        ret = nil
        if proxy.to_s == "[object Object]"
          ret = {}
          proxy.each do |k,v|
            ret[k] = (v.class == RubyLandProxy) ? RubyLandProxy.to_jsonable_object(v) : v
          end
          
        else
          ret = []
          i = 0
          proxy.each do |v|
            ret[i] = (v.class == RubyLandProxy) ? RubyLandProxy.to_jsonable_object(v) : v
            i += 1
          end
        end
        ret
      end
      
      def RubyLandProxy.to_json proxy
         RubyLandProxy.to_jsonable_object(proxy).to_json
      end
    end
  end
end