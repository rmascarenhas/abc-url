$(document).ready(function() {
  var countdownEl = $("#reload-countdown");
  var seconds     = 15;

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
  (function countdown() {
    setCountdownMessage(seconds);

    if (seconds === 0) {
      return window.location.reload();
    }

    seconds = seconds - 1;

    window.setTimeout(countdown, 1000);
  })();
});
