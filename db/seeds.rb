seller = User.create!(:email=>"hapful_seller@suremail.info", :password=>"123456", :password_confirmation=>"123456", :username=>"seller1")
admin = User.create!(:email=>"admin@hapful.com", :password=>"123456", :password_confirmation=>"123456", :is_admin=>true, :username=>"admin")
admin.make_admin!

categories = ["Clothing", "Equipments", "Hat"]
categories.each do |c|
  Category.create!(:name=>c)
end

ProjectConfig.create!(:key=>"site_url", :value=>'http://127.0.0.1:3000')
ProjectConfig.create!(:key=>"paypal_login", :value=>'hapful_1323917009_biz_api1.gmail.com')
ProjectConfig.create!(:key=>"paypal_password", :value=>'1323917047')
ProjectConfig.create!(:key=>"paypal_signature", :value=>'AFv7Jujecrsh1LTBIJMI8DBQtEQQAZ247BlTdAb7gpLHUUM6khKl.BFj')
ProjectConfig.create!(:key=>"description_note", :value=>'Place the description on your blog to make sure you get all the traffic!')
ProjectConfig.create!(:key=>'email_sender', :value=>'support@hapful.com')

UserMerchantAccount::TYPES.each do |k,v|
  PaymentType.create!(:name=>v, :requisite_merchant_account=>k, :activated=>true)
end
PaymentType.create!(:name=>'Cash on Delivery', :activated=>true)

ShippingOption::DEFAULT_VALUES.each do |val|
  ShippingOption.create!(:name=>val, :activated=>true)
end


