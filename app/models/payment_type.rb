class PaymentType < ActiveRecord::Base

  validates :name, :presence=>true, :uniqueness=>true

  scope :activated, where(:activated=>true)

  def checks_for_merchant_account?
    !!requisite_merchant_account.blank?
  end
end
