require 'rubygems'
require 'spec'
require 'fakeweb'

require File.join(File.dirname(__FILE__), '..', 'lib', 'content_o_matic')

Spec::Runner.configure do |config|
  
  config.before(:all) do
    
  end
  
  config.after(:all) do
    
  end
  
  config.before(:each) do
    @full_page_response = ContentOMatic::Response.new('http://www.example.com/full_page.html',
                                                      '200',
                                                      fixture_value('full_page.html'))

    @body_only_response = ContentOMatic::Response.new('http://www.example.com/body_only.html',
                                                      '200',
                                                      fixture_value('body_only.html'))
    @failure_response = ContentOMatic::Response.new('http://www.example.com/oops.html', '404', 'Page Not Found')
  end
  
  config.after(:each) do
    
  end
  
end

def fixture_path(*name)
  return File.join(File.dirname(__FILE__), 'fixtures', *name)
end

def fixture_value(*name)
  return File.read(fixture_path(*name))
end

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, 'http://www.example.com/full_page.html', :body => fixture_value('full_page.html'))
FakeWeb.register_uri(:get, 'http://www.example.com/full_page.html?foo=bar', :body => fixture_value('full_page.html'))
FakeWeb.register_uri(:get, 'http://www.example.com/full_page.html?one=1', :body => fixture_value('full_page.html'))
FakeWeb.register_uri(:get, 'http://www.example.com/full_page.html?one=1&foo=bar', :body => fixture_value('full_page.html'))
FakeWeb.register_uri(:get, 'http://www.example.com/body_only.html', :body => fixture_value('body_only.html'))
FakeWeb.register_uri(:get, "http://www.example.com/oops.html", :body => "Nothing to be found 'round here", :status => ["404", "Not Found"])
