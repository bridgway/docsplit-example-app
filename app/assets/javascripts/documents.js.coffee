# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

`$('a#download_link').click(function(e) {
    e.preventDefault();  //stop the browser from following
    window.location.href = 'public/0.6737617961544482.pdf'; #not working 
});`

`$('a#download_link').attr({target: '_blank', 
                    href  : 'public/0.6737617961544482.pdf'});` #not working 