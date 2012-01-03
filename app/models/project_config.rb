class ProjectConfig < ActiveRecord::Base


  validates :key, :presence=>true, :uniqueness=>true
  validates :value, :presence=>true


  def self.value(key)
    ProjectConfig.find_by_key(key).value rescue ""
  end

  
end
