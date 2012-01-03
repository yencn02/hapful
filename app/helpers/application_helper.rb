module ApplicationHelper

  include LiquidHelper

  def content_header(title, position='left')
    content_for "content_header_#{position}".to_sym do
      title
    end
  end
  
  def show_errors_for(object)
    render :partial=>"shared/form_errors", :locals=>{:object=>object}
  end

end
