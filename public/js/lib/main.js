// Generated by CoffeeScript 1.6.3
(function() {
  var socket;

  console.log("fire main.js");

  socket = io.connect();

  $(function() {
    console.log('fire jQ');
    socket.on('connect', function() {
      socket.on('yumKeyUpData', function(data) {
        var item, joinedRecipeItem, matched, _i, _len, _results;
        console.log(data.matches);
        matched = data.matches;
        console.log(matched);
        $('.querySearchSelect').empty();
        $('.querySearchSelect').parents('chosen-results').empty();
        _results = [];
        for (_i = 0, _len = matched.length; _i < _len; _i++) {
          item = matched[_i];
          console.log(item.recipeName);
          joinedRecipeItem = item.recipeName.split(" ").join("+");
          $('.querySearchSelect').append("<option class='querySearchOptions' value=" + joinedRecipeItem + ">" + item.recipeName + "</option>");
          _results.push($('.querySearchSelect').trigger("chosen:updated"));
        }
        return _results;
      });
      return console.log("socket connected to yummly");
    });
    $(document).on('keyup', '.chosen-search input', function(e) {
      var dataToYummly, val;
      e.preventDefault();
      val = $(this).val();
      if (val.length <= 3) {
        return;
      }
      dataToYummly = {};
      dataToYummly.q = val;
      console.log("dataToYummly:", dataToYummly);
      console.log(val);
      return socket.emit('yumKeyUp', dataToYummly);
    });
    $(".chzn-select").chosen();
    return $('#recipe-form').on('change', function(e) {
      var info;
      e.preventDefault();
      info = $(this).serialize();
      console.log("info", info);
      return socket.emit('yumForm', info);
    });
  });

}).call(this);
