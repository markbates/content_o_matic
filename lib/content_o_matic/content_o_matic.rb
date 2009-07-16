module ContentOMatic
  
  class << self
    
    def logger
      configatron.content_o_matic.logger
    end
    
    def get(slug_url, options = {})
      url = slug_url
      begin
        if !slug_url.match(/^([a-zA-Z]+):\/\//)
          # it's not a 'remote' url - it has no protocol
          url = File.join(configatron.content_o_matic.url, slug_url)
          if options.is_a? Hash
            opts = options.dup 
            unless opts.nil? && opts.empty?
              opts.delete(:controller)
              opts.delete(:action)
              opts.delete(:slug)
              if url.match(/\?/)
                url << '&'
              else
                url << '?'
              end
              url << opts.collect {|k,v| "#{URI.escape(k.to_s)}=#{URI.escape(v.to_s)}"}.join("&")
            end
          end
        end
        Timeout::timeout(configatron.content_o_matic.response.time_out) do
          response = Net::HTTP.get_response(URI.parse(url))
          return ContentOMatic::Response.new(url, response.code, response.body)
        end
      rescue Exception => e
        ContentOMatic.logger.error(e)
        return ContentOMatic::Response.new(url, '500', e.message)
      end
      
    end
    
  end
  
end
