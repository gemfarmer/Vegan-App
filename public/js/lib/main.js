// Generated by CoffeeScript 1.6.3
(function() {
  var socket;

  console.log("fire main.js");

  socket = io.connect();

  $(function() {
    console.log('fire jQ');
    socket.on('connect', function() {
      console.log("socket connected to yummly");
      return socket.on('yumKeyUpData', function(data) {
        var item, matched, recipeImg, recipeNameDom, recipeSource, _i, _len;
        console.log("data::::", data);
        console.log(data.matches);
        matched = data.matches;
        console.log("matched::::", matched);
        $('.querySearchSelect').empty();
        $('#recipeRepo').empty();
        for (_i = 0, _len = matched.length; _i < _len; _i++) {
          item = matched[_i];
          $('.querySearchSelect').append("<option class='querySearchOptions' value=" + item.id + ">" + item.recipeName + "</option>");
          recipeNameDom = "<div value='" + item.id + "' class='recipeName'>" + item.recipeName + "</div>";
          recipeSource = "<div class='recipeSource'>Source: " + item.sourceDisplayName + "</div>";
          if (item.smallImageUrls[0]) {
            recipeImg = "<img class='recipeImg' src=" + item.smallImageUrls[0] + "></img>";
          } else {
            recipeImg = "<img class='recipeImg' src='img/default-recipe.png'></img>";
          }
          $('#recipeRepo').append("<li class='matchedRecipe'>" + recipeImg + recipeNameDom + recipeSource + "</li>");
        }
        console.log("item::::", data);
        return $('#matchedResults').text("" + data.totalMatchCount + " Matched Results");
      });
    });
    $(document).on('keyup', '.chosen-search input', function(e) {
      var dataToYummly, val;
      e.preventDefault();
      val = $(this).val();
      if (val.length <= 4) {
        return;
      }
      dataToYummly = {};
      dataToYummly.q = val;
      console.log("dataToYummly:", dataToYummly);
      console.log(val);
      return socket.emit('yumKeyUp', dataToYummly);
    });
    $(".chzn-select").chosen();
    $('#recipe-form').on('change', function(e) {
      var info;
      e.preventDefault();
      info = $(this).serialize();
      console.log("info", info);
      return socket.emit('yumForm', info);
    });
    return $(document).on('click', '#searchEngine', function(e) {
      e.preventDefault();
      console.log("click");
      return $('#searchEngine').toggleClass('tuck');
    });
  });

}).call(this);
