$(document).ready(function() {
  var $previousPostLink = $('.previous'),
      $nextPostLink = $('.next');

  if ($('.image-detail').length) {
    $(document).keydown(function(e){
      if ($previousPostLink.length && (e.which === 37)) {
        window.location.href = $previousPostLink.attr('href');
      } else if ($nextPostLink.length && (e.which === 39)) {
        window.location.href = $nextPostLink.attr('href');
      }
    });
  }
});