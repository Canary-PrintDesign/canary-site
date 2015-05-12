#= require ./_fancy_field

KEY_CODE_ENTER = 13

class FancyForm
  constructor: (@form) ->
    @_fields = @form.find('input, textarea').map ->
      new FancyField $(this)
    @form
      .on
        blur: @onBlur
        'change.fancyform': @onChange
      .on
        click: @onTrySubmit
        'keypress': @onSubmitKeypress
      , '[type=submit]'
    @verify()

  _fields: []

  dirty: false

  valid: false

  onBlur: =>
    @dirty = true
    @verify()

  onChange: =>
    @verify()

  onTrySubmit: =>
    fancy_field.field.trigger('blur') for fancy_field in @_fields
    @validate()

  onSubmitKeypress: (e) =>
    @onTrySubmit() if e.keyCode is KEY_CODE_ENTER

  verify: =>
    @valid = @validate()

  validate: =>
    @valid = _.all(@_fields, 'valid')

window.FancyForm = FancyForm
