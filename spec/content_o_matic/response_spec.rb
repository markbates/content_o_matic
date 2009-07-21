require File.dirname(__FILE__) + '/../spec_helper'

describe ContentOMatic::Response do
  
  describe 'success?' do

    it 'should return the body if the response was successful' do
      @full_page_response.should be_success
      @full_page_response.to_s.should == fixture_value('full_page.html')
    end
    
    it 'should return an empty string if the response was not successful' do
      @failure_response.should_not be_success
      @failure_response.to_s.should == ''
    end
    
  end
  
  describe 'has_layout?' do
    
    it 'should return true if the content is a full html page' do
      @full_page_response.should have_layout
    end
    
    it 'should return false if the content is not a full html page' do
      @body_only_response.should_not have_layout
    end
    
  end
  
  describe 'html_body' do
    
    it 'should return just the content in the body tags' do
      body = @full_page_response.html_body
      body.should_not be_nil
      body.should_not match(/<title>Some Awesome Page!<\/title>/)
      body.should match(/<h1>My Big Header!!<\/h1>/)
      
      body = @body_only_response.html_body
      body.should_not be_nil
      body.should == fixture_value('body_only.html')
    end
    
    it 'should normalize assets if told' do
      body = @full_page_response.body(true)
      body.should_not be_nil
      # write_fixture('full_page_normalized.txt', body)
      body.should == fixture_value('full_page_normalized.txt')
    end
    
  end
  
  describe 'to_s' do
    
    it 'should return the body if the response was successful' do
      @full_page_response.should be_success
      @full_page_response.to_s.should == fixture_value('full_page.html')
    end
    
    it 'should return an empty string if the response was not successful' do
      @failure_response.should_not be_success
      @failure_response.to_s.should == ''
    end
    
  end
  
  describe 'normalize' do
    
    it 'should normalize a complex document' do
      resp = ContentOMatic::Response.new('http://www.example.com/complex_source.html', '200', fixture_value('complex_source.html'))
      # write_fixture('complex_source_actual.txt', resp.body(true))
      resp.body(true).should == fixture_value('complex_source_normalized.txt')
    end
    
  end
  
  describe 'normalize_asset_url' do
    
    it 'should normalize an asset url' do
      ContentOMatic::Response.class_eval do
        public :normalize_asset_url
      end
      resp = ContentOMatic::Response.new('http://www.example.com/full_page.html', '200', '')
      url = resp.normalize_asset_url('image.jpg')
      url.should == 'http://www.example.com/image.jpg'
      url = resp.normalize_asset_url('/image.jpg')
      url.should == 'http://www.example.com/image.jpg'
      url = resp.normalize_asset_url('http://www.example.org/image.jpg')
      url.should == 'http://www.example.org/image.jpg'
      
      resp = ContentOMatic::Response.new('http://www.example.com/foo/full_page.html', '200', '')
      url = resp.normalize_asset_url('image.jpg')
      url.should == 'http://www.example.com/foo/image.jpg'
      url = resp.normalize_asset_url('/image.jpg')
      url.should == 'http://www.example.com/image.jpg'
      url = resp.normalize_asset_url('http://www.example.org/image.jpg')
      url.should == 'http://www.example.org/image.jpg'
      
      resp = ContentOMatic::Response.new('http://www.example.com/foo/bar/full_page.html', '200', '')
      url = resp.normalize_asset_url('image.jpg')
      url.should == 'http://www.example.com/foo/bar/image.jpg'
      url = resp.normalize_asset_url('/fubar/image.jpg')
      url.should == 'http://www.example.com/fubar/image.jpg'
      url = resp.normalize_asset_url('http://www.example.org/image.jpg')
      url.should == 'http://www.example.org/image.jpg'
    end
    
  end
  
end
