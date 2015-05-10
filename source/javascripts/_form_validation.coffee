class FancyField
  constructor: (@field) ->
    # these are going to be firing *a lot*
    safeChange = _.throttle @onChange, 500
    @field.on 'propertychange change click keyup input paste', safeChange

  _dirty: false

  valid: =>
    false

  onChange: =>
    @field.trigger('change.fancyform')

class FancyForm
  constructor: (@form) ->
    _fields = @form.find('input, textarea').map ->
      new FancyField $(this)
    @checkForm(true)
    @form
      .on
        submit: @onSubmit
        'change.fancyform': @onChange
      # .on
      #   blur: @onBlur
      #   change: @onChange
      # , 'input, textarea'

  _dirty: false

  _fields: []

  valid: =>


  onChange: =>
    console.log 'onChange'

  checkForm: (firstPass) =>
    unless firstPass
      @dirty = true
    if @validate()
      @enable()
    else
      @disable

  onBlur: =>


  onSubmit: =>
    @validate()

  validate: =>
    false

  disable: =>
    form.addClass('disabled')
      .find('[type=submit]').attr('disabled', 'disabled')

  enable: =>
    form.removeClass('disabled')
      .find('[type=submit]').removeAttr('disabled')



new FancyForm $(el) for el in $('form')
