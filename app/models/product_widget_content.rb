class ProductWidgetContent < ActiveRecord::Base

  BUILT_IN = {
    :quantity=>{
      :style=>[:select, :text_area]
    },
    :image_gallery=>{
      :style=>[:horizontal, :vertical]
    },
    :options=>{
      :style=>[:bulleted, :dropdown]
    }
  }
  
  belongs_to :widget, :class_name=>'ProductWidget'
  
end
