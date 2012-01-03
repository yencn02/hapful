class Admin < User
  default_scope :conditions=>{:is_admin=>true}
end
