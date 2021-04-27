/*!
    * Start Bootstrap - Creative v6.0.4 (https://startbootstrap.com/theme/creative)
    * Copyright 2013-2020 Start Bootstrap
    * Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-creative/blob/master/LICENSE)
    */
    (function($) {
  "use strict"; // Start of use strict

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

}); // End of use strict