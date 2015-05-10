class RequiredValidation
  constructor: (@input) ->

  present: =>
    @input.attr('required')?

  valid: =>
    @input.val().length > 0

window.RequiredValidation = RequiredValidation
