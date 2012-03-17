class Post < Product
  acts_as_taggable
  acts_as_commentable
  
  default_scope where({:use_hapful=>false})
  named_scope :active, where({:state=>'active'})

  def self.sorted_from_params(sort_val,n=5)
    order = case sort_val
    when 'most viewed'
      "views DESC"
    when 'top rated'
      "rating DESC"
    else
      "created_at DESC"
    end
    Post.active.all(:order=>order, :limit=>n)
  end

  def self.paginated_search(opts, page, per_page)
    Product.paginated_search(opts, page, per_page, false)
  end
  
  def self.paginated_search_count(opts)
    Product.paginated_search_count(opts, false)
  end
  
end