###*
# Featherlight - ultra slim jQuery lightbox
# Version 1.2.0 - http://noelboss.github.io/featherlight/
#
# Copyright 2015, Noël Raoul Bossart (http://www.noelboss.com)
# MIT Licensed.
*
###

(($) ->

  ###Featherlight is exported as $.featherlight.
     It is a function used to open a featherlight lightbox.

     [tech]
     Featherlight uses prototype inheritance.
     Each opened lightbox will have a corresponding object.
     That object may have some attributes that override the
     prototype's.
     Extensions created with Featherlight.extend will have their
     own prototype that inherits from Featherlight's prototype,
     thus attributes can be overriden either at the object level,
     or at the extension level.
     To create callbacks that chain themselves instead of overriding,
     use chainCallbacks.
     For those familiar with CoffeeScript, this correspond to
     Featherlight being a class and the Gallery being a class
     extending Featherlight.
     The chainCallbacks is used since we don't have access to
     CoffeeScript's `super`.
  ###

  Featherlight = ($content, config) ->
    if this instanceof Featherlight

      ### called with new ###

      @id = Featherlight.id++
      @setup $content, config
      @chainCallbacks Featherlight._callbackChain
    else
      fl = new Featherlight($content, config)
      fl.open()
      return fl
    return

  'use strict'
  if `'undefined' == typeof $`
    if 'console' of window
      window.console.info 'Too much lightness, Featherlight needs jQuery.'
    return
  opened = []

  pruneOpened = (remove) ->
    opened = $.grep(opened, (fl) ->
      `fl != remove` and fl.$instance.closest('body').length > 0
    )
    opened

  # structure({iframeMinHeight: 44, foo: 0}, 'iframe')
  #   #=> {min-height: 44}

  structure = (obj, prefix) ->
    result = {}
    regex = new RegExp('^' + prefix + '([A-Z])(.*)')
    for key of obj
      match = key.match(regex)
      if match
        dasherized = (match[1] + match[2].replace(/([A-Z])/g, '-$1')).toLowerCase()
        result[dasherized] = obj[key]
    result

  ###document wide key handler ###

  eventMap =
    keyup: 'onKeyUp'
    resize: 'onResize'

  globalEventHandler = (event) ->
    $.each Featherlight.opened().reverse(), ->
      if !event.isDefaultPrevented()
        if `false == this[eventMap[event.type]](event)`
          event.preventDefault()
          event.stopPropagation()
          return false
      return
    return

  toggleGlobalEvents = (set) ->
    if `set != Featherlight._globalHandlerInstalled`
      Featherlight._globalHandlerInstalled = set
      events = $.map(eventMap, (_, name) ->
        name + '.' + Featherlight::namespace
      ).join(' ')
      $(window)[if set then 'on' else 'off'] events, globalEventHandler
    return

  Featherlight.prototype =
    constructor: Featherlight
    namespace: 'featherlight'
    targetAttr: 'data-featherlight'
    variant: null
    resetCss: false
    background: null
    openTrigger: 'click'
    closeTrigger: 'click'
    filter: null
    root: 'body'
    openSpeed: 250
    closeSpeed: 250
    closeOnClick: 'background'
    closeOnEsc: true
    closeIcon: '&#10005;'
    loading: ''
    otherClose: null
    beforeOpen: $.noop
    beforeContent: $.noop
    beforeClose: $.noop
    afterOpen: $.noop
    afterContent: $.noop
    afterClose: $.noop
    onKeyUp: $.noop
    onResize: $.noop
    type: null
    contentFilters: [
      'jquery'
      'image'
      'html'
      'ajax'
      'iframe'
      'text'
    ]
    setup: (target, config) ->

      ### all arguments are optional ###

      if `typeof target == 'object'` and `target instanceof $ == false` and !config
        config = target
        target = `undefined`
      self = $.extend(this, config, target: target)
      css = if !self.resetCss then self.namespace else self.namespace + '-reset'
      $background = $(self.background or [
        '<div class="' + css + '-loading ' + css + '">'
        '<div class="' + css + '-content">'
        '<span class="' + css + '-close-icon ' + self.namespace + '-close">'
        self.closeIcon
        '</span>'
        '<div class="' + self.namespace + '-inner">' + self.loading + '</div>'
        '</div>'
        '</div>'
      ].join(''))
      closeButtonSelector = '.' + self.namespace + '-close' + (if self.otherClose then ',' + self.otherClose else '')
      self.$instance = $background.clone().addClass(self.variant)

      ### clone DOM for the background, wrapper and the close button ###

      ### close when click on background/anywhere/null or closebox ###

      self.$instance.on self.closeTrigger + '.' + self.namespace, (event) ->
        $target = $(event.target)
        if `'background' == self.closeOnClick` and $target.is('.' + self.namespace) or `'anywhere' == self.closeOnClick` or $target.closest(closeButtonSelector).length
          event.preventDefault()
          self.close()
        return
      this
    getContent: ->
      self = this
      filters = @constructor.contentFilters

      readTargetAttr = (name) ->
        self.$currentTarget and self.$currentTarget.attr(name)

      targetValue = readTargetAttr(self.targetAttr)
      data = self.target or targetValue or ''

      ### Find which filter applies ###

      filter = filters[self.type]

      ### check explicit type like {type: 'image'} ###

      ### check explicit type like data-featherlight="image" ###

      if !filter and data of filters
        filter = filters[data]
        data = self.target and targetValue
      data = data or readTargetAttr('href') or ''

      ### check explicity type & content like {image: 'photo.jpg'} ###

      if !filter
        for filterName of filters
          if self[filterName]
            filter = filters[filterName]
            data = self[filterName]

      ### otherwise it's implicit, run checks ###

      if !filter
        target = data
        data = null
        $.each self.contentFilters, ->
          filter = filters[this]
          if filter.test
            data = filter.test(target)
          if !data and filter.regex and target.match and target.match(filter.regex)
            data = target
          !data
        if !data
          if 'console' of window
            window.console.error 'Featherlight: no content filter found ' + (if target then ' for "' + target + '"' else ' (no target specified)')
          return false

      ### Process it ###

      filter.process.call self, data
    setContent: ($content) ->
      self = this

      ### we need a special class for the iframe ###

      if $content.is('iframe') or $('iframe', $content).length > 0
        self.$instance.addClass self.namespace + '-iframe'
      self.$instance.removeClass self.namespace + '-loading'

      ### replace content by appending to existing one before it is removed
         this insures that featherlight-inner remain at the same relative
         position to any other items added to featherlight-content
      ###

      self.$instance.find('.' + self.namespace + '-inner').slice(1).remove().end().replaceWith if $.contains(self.$instance[0], $content[0]) then '' else $content
      self.$content = $content.addClass(self.namespace + '-inner')
      self
    open: (event) ->
      self = this
      if (!event or !event.isDefaultPrevented()) and `self.beforeOpen(event) != false`
        if event
          event.preventDefault()
        $content = self.getContent()
        if $content
          opened.push self
          toggleGlobalEvents true
          self.$instance.appendTo(self.root).fadeIn self.openSpeed
          self.beforeContent event

          ### Set content and show ###

          $.when($content).always ($content) ->
            self.setContent $content
            self.afterContent event

            ### Call afterOpen after fadeIn is done ###

            $.when(self.$instance.promise()).done ->
              self.afterOpen event
              return
            return
          return self
      false
    close: (event) ->
      self = this
      if `self.beforeClose(event) == false`
        return false
      if `0 == pruneOpened(self).length`
        toggleGlobalEvents false
      self.$instance.fadeOut self.closeSpeed, ->
        self.$instance.detach()
        self.afterClose event
        return
      return
    chainCallbacks: (chain) ->
      for name of chain
        @[name] = $.proxy(chain[name], this, $.proxy(@[name], this))
      return
  $.extend Featherlight,
    id: 0
    autoBind: '[data-featherlight]'
    defaults: Featherlight.prototype
    contentFilters:
      jquery:
        regex: /^[#.]\w/
        test: (elem) ->
          elem instanceof $ and elem
        process: (elem) ->
          $(elem).clone true
      image:
        regex: /\.(png|jpg|jpeg|gif|tiff|bmp)(\?\S*)?$/i
        process: (url) ->
          self = this
          deferred = $.Deferred()
          img = new Image
          $img = $('<img src="' + url + '" alt="" class="' + self.namespace + '-image" />')

          img.onload = ->

            ### Store naturalWidth & height for IE8 ###

            $img.naturalWidth = img.width
            $img.naturalHeight = img.height
            deferred.resolve $img
            return

          img.onerror = ->
            deferred.reject $img
            return

          img.src = url
          deferred.promise()
      html:
        regex: /^\s*<[\w!][^<]*>/
        process: (html) ->
          $ html
      ajax:
        regex: /./
        process: (url) ->
          self = this
          deferred = $.Deferred()

          ### we are using load so one can specify a target with: url.html #targetelement ###

          $container = $('<div></div>').load(url, (response, status) ->
            if `status != 'error'`
              deferred.resolve $container.contents()
            deferred.fail()
            return
          )
          deferred.promise()
      iframe: process: (url) ->
        deferred = new ($.Deferred)
        $content = $('<iframe/>').hide().attr('src', url).css(structure(this, 'iframe')).on('load', ->
          deferred.resolve $content.show()
          return
        ).appendTo(@$instance.find('.' + @namespace + '-content'))
        deferred.promise()
      text: process: (text) ->
        $ '<div>', text: text
    functionAttributes: [
      'beforeOpen'
      'afterOpen'
      'beforeContent'
      'afterContent'
      'beforeClose'
      'afterClose'
    ]
    readElementConfig: (element) ->
      Klass = this
      config = {}
      if element and element.attributes
        $.each element.attributes, ->
          match = @name.match(/^data-featherlight-(.*)/)
          if match
            val = @value
            name = $.camelCase(match[1])
            if $.inArray(name, Klass.functionAttributes) >= 0

              ### jshint -W054 ###

              val = new Function(val)

              ### jshint +W054 ###

            else
              try
                val = $.parseJSON(val)
              catch e
            config[name] = val
          return
      config
    extend: (child, defaults) ->

      ### Setup class hierarchy, adapted from CoffeeScript ###

      Ctor = ->
        @constructor = child
        return

      Ctor.prototype = @prototype
      child.prototype = new Ctor
      child.__super__ = @prototype

      ### Copy class methods & attributes ###

      $.extend child, this, defaults
      child.defaults = child.prototype
      child
    attach: ($source, $content, config) ->
      Klass = this
      if `typeof $content == 'object'` and `$content instanceof $ == false` and !config
        config = $content
        $content = `undefined`

      ### make a copy ###

      config = $.extend({}, config)

      ### Only for openTrigger and namespace... ###

      tempConfig = $.extend({}, Klass.defaults, Klass.readElementConfig($source[0]), config)
      $source.on tempConfig.openTrigger + '.' + tempConfig.namespace, tempConfig.filter, (event) ->

        ### ... since we might as well compute the config on the actual target ###

        elemConfig = $.extend({
          $source: $source
          $currentTarget: $(this)
        }, Klass.readElementConfig($source[0]), Klass.readElementConfig(this), config)
        new Klass($content, elemConfig).open event
        return
      $source
    current: ->
      all = @opened()
      all[all.length - 1] or null
    opened: ->
      klass = this
      pruneOpened()
      $.grep opened, (fl) ->
        fl instanceof klass
    close: ->
      cur = @current()
      if cur
        cur.close()
      return
    _onReady: ->
      Klass = this
      if Klass.autoBind

        ### First, bind click on document, so it will work for items added dynamically ###

        Klass.attach $(document), filter: Klass.autoBind

        ### Auto bound elements with attr-featherlight-filter won't work
           (since we already used it to bind on document), so bind these
           directly. We can't easily support dynamically added element with filters
        ###

        $(Klass.autoBind).filter('[data-featherlight-filter]').each ->
          Klass.attach $(this)
          return
      return
    _callbackChain:
      onKeyUp: (_super, event) ->
        if `27 == event.keyCode`
          if @closeOnEsc
            @$instance.find('.' + @namespace + '-close:first').click()
          false
        else
          _super event
      onResize: (_super, event) ->
        if @$content.naturalWidth
          w = @$content.naturalWidth
          h = @$content.naturalHeight

          ### Reset apparent image size first so container grows ###

          @$content.css('width', '').css 'height', ''

          ### Calculate the worst ratio so that dimensions fit ###

          ratio = Math.max(w / parseInt(@$content.parent().css('width'), 10), h / parseInt(@$content.parent().css('height'), 10))

          ### Resize content ###

          if ratio > 1
            @$content.css('width', '' + w / ratio + 'px').css 'height', '' + h / ratio + 'px'
        _super event
      afterContent: (_super, event) ->
        r = _super(event)
        @onResize event
        r
  $.featherlight = Featherlight

  ###bind jQuery elements to trigger featherlight ###

  $.fn.featherlight = ($content, config) ->
    Featherlight.attach this, $content, config

  ###bind featherlight on ready if config autoBind is set ###

  $(document).ready ->
    Featherlight._onReady()
    return
  return
) jQuery
