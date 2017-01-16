$(document).ready(function() {
  var countdownEl = $("#reload-countdown");
  var seconds     = 15;
  var abcForm     = $("#abc-form");

  // when the URL shortening form is submitted, make an API call to save the URL
  // and get its ID back from the server. With that, we can redirect the user to
  // the page with the clicks information
  //
  // If there is an error processing the request, show a message to the user indicating
  // that the provided URL is not valid
  abcForm.submit(function(event) {
    var url = $(this).serializeArray()[0].value;
    $.post("/api/shorten", { url: url })
      .done(function(data) { window.location = window.location + 'url/' + data.id; })
      .fail(function() { $('.url-error').text('This does not look like a valid URL') });

    event.preventDefault();
  });

  // sets the content of the element with ID +reload-countdown+ to a message
  // indicating in how many seconds the page will be reloaded.
  function setCountdownMessage(seconds) {
    var literal;

    if (seconds === 1) {
      literal = 'second';
    } else {
      literal = 'seconds';
    }

    countdownEl.text('Reloading in ' + seconds + ' ' + literal + '...');
  }

  // sets in a loop running every 1s until the number of remaining seconds
  // reaches 0, in which case the page is reloaded.
  if (countdownEl.length > 0) {
    (function countdown() {
      setCountdownMessage(seconds);

      if (seconds === 0) {
        return window.location.reload();
      }

      seconds = seconds - 1;

      window.setTimeout(countdown, 1000);
    })();
  }
});
