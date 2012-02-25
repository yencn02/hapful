// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.fn.extend({
  insertAtCaret: function(myValue){
    return this.each(function(i) {
      if (document.selection) {
        //For browsers like Internet Explorer
        this.focus();
        sel = document.selection.createRange();
        sel.text = myValue;
        this.focus();
      }
      else if (this.selectionStart || this.selectionStart == '0') {
        //For browsers like Firefox and Webkit based
        var startPos = this.selectionStart;
        var endPos = this.selectionEnd;
        var scrollTop = this.scrollTop;
        this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
        this.focus();
        this.selectionStart = startPos + myValue.length;
        this.selectionEnd = startPos + myValue.length;
        this.scrollTop = scrollTop;
      } else {
        this.value += myValue;
        this.focus();
      }
    })
  }
});

$(document).ready(function(){
  $(".colorbox-inline").colorbox({
    inline:true,
    width:"50%",
    overlayClose:false
  });
  $(".colorbox-gallery").colorbox({
    rel:'colorbox-gallery',
    height:'80%'
  });
  $(".colorbox-iframe").colorbox({
    iframe:true,
    width:"85%",
    height:"95%",
    overlayClose:false
  });
  $(".accordion").accordion();
  $(".ui-tabs").tabs();
  $(".ui-ajax-tabs").tabs({
    ajaxOptions: {
      error: function( xhr, status, index, anchor ) {
        $( anchor.hash ).html(
          "Couldn't load this tab. We'll try to fix this as soon as possible. " +
          "If this wouldn't be a demo." );
      }
    }
  });

  $("span.toogle a").click(function(){
    var el = $(this).parents('.comment').find('.subcomment');
    el.toggle();
    if (el.is(":visible") == true){
      $(this).text("Collapse");
    }else{
      $(this).text("Expand");
    }
    return false;
  });

  $(".comment .reply").click(function(){
    $(this).parents(".comment").find('.subcomment').show();
    $(this).parents(".comment").find("span.toogle a").text("Collapse");
    $(this).parents(".comment").find("#comment_body").focus();
    return false
  });
});

function add_to_yui(id, content){
  new_content =  $('#'+id).contents().find('body').html() + content;
  $('#'+id).contents().find('body').html(new_content);
}


function show_widget_preview(id,url){
  $.ajax({
    url: url,
    data: {
      content: $('#'+id).contents().find('body').html()
    },
    success: function(data){
      $('#loading').hide();
      $('#widget-preview').html(data);
    }
  });
};

function submit_widget_layout(url){
  $.ajax({
    url: url,
    type: 'PUT',
    data: {
      product_widget: {
        content: $('#product_widget_content_editor').contents().find('body').html()
      }
    },
    success: function(data){
      document.location('/my-cart')
    }
  });
}

function change_quantity(url, return_url, pv, mv){
  $.ajax({
    url: url,
    type: 'POST',
    data: {
      change: mv,
      cart: {
        quantity: 1,
        product_option_id: pv
      }
    },
    success: function(data){
      document.location.href = return_url
    }
  });
}




