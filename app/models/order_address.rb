class OrderAddress < ActiveRecord::Base

  belongs_to :order

  validates :first_name, :presence=>true
  validates :last_name, :presence=>true
  validates :street_1, :presence=>true

  attr_accessor :diff_add

  def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def complete_address
    ""
  end
end
