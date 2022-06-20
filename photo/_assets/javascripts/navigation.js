document.addEventListener("DOMContentLoaded", function(){
  var $previousPageLink = document.getElementsByClassName('previous'),
      $nextPageLink = document.getElementsByClassName('next');

  if (document.getElementsByClassName('image-list').length ||
      document.getElementsByClassName('image-detail').length) {

    document.addEventListener('keydown', navigatePage);

    function navigatePage(e) {
      if ($previousPageLink.length && (e.which === 37)) {
        window.location.href = $previousPageLink[0].href;
      } else if ($nextPageLink.length && (e.which === 39)) {
        window.location.href = $nextPageLink[0].href;
      }
    }
  }
});

