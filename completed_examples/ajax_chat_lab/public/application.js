function highlightUsername(message) {
  var username = $('#username').val();
  if ($.trim(username)) {
    var usernameRegex = new RegExp(username,"gi");
    message = message.replace(usernameRegex, function myFunction(match) {
      return "<span class='username'>" + match + "</span>"
    });
  }
  return message;
}

function addLines(data) {
  $.each(data, function(i, chatline) {
    $('ul').prepend('<li><span class="username">&lt;' + chatline.username + "&gt;</span> <span class='message'>" + highlightUsername(chatline.message) + "</span>");
  });
}

function updateTimestamp(data) {
  if (data[data.length-1]) {
    $('#since').val(data[data.length-1].timestamp);
  }
}

function clearForm() {
  $('#message').val('');
}

function ajaxRequest(data) {
  var ajaxOptions = {
    url: '/chat',
    type: 'POST',
    data: data
  };
  return $.ajax(ajaxOptions).success(addLines).success(updateTimestamp);
}

$(function() {
  $('form').on('submit', function(ev) {
    ev.preventDefault();
    ajaxRequest({
      'username': $('#username').val(),
      'message': $('#message').val(),
      'since': $('#since').val()
    }).success(clearForm);
  });

  // uncomment to make app update chats every two seconds
  setInterval(function() {
    ajaxRequest(
      {'since': $('#since').val()}
      )
  }, 2000);

});


