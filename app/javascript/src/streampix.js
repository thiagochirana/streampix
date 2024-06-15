document.addEventListener('DOMContentLoaded', function() {
  var moneyInputs = document.querySelectorAll('.money-input');

  moneyInputs.forEach(function(input) {
    input.addEventListener('keydown', function(event) {
      var key = event.key;
      console.log("clicou "+key)
      if (!key.match(/[0-9,]/) && 
          key !== 'Backspace' && 
          key !== 'Delete' && 
          key !== 'ArrowLeft' && 
          key !== 'ArrowRight' && 
          key !== 'Tab') {
        event.preventDefault();
      }

      if (key === ',' && event.target.value.includes(',')) {
        event.preventDefault();
      }
    });
  });
});