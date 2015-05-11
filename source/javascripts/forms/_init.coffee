#= require ./_ajax_form
#= require ./_fancy_form

new AjaxForm $(el) for el in $('[data-ajax-form]')
new FancyForm $(el) for el in $('form')
