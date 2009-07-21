module ContentOMatic
  # This class is used to cache results of succesful retrieval of a web page.
  # It uses Cachetastic to do the caching. You can expect to receive
  # ContentOMatic::Response objects, if they are in the cache.
  # 
  # Caching can be turned on (it's off by default) with the following configatron setting:
  #   configatron.content_o_matic.cache_results = true
  class ContentCache < Cachetastic::Cache
    
  end # ContentCache
end # ContentOMatic