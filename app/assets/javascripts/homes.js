/*!
    * Start Bootstrap - Creative v6.0.4 (https://startbootstrap.com/theme/creative)
    * Copyright 2013-2020 Start Bootstrap
    * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-creative/blob/master/LICENSE)
    */
    (function($) {
  "use strict"; // Start of use strict

  // Smooth scrolling using jQuery easing
  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: (target.offset().top - 72)
        }, 1000, "easeInOutExpo");
        return false;
      }
    }
  });

  // Closes responsive menu when a scroll trigger link is clicked
  $('.js-scroll-trigger').click(function() {
    $('.navbar-collapse').collapse('hide');
  });

  // Activate scrollspy to add active class to navbar items on scroll
  $('body').scrollspy({
    target: '#mainNav',
    offset: 75
  });

  // Collapse Navbar
  var navbarCollapse = function() {
    if ($("#mainNav").offset().top > 100) {
      $("#mainNav").addClass("navbar-scrolled");
    } else {
      $("#mainNav").removeClass("navbar-scrolled");
    }
  };
  // Collapse now if page is not at top
  navbarCollapse();
  // Collapse the navbar when page is scrolled
  $(window).scroll(navbarCollapse);

  // Magnific popup calls
  $('#portfolio').magnificPopup({
    delegate: 'a',
    type: 'image',
    tLoading: 'Loading image #%curr%...',
    mainClass: 'mfp-img-mobile',
    gallery: {
      enabled: true,
      navigateByImgClick: true,
      preload: [0, 1]
    },
    image: {
      tError: '<a href="%url%">The image #%curr%</a> could not be loaded.'
    }
  });

  
  
  var slider;
  var sliderFlag = false;
  var breakpoint = 768;//768px以下の場合
    
  function sliderSet() {
          var windowWidth = window.innerWidth;
          if (windowWidth >= breakpoint && !sliderFlag) {//768px以上は1行でスライダー表示
              slider = $('.slider').bxSlider({
              touchEnabled:false,//リンクを有効にするためスライドをマウスでドラッグした際にスライドの切り替えを可能にする機能を無効化
        mode: 'vertical',//縦スライド指定
        controls: false,//前後のコントロールを表示させない。
        auto: 'true',//自動的にスライド
        pager: false//ページ送り無効化
      });
              sliderFlag = true;
          } else if (windowWidth < breakpoint && sliderFlag) {
              slider.destroySlider();//bxSliderのOptionであるdestroySliderを使用してスライダーの動きを除去
              sliderFlag = false;
          }
      }
  
    $(window).on('load resize', function() {
            sliderSet();
    });
    
    //◆タブレット以下も1行で表示させたい場合は下記のみの記述でOK
    //$('.slider').bxSlider({
    //touchEnabled:false,
    //mode: 'vertical',
    //controls: false,
    //auto: 'true',
    //pager: false
    //});
    
})(jQuery); // End of use strict