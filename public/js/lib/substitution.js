// Generated by CoffeeScript 1.6.3
(function() {
  var socket;

  socket = io.connect();

  $(function() {
    return $('#substitution-form').on('submit', '.substitution-submit', function(e) {
      var formData;
      console.log();
      e.preventDefault();
      formData = $(this).serialize();
      console.log("formData", formData);
      return $('#substitute-results').append;
    });
  });

}).call(this);