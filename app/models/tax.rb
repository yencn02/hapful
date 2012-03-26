class Tax < ActiveRecord::Base
  belongs_to :user

  before_save :update_percentage
  validates :state, :presence => true
  private
  def update_percentage
    if self.percentage < 0
      self.percentage = self.percentage.abs
    end
  end

end
