module LiquidHelper

  def compile_template
    template = Liquid::Template.parse(@content)
    @layout_hash={}
    build_layout_hash
    build_image_gallery
    @compiled_template = template.render(@layout_hash)
    @compiled_template
  end

  def build_layout_hash
    @widget.contents.each do |content|
      @layout_hash[content.name] = build_input_type_for(content)
    end
    product = @widget.product
    product.attributes.reject{|k,v| k=='quantity'}.each{|k, v|@layout_hash[k] = v }
  end

  def build_input_type_for(content)
    case content.name
    when 'quantity'
      text_field_tag "cart[quantity]"
    when 'image_gallery'
      render :partial=>'products/image_gallery'
    when 'options'
      render :partial=>'products/options'
    end
  end

  def build_image_gallery
    
  end
  
end