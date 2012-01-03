class Product < ActiveRecord::Base

  STATES = {
    
  }
  
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  acts_as_taggable

  has_one :widget, :class_name=>'ProductWidget', :dependent=>:destroy
  
  has_many :options, :class_name=>'ProductOption', :dependent=>:destroy
  has_many :images, :class_name=>'ProductImage', :dependent=>:destroy

  accepts_nested_attributes_for :widget, :allow_destroy=>true
  accepts_nested_attributes_for :options,  :reject_if => proc{|attrs| attrs.all?{|k,v| k=='_destroy' ? v : v.blank?} }, :allow_destroy=>true
  accepts_nested_attributes_for :images, :allow_destroy=>true

  after_create [:create_code, :initialize_widget_data]

  belongs_to :user
  belongs_to :category

  alias_method :seller, :user

  scope :top_rated, limit(10).order("rating DESC")
  scope :newly_added, limit(10).order("created_at DESC")
  scope :most_viewed, limit(10).order("views DESC")

  validates_presence_of :name
  validates_presence_of :price

  validate :has_image?

  def belongs_to?(user)
    self.user == user
  end

  def product_widget_path
    "#{ProjectConfig.value("site_url")}/p/#{slug}"
  end

  def embed_code(options={})
    %Q!<script src="#{product_widget_path}.js#{'?demo=1'if options[:demo]==true }"></script>!
  end

  def effective_price
    amount = self.on_discount? ? discounted_price : price
  end

  def products_related_by_user(limit = 5)
    seller.products.find(:all, :limit=>limit, :conditions=>["id != ?", self.id])
  end

  def products_related_by_category(limit = 5)
    category.products.find(:all, :limit=>limit, :conditions=>["id != ?", self.id])
  end
  
  private

  def initialize_widget_data
    widget = self.create_widget(:content=>"Quantity {{ quantity }}")
    self.state = "Widget needs updating"
    widget.contents.create!(:name=>'quantity')
    widget.contents.create!(:name=>'image_gallery')
    widget.contents.create!(:name=>'options')
  end

  def create_code
    self.code = Digest::SHA1.hexdigest("#{self.id}:#{self.name}")
    save
  end

  def has_image?
    errors.add_to_base "Product must have at least 1 image" if self.images.blank?
  end

  

  
end
