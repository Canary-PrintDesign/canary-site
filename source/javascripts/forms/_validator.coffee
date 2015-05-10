#= require ./validations/_email
#= require ./validations/_required

validations = [
  window.EmailValidation
  window.RequiredValidation
]

class Validator
  constructor: (@field) ->
    @validations = validations
      .map (Validation) =>
        new Validation(@field)
      .filter (validation) ->
        validation.present()

  valid: =>
    val = @field.val()
    _.all @validations, (validation) ->
      validation.valid(val)

window.validations = validations
window.Validator = Validator
