#= require ./_validator

class FancyField
  constructor: (@field) ->
    @group = @field.closest('.input-group')
    @validator = new Validator(@field)
    # these are going to be firing *a lot*
    safeChange = _.throttle @onChange, 500
    @field.on
      blur: @onBlur
      'propertychange change click keyup input paste': safeChange
    @verify()

  dirty: false

  valid: false

  onBlur: =>
    @dirty = true
    @verify()

  onChange: =>
    @verify()
    @field.trigger('change.fancyform')

  validate: =>
    @valid = @validator.valid()

  verify: =>
    @validate()
    return unless @dirty
    if @valid
      @enable()
    else
      @disable()

  disable: =>
    @group
      .addClass('has-error')
      .removeClass('has-success')

  enable: =>
    @group
      .addClass('has-success')
      .removeClass('has-error')

window.FancyField = FancyField
