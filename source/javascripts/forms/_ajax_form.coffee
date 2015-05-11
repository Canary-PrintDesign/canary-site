class AjaxForm
  constructor: (@form) ->
    @submitButton = @form.find('[type=submit]')
    @loadingEndButtonText = @submitButton.html()
    @action = @form.attr('action')
    @form.on
      submit: @onSubmit

  loadingButtonText: '<i class="fa fa-spinner rotate-icon-animation"></i> Loading...'

  loading: =>
    @submitButton.html(@loadingButtonText)
      .attr('disabled', 'disabled')

  loadingEnd: =>
    @submitButton.html(@loadingEndButtonText)
      .removeAttr('disabled')

  onSubmit: (e) =>
    e.preventDefault()
    @loading()
    postData = $(this).serializeArray()
    $.post(@action, @form.serialize())
      .done(@loadingEnd)
      .then(@success, @error)

  success: =>
    @form.addClass('hidden')
    selector = @form.data('ajax-success')
    $(selector).removeClass('hidden')

  error: =>
    @form.addClass('hidden')
    selector = @form.data('ajax-error')
    $(selector).removeClass('hidden')

window.AjaxForm = AjaxForm
