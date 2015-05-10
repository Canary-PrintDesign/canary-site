# http://stackoverflow.com/a/46181
validateEmail = (email) ->
  re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
  re.test(email)

class EmailValidation
  constructor: (@input) ->

  present: =>
    @input.attr('type') is 'email'

  valid: =>
    validateEmail @input.val()

window.EmailValidation = EmailValidation
