function initialize_droppables(){
  $( ".droppable-holder" ).droppable({
    activeClass: "layer-holder-active",
    accept: ".table-draggable",
    drop: function( event, ui ) {
    }
  })
}