#  Project: Chips jQuery 
#  Description: JQuery CoffeeScript plugin for tagging items
#  Author: James Baer
#
#  Version: 1.0


do($ = window.jQuery, window) ->
  NAME = 'chips'
  DATA_KEY = NAME
  JQUERY_NO_CONFLICT = $.fn[NAME]
  EVENT_KEY = ".#{ DATA_KEY }"
  ENTER_KEYCODE = 13

  Events =
    CLICK: "click#{ EVENT_KEY }",
    FOCUSIN: "focusin#{EVENT_KEY}",
    FOCUSOUT: "focusout#{EVENT_KEY}",
    KEYDOWN_ADD: "keydown.add#{ EVENT_KEY }",
    CHIP_ADD: "chips.add",
    CHIP_REMOVE: "chips.remove",

  Selectors =
    CHIPS: '.chips',
    CHIP: '.chip',
    CHIP_NAME: '.chip-name',
    INPUT: 'input',
    DELETE: '.close'

  Classes =
    FOCUS: 'focus',


  class Chips
    constructor: (@_element, @_options) ->
      this._init()
      this._addEventListeners()

    add: (value) ->
      return if not @_isValid(value)

      chipHtml = @_renderChip(value)
      $(chipHtml).insertBefore($(@_element).find(Selectors.INPUT))

      addEvent = $.Event(Events.CHIP_ADD, [])
      $(@_element).trigger(addEvent)

    remove: (chip) ->
      chip.remove()
      removeEvent = $.Event(Events.CHIP_REMOVE)
      $(@_element).trigger(removeEvent)

    _init: ->
      $(@_element).append(@_options.input_template)
      @_setPlaceholder()

    _setPlaceholder: ->
      $(@_element).find(Selectors.INPUT).prop('placeholder', @_options.placeholder)

    _addEventListeners: ->
      $(@_element).on Events.KEYDOWN_ADD, (event) =>
        target = event.target

        if event.which is ENTER_KEYCODE
          event.preventDefault()
          @add($(target).val())
          $(target).val('')

      $(@_element).on Events.CLICK, Selectors.DELETE, (event) =>
        target = event.target
        chips = target.closest(Selectors.CHIPS)
        chip = target.closest(Selectors.CHIP)

        event.stopPropagation()
        @remove(chip)
        $(@_element).find(Selectors.INPUT).focus()

      $(@_element).on Events.FOCUSIN, (event) ->
        currentChips = $(event.target).closest(Selectors.CHIPS)
        currentChips.addClass(Classes.FOCUS)

      $(@_element).on Events.FOCUSOUT, (event) ->
        currentChips = $(event.target).closest(Selectors.CHIPS)
        currentChips.removeClass(Classes.FOCUS)

      $(@_element).on Events.CLICK, (event) ->
        $(event.target).find(Selectors.INPUT).focus()

    _renderChip: (value) ->
      html = $.parseHTML(@_options.chip_template)
      $(html).find(Selectors.CHIP_NAME).text(value)
      return html

    _isValid: (value) ->
      return if value is ''

      exists = false
      $(@_element).find(Selectors.CHIP).each ->
        chip_name = $(this).find(Selectors.CHIP_NAME).text()
        if chip_name.toLowerCase() is value.toLowerCase()
          exists = true

      return not exists

    @defaults: ->
      {
        chip_template:  '<div class="chip">' +
                        '<span class="chip-name"></span>' +
                        '<button type="button" class="close">' +
                        '<span>&times;</span></button></div> ',
        input_template: '<input type="text" placeholder="">',
        placeholder: '+Tag',
      }

    @_jQueryPlugin: (config) ->
     @each ->
      data = $(this).data(DATA_KEY)

      options = $.extend({}, Chips.defaults(), config)

      if not data
        data = new Chips(@, options)
        $(this).data(DATA_KEY, data)

      if typeof config is 'string'
        data[config].call(@)

  $.fn[NAME] = Chips._jQueryPlugin
  $.fn[NAME].Constructor = Chips

  $.fn[NAME].noConflict = ->
    $.fn[NAME] = JQUERY_NO_CONFLICT
    Chips._jQueryPlugin

