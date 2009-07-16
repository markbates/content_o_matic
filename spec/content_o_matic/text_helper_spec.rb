require File.dirname(__FILE__) + '/../spec_helper'

describe ActionView::Helpers::TextHelper do
  include ActionView::Helpers::TextHelper
  
  describe 'content_o_matic' do
    
    it 'should return just the body of page by default' do
      text = content_o_matic('full_page.html')
      text.should_not be_nil
      text.should == fixture_value('full_page_html_body.txt')
      
      text = content_o_matic('http://www.example.com/body_only.html')
      text.should_not be_nil
      text.should == fixture_value('body_only.txt')
    end
    
    it 'should return the full body of the page if configured to do so' do
      text = content_o_matic('full_page.html', :html_body => false)
      text.should_not be_nil
      # write_fixture('full_page.txt', text)
      text.should == fixture_value('full_page.txt')
    end
    
    it 'should return the exception if there is a problem' do
      text = content_o_matic('oops.html')
      text.should_not be_nil
      # write_fixture('oops.txt', text)
      text.should == fixture_value('oops.txt')
    end
    
  end
  
end
