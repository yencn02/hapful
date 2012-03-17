function initialize_droppables(){
  $( ".droppable-holder" ).droppable({
    activeClass: "layer-holder-active",
    accept: ".table-draggable",
    drop: function( event, ui ) {
    }
  })
}

function add_to_yui(id, content){
  new_content =  $('#'+id).contents().find('body').html() + content;
  $('#'+id).contents().find('body').html(new_content);
}