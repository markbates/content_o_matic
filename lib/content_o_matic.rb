require 'nokogiri'
require 'configatron'
require 'cachetastic'
require 'logger'

configatron.content_o_matic.set_default(:url, 'http://www.example.com')
configatron.content_o_matic.response.set_default(:time_out, 30)
configatron.content_o_matic.set_default(:cache_results, false)

if defined?(RAILS_DEFAULT_LOGGER)
  configatron.content_o_matic.set_default(:logger, RAILS_DEFAULT_LOGGER)
else
  path = File.join(FileUtils.pwd, 'log')
  FileUtils.mkdir_p(path)
  configatron.content_o_matic.set_default(:logger, ::Logger.new(File.join(path, 'content_o_matic.log')))
end

Dir.glob(File.join(File.dirname(__FILE__), 'content_o_matic', '**/*.rb')).each do |f|
  require File.expand_path(f)
end
