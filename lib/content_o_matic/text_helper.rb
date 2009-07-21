module ActionView
  module Helpers
    module TextHelper
      
      def content_o_matic(slug, options = {})
        options = {} if options.nil?
        comments = true
        if options.has_key?(:print_comments)
          comments = options.delete(:print_comments)
        end
        html_body = true
        if options.has_key?(:html_body)
          html_body = options.delete(:html_body)
        end
        normalize_assets = true
        if options.has_key?(:normalize_assets)
          normalize_assets = options.delete(:normalize_assets)
        end
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