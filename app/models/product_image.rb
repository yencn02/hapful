class ProductImage < ActiveRecord::Base

  VALID_CONTENT_TYPES = [
    'image/bmp', 'image/gif',
    'image/png','image/x-png',
    'image/jpeg', 'image/pjpeg',
    'image/tiff', 'image/x-tiff'
  ]

  Paperclip.interpolates :filename do |attachment, style|
    attachment.instance.image_file_name
  end

  has_attached_file :image,
    :styles=>{:medium=>"300x300>", :thumbnail=>"100x100>"},
    :url => "/assets/pi/:id_partition/:style/:filename",
    :path => ":rails_root/public/assets/pi/:id_partition/:style/:filename",
    :default_url=>"images/rails.png"
  validates_attachment_content_type :image, :content_type => VALID_CONTENT_TYPES
  validate :check_file

  private

  def check_file
    errors.add_to_base("Please upload a file") if self.image_file_size.to_i == 0
  end
  
end
