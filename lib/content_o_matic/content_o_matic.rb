module ContentOMatic
  
  class << self
    
    def logger
      configatron.content_o_matic.logger
    end
    
    def get(slug_url, options = {})
      if configatron.content_o_matic.retrieve(:cache_results, false)
        url = url_from_slug(slug_url, options)
        ContentCache.get(url) do |url|
          content = get_without_cache(slug_url, options)
          if content.success?
            ContentCache.set(url, content)
          end
          return content
        end
      else
        return get_without_cache(slug_url, options)
      end
    end
    
    def get_without_cache(slug_url, options = {})
      url = url_from_slug(slug_url, options)
      begin
        Timeout::timeout(configatron.content_o_matic.response.time_out) do
          response = Net::HTTP.get_response(URI.parse(url))
          return ContentOMatic::Response.new(url, response.code, response.body)
        end
      rescue Exception => e
        ContentOMatic.logger.error(e)
        return ContentOMatic::Response.new(url, '500', e.message)
      end
    end # get_without_cache
    
    def url_from_slug(slug_url, options = {})
      return slug_url if slug_url.nil?
      url = slug_url
      if !slug_url.match(/^([a-zA-Z]+):\/\//)
        # it's not a 'remote' url - it has no protocol
        url = File.join(configatron.content_o_matic.url, slug_url)
      end
      if options.is_a? Hash
        opts = options.dup 
        unless opts.nil? || opts.empty?
          opts.delete(:controller)
          opts.delete(:action)
          if url.match(/\?/)
            url << '&'
          else
            url << '?'
          end
          url << opts.collect {|k,v| "#{URI.escape(k.to_s)}=#{URI.escape(v.to_s)}"}.join("&")
        end
      end
      return url
    end
    
  end # class << self
  
end # ContentOMatic
