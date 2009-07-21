module ContentOMatic
    
  class Response
    
    attr_accessor :status
    attr_accessor :body
    attr_accessor :url
    
    def initialize(url, status, body = '')
      self.url = url
      self.status = status.to_i
      self.body = body
    end
    
    def success?
      self.status == 200
    end
    
    def to_s
      self.success? ? self.body : ''
    end
    
    def to_str
      self.to_s
    end
    
    def has_layout?
      return self.body != self.html_body
    end
    
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
    
    def html_body(normalize_assets = false)
      unless @__doc_body
        doc = Nokogiri::HTML(self.body(normalize_assets))
        @__doc_body = doc.at('body')
        @__doc_body = @__doc_body.nil? ? self.body(normalize_assets) : @__doc_body.inner_html
      end
      return @__doc_body
    end
    
    def exception
      ContentOMatic::InvalidResponseError.new("URL: '#{self.url}' did not return a valid response! Status: '#{self.status}' Body: '#{self.body}'") unless self.success?
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