module ActionView # :nodoc:
  module Helpers # :nodoc:
    module TextHelper
      
      # This convenience method automatically plugs into Rails views, however,
      # this module could easily be included in a non-Rails environment.
      # 
      # This method wraps the ContentOMatic.get method with some nice HTML
      # comments to let you know what has been loaded. It also normalizes
      # links in that content by default. See ContentOMatic::Response body for more
      # information on normalizing links.
      # 
      # This method will also, by default, return just the contents of the HTML
      # 'body' tag.
      def content_o_matic(slug, options = {})
        options = {} if options.nil?
        options = {:print_comments => true, :html_body => true, :normalize_assets => true}.merge(options)
        comments = options.delete(:print_comments)
        html_body = options.delete(:html_body)
        normalize_assets = options.delete(:normalize_assets)
        text = "<!-- Loading Content: '#{slug}' -->\n" if comments
        begin
          res = ContentOMatic.get(slug, options)
          if res.success?
            if html_body
              text << res.html_body(normalize_assets)
            else
              text << res.body(normalize_assets)
            end
          else
            raise res.exception
          end
        rescue Exception => e
          text << "<!-- Error: #{e.message} -->" if comments
        end
        text << "\n<!-- Loaded Content: '#{slug}' -->" if comments
        text
      end
      
    end
  end
end