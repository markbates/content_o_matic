module ContentOMatic
  # This class wraps the response received from pulling down content from a web page.
  class Response
    
    # The status of the response
    attr_accessor :status
    # The full body of the response
    attr_accessor :body
    # The url of the requested page
    attr_accessor :url
    
    # Takes the url of the requested page, the status code of the
    # response, and the body of the response.
    def initialize(url, status, body = '')
      self.url = url
      self.status = status.to_i
      self.body = body
    end
    
    # Returns <tt>true</tt> if the status of the page was 200
    def success?
      self.status == 200
    end
    
    def to_s # :nodoc:
      self.success? ? self.body : ''
    end
    
    def to_str # :nodoc:
      self.to_s
    end
    
    # Returns <tt>true</tt> if the page is wrapped in <tt>html</tt> tags.
    def has_layout?
      return self.body != self.html_body
    end
    
    # Returns the 'full' HTML body of the requested page.
    # If you pass in <tt>true</tt> it will normalize all the links
    # found in the body.
    # 
    # Example:
    #   # http://www.example.com/foo/bar.html
    #   <img src='image.jpg'> # => <img src='http://www.example.com/foo/image.jpg'>
    #   <img src='/image.jpg'> # => <img src='http://www.example.com/image.jpg'>
    #   <img src='http://www.example.org/image.jpg'> # => <img src='http://www.example.org/image.jpg'>
    # 
    # The following tags get 'normalized' with the <tt>true</tt> parameter:
    #   img
    #   script
    #   link
    #   a
    #   iframe
    #   form
    #   object
    def body(normalize_assets = false)
      if normalize_assets
        unless @__normalized_body
          @__normalized_body = @body.dup
          doc = Nokogiri::HTML(@__normalized_body)
          {'img' => 'src', 'script' => 'src', 
            'link' => 'href', 'a' => 'href',
            'iframe' => 'src', 'form' => 'action',
            'object' => 'data'}.each do |key, attrib|
            (doc/key).each do |elem|
              o_link = elem[attrib]
              next if o_link.blank?
              elem[attrib] = normalize_asset_url(o_link)
             end
          end
          @__normalized_body = doc.to_s
        end
        return @__normalized_body
      end
      @body
    end
    
    # Returns just the content within the HTML 'body' tag.
    # If there is no 'body' tag, then the whole response body is returned.
    # If you pass in <tt>true</tt> it will normalize all the links
    # found in the body. See the body method for more details.
    def html_body(normalize_assets = false)
      unless @__doc_body
        doc = Nokogiri::HTML(self.body(normalize_assets))
        @__doc_body = doc.at('body')
        @__doc_body = @__doc_body.nil? ? self.body(normalize_assets) : @__doc_body.inner_html
      end
      return @__doc_body
    end
    
    # Returns a ContentOMatic::InvalidResponseError exception if the
    # response was not a success.
    def exception
      ContentOMatic::InvalidResponseError.new("URL: '#{self.url}' did not return a valid response! Status: '#{self.status}'") unless self.success?
    end
    
    private
    def normalize_asset_url(src)
      unless src.match(/^([a-zA-Z]+):\/\//)
        relative = !src.match(/^\//)
        if relative
          # find the outer most url
          # http://www.example.com/foo/index.html => http://www.example.com/foo
          base =  File.dirname(self.url)
        else
          # absolute so find the inner most url
          # http://www.example.com/index.html => http://www.example.com
          base =  self.url.scan(/([a-zA-Z]+:\/\/[^\/]+)/).first
        end
        # bad: <img src="http://www.example.com/full_page.html/image2.jpg" />
        n_src = File.join(base, src)
        return n_src
      end
      return src
    end
    
  end # Response

end # ContentOMatic