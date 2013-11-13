// Generated by CoffeeScript 1.6.3
(function() {
  var socket;

  socket = io.connect();

  $(function() {
    $(".chzn-select").chosen();
    $('#substitute-params').hide();
    return socket.on('connect', function() {
      $('#substitution-form').on('click', '.substitution-submit', function(e) {
        var formData;
        console.log();
        e.preventDefault();
        formData = $(this).serialize();
        return console.log("formData", formData);
      });
      return $('#substitution-form').on('change', function(e) {
        var val;
        e.preventDefault();
        val = $(this).serialize();
        console.log("val", val);
        socket.emit('requestparams', val);
        $('#substitute-params').show();
        return socket.on('sendparams', function(data) {
          var item, _i, _len;
          console.log("sendparms:::", data);
          $('.subs').empty();
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            item = data[_i];
            if (item['non-vegan-units'] || item['non-vegan-qty']) {
              $('#substitute-params #units').append("<option data-placeholder='units' value=" + item['non-vegan-units'] + ">" + item['non-vegan-units'] + "</option>");
              $('#substitute-params #qty').append("<option data-placeholder='qty' value=" + item['non-vegan-qty'] + ">" + item['non-vegan-qty'] + "</option>");
              $('#units').trigger("chosen:updated");
              $('#qty').trigger("chosen:updated");
            }
          }
          return $(document).on('click', '.substitution-submit', function(e) {
            var dataDescription, dataForRow, dataItem, dataQty, dataUnits, itemset, newArray, newRow, vegDescription, vegItems, vegQty, vegUnits, _j, _k, _len1, _len2, _results;
            e.preventDefault();
            console.log("daat", data);
            $('#substitute-results').empty();
            _results = [];
            for (_j = 0, _len1 = data.length; _j < _len1; _j++) {
              item = data[_j];
              $('#NonItem').text(item['non-vegan-item']);
              $('#NonQty').text(item['non-vegan-qty']);
              $('#NonUnits').text(item['non-vegan-units']);
              vegItems = item['vegan-substitute'];
              vegUnits = item['substitute-units'];
              vegQty = item['substitute-qty'];
              vegDescription = item['substitute-description'];
              newArray = _.zip(vegItems, vegUnits, vegQty, vegDescription);
              console.log(newArray);
              for (_k = 0, _len2 = newArray.length; _k < _len2; _k++) {
                itemset = newArray[_k];
                console.log("itemset", itemset);
                dataItem = "<td>" + itemset[0] + "</td>";
                dataUnits = "<td>" + itemset[1] + "</td>";
                dataQty = "<td>" + itemset[2] + "</td>";
                dataDescription = "<td>" + itemset[3] + "</td>";
                dataForRow = dataItem + dataUnits + dataQty + dataDescription;
                newRow = "<tr>" + dataForRow + "</tr>";
              }
              _results.push($('#substitute-results').append(newRow));
            }
            return _results;
          });
        });
      });
    });
  });

}).call(this);
