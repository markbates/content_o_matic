module ContentOMatic
  
  class << self
    
    # Returns the logger being used by ContentOMatic.
    # The logger can be set with the following configatron setting:
    #   configatron.content_o_matic.logger = ::Logger.new(STDOUT)
    # 
    # In a Rails environment this defaults to the <tt>RAILS_DEFAULT_LOGGER</tt>.
    # The non-Rails default is:
    #   <pwd>/log/content_o_matic.log
    def logger
      configatron.content_o_matic.logger
    end
    
    # This method does pretty much all of the heavy work. You pass it a url
    # and it will fetch the contents of that page and return a ContentOMatic::Response
    # object to you.
    # 
    # If you pass in a 'relative' url it will be joined with a default url that can be
    # set with the following configatron setting:
    #   configatron.content_o_matic.url = 'http://www.example.com'
    # 
    # url examples:
    #   'foo.html' => 'http://www.example.com/foo.html'
    #   '/foo.html' => 'http://www.example.com/foo.html'
    #   '/foo/bar.html' => 'http://www.example.com/foo/bar.html'
    #   'http://www.example.com/index.html' => 'http://www.example.com/index.html'
    # 
    # Any options passed into will become query string parameters passed to the 
    # requested url.
    # 
    # If you have caching enabled it will look first in the cache, if it doesn't find
    # it there, it will do a fetch of the page and store it in the cache, if it was successful.
    # See ContentOMatic::ContentCache for more details on caching.
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
    
    def get_without_cache(slug_url, options = {}) # :nodoc:
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
    
    def url_from_slug(slug_url, options = {}) # :nodoc:
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
