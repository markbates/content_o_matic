require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe ContentOMatic do
  
  describe 'get' do
    
    it 'should return a ContentOMatic::Response object' do
      resp = ContentOMatic.get('http://www.example.com/full_page.html')
      resp.status.should == 200
      resp.should_not be_nil
      resp.should be_kind_of(ContentOMatic::Response)
    end
    
    it 'should recognize a full url' do
      resp = ContentOMatic.get('http://www.example.com/full_page.html')
      resp.should_not be_nil
      resp.should be_success
      resp.body.should == fixture_value('full_page.html')
    end
    
    it 'should recognize just a slug url' do
      resp = ContentOMatic.get('full_page.html')
      resp.should_not be_nil
      resp.should be_success
      resp.body.should == fixture_value('full_page.html')
    end
    
    it 'should append Hash options as query string parameters' do
      resp = ContentOMatic.get('full_page.html', :foo => :bar)
      resp.should_not be_nil
      resp.should be_success
      resp.url.should == 'http://www.example.com/full_page.html?foo=bar'
      
      resp = ContentOMatic.get('full_page.html?one=1', :foo => :bar)
      resp.should_not be_nil
      resp.should be_success
      resp.url.should == 'http://www.example.com/full_page.html?one=1&foo=bar'
    end
    
    it 'should not append non-Hash options' do
      resp = ContentOMatic.get('full_page.html', [:foo, :bar])
      resp.should_not be_nil
      resp.should be_success
      resp.url.should == 'http://www.example.com/full_page.html'
    end
    
    it 'should return a 500 response if there is an error' do
      resp = ContentOMatic.get(nil)
      resp.should_not be_nil
      resp.status.should == 500
      resp.body.should match(/nil:NilClass/)
    end
    
  end
  
end
