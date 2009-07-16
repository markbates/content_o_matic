module ContentOMatic
    
  class Response
    
    attr_accessor :status
    attr_accessor :body
    attr_accessor :url
    attr_accessor :hpricot_doc
    
    def initialize(url, status, body = '')
      self.url = url
      self.status = status.to_i
      self.body = body
      if success?
        self.hpricot_doc = Hpricot(self.body)
      end
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
    
    def html_body
      unless @__doc_body
        @__doc_body = self.hpricot_doc.at('body')
        @__doc_body = @__doc_body.nil? ? self.body : @__doc_body.inner_html
      end
      return @__doc_body
    end
    
    def exception
      ContentOMatic::InvalidResponseError.new("URL: '#{self.url}' did not return a valid response! Status: '#{self.status}' Body: '#{self.body}'") unless self.success?
    end
    
  end # Response

end # ContentOMatic