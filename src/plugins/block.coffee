#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget 'IKS.halloblock',
    options:
      editable: null
      toolbar: null
      uuid: ''
      elements: [
        'h1'
        'h2'
        'h3'
        'p'
        'pre'
        'blockquote'
      ]

    _create: ->
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      buttonset.append target
      buttonset.append @_prepareButton target
      @options.toolbar.append buttonset

    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id=\"#{contentId}\"></div>"

      addElement = (element) =>
        el = jQuery "<#{element}>#{element}</#{element}>"
        el.bind 'click', =>
          @options.editable.execute 'formatBlock', element.toUpperCase()

        queryState = (event) =>
          block = document.queryCommandValue 'formatBlock'
          if block.toLowerCase() is element
            el.addClass 'selected'
            return
          el.removeClass 'selected'

        @options.editable.element.bind 'halloenabled', =>
          @options.editable.element.bind 'keyup paste change mouseup', queryState
        @options.editable.element.bind 'hallodisabled', =>
          @options.editable.element.bind 'keyup paste change mouseup', queryState

        el
      for element in @options.elements
        contentArea.append addElement element
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: 'block'
        icon: 'icon-text-height'
        target: target
      buttonElement

)(jQuery)
