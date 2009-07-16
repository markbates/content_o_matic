Dir.glob(File.join(File.dirname(__FILE__), 'content_o_matic', '**/*.rb')).each do |f|
  require File.expand_path(f)
end
