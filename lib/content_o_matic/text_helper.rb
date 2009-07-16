module ActionView
  module Helpers
    module TextHelper
      
      def content_o_matic(slug, options = {})
        text = "<!-- Loading Content: '#{slug}' -->\n"
        begin
          html_body = true
          if options.has_key?(:html_body)
            html_body = options.delete(:html_body)
          end
          res = ContentOMatic.get(slug, options)
          if res.success?
            if html_body
              text << res.html_body
            else
              text << res.body
            end
          else
            raise res.exception
          end
        rescue Exception => e
          text << "<!-- Error: #{e.message} -->"
        end
        text << "\n<!-- Loaded Content: '#{slug}' -->"
        text
      end
      
    end
  end
end