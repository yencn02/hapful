class Product < ActiveRecord::Base

  STATES = %w(new saved expiring published deleted)
  STATES.each do |state|
    define_method "#{state}?" do
      self.state == state
    end
    define_method "mark_as_#{state}!" do
      self.state = state
      self.save
    end
  end

  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  acts_as_taggable
  acts_as_commentable

  has_one :widget, :class_name=>'ProductWidget', :dependent=>:destroy
  
  has_many :options, :class_name=>'ProductOption', :dependent=>:destroy
  has_many :images, :class_name=>'ProductImage', :dependent=>:destroy
  has_many :order_items
  has_many :orders, :through=>:order_items
  has_many :payment_options, :class_name=>'ProductPaymentOption', :dependent=>:destroy
  has_many :shipping_options, :class_name=>'ProductShippingOption', :order=>"amount", :dependent=>:destroy do
    def for_option(option)
      find(:first, :conditions=>{:shipping_option_id=>option.id}) || ProductShippingOption.new
    end
  end
  has_many :payment_types, :through=>:payment_options,  :source=>:payment_type
  has_many :shipping_types, :through=>:shipping_options, :class_name=>'ShippingOption', :source=>:shipping_option

  accepts_nested_attributes_for :widget, :allow_destroy=>true
  accepts_nested_attributes_for :options,  :reject_if => proc{|attrs| attrs.all?{|k,v| k=='_destroy' ? v : v.blank?} }, :allow_destroy=>true
  accepts_nested_attributes_for :images, :allow_destroy=>true

  belongs_to :user
  belongs_to :category

  delegate :name, :to=>:category, :allow_nil=>true, :prefix=>true
  
  alias_method :seller, :user

  scope :top_rated, where({:state=>'active', :use_hapful=>true}, limit(10).order("rating DESC"))
  scope :newly_added, where({:state=>'active', :use_hapful=>true}, limit(10).order("created_at DESC"))
  scope :most_viewed, where({:state=>'active', :use_hapful=>true}, limit(10).order("views DESC"))
  scope :active, where(["state!='deleted' OR state IS NULL AND use_hapful=?", true])
  scope :deleted, where({:state=>'deleted'})
  scope :as_external, where({:is_external=>true})


  ## VALIDATIONS
  validates_presence_of :name
  validates_presence_of :price
  validates_presence_of :post_url
  validate :has_image?, :if=>:use_hapful?
  validate :check_payment_and_shipping, :if=>:use_hapful?

  ## CALLBACKS
  after_create [:create_code, :initialize_widget_data]
  
  def belongs_to?(user)
    self.user == user
  end

  def product_widget_path
    "#{ProjectConfig.value("site_url")}/p/#{slug}"
  end

  def embed_code(options={})
    %Q!<script src="#{product_widget_path}.js#{'?demo=1'if options[:demo]==true }"></script>!
  end

  def redirection_path
    post_url || "/products/#{slug}"
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

  def self.paginated_search(opts, page, per_page, use_hapful=true)
    @opts = opts
    @use_hap = use_hapful ? 1 : 0
    self.paginate_by_sql(search_sql, :page=>page, :per_page=>per_page)
  end

  def self.paginated_search_count(opts, use_hapful=true)
    @opts = opts
    @use_hap = use_hapful ? 1 : 0
    self.count_by_sql(search_sql)
  end

  def self.search_sql
    sql_statement = "SELECT * FROM #{Product.table_name} WHERE "
    sql_statement << "name LIKE ? " if @opts[:keyword]
    sql_statement << "AND category_id = ?" if @opts[:category]
    sql_statement << "AND use_hapful = #{@use_hap} AND state != 'deleted' "
    ret_arr = [sql_statement]
    ret_arr << "%#{@opts[:keyword]}%" if @opts[:keyword]
    ret_arr << @opts[:category] if @opts[:category]
    ret_arr
  end

  def set_shipping_options(params)
    params.each do |k,v|
      obj = shipping_options.find(:first, :conditions=>{:shipping_option_id=>k})
      if obj
        v['shipping_option_id'].nil? ? obj.destroy : obj.attributes = v; obj.save
      else
        v['shipping_option_id'].nil? ? next : self.shipping_options.build(v)
      end
    end
  end

  def set_payment_options(params)
    self.payment_type_ids = params
  end

  private

  def initialize_widget_data
    widget = self.create_widget(:content=>"Quantity {{ quantity }}<br/>Image Gallery {{ image_gallery}}<br/>Options {{ options }}", :title=>"See the Product")
    self.state = "Widget needs updating" if self.customized_widget?
    ProductWidgetContent::BUILT_IN.each do |k,v|
      widget.contents.create!(:name=>k)
    end
  end

  def create_code
    self.code = Digest::SHA1.hexdigest("#{self.id}:#{self.name}")
    self.ordered_quantity = 0
    self.quantity = 0 if self.quantity.nil?
    save
  end

  def has_image?
    errors.add_to_base "Please upload at least 1 image" if self.images.blank? || self.images.first.image_file_name.blank?
  end

  def check_payment_and_shipping
    check_payment_options
    check_shipping_options
  end

  def check_payment_options
    if payment_types.blank?
      errors.add_to_base("Please select at least 1 payment option")
    end
  end

  def check_shipping_options
    errors.add_to_base("Please select at least 1 shipping option") if shipping_options.blank?
  end

end
