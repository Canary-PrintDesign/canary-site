#= require ./_fancy_field

class FancyForm
  constructor: (@form) ->
    @_fields = @form.find('input, textarea').map ->
      new FancyField $(this)
    @form.on
      blur: @onBlur
      submit: @onSubmit
      'change.fancyform': @onChange
    @verify()

  _fields: []

  dirty: false

  valid: false

  onBlur: =>
    @dirty = true
    @verify()

  onChange: =>
    @verify()

  verify: () =>
    @validate()

  onSubmit: =>
    fancy_field.field.trigger('blur') for fancy_field in @_fields
    @validate()

  validate: =>
    @valid = _.all(@_fields, 'valid')

window.FancyForm = FancyForm
