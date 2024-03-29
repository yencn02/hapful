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
  Comment.init();
  Checkout.init();
  SaleTaxes.init();
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

function sort_posts(obj){
  $('#post-loader').show();
  $('#posts').hide();
  $.ajax({
    url: '/posts/ajax_sort',
    data: {
      sort: $(obj).val()
    },
    success: function(data){
      $('#posts').html(data.data);
      $('#post-loader').hide();
      $('#posts').show();
    }
  })
}


Comment = {
  init: function(){
    $(".comment .reply").unbind().click(function(){
      $(this).parents(".comment").find('.subcomment').show();
      $(this).parents(".comment").find("#comment_body").focus();
      return false
    });
    $("input[type=submit]").click(function(){
      $(this).parents("form").submit();
    });
    $(".new_comment .cancel").unbind().click(function(){
      $(this).parents(".subcomment.reply").hide();
      return false;
    });
  }
}

Checkout = {
  init: function(){
    $("select.country").unbind().bind("change", function(){
      var country = $(this).val();
      var state = $(this).parents(".address").first().find("select.state");
      var options = states[country];
      state.html(options);
    });
  }
}

SaleTaxes = {
  init: function(){
    $("form.new_tax .new-tax-btn, form.new_tax .update-taxes").click(function(){
      $(this).parents("form").ajaxSubmit({
        dataType: 'script'
      });
    });
  }
}