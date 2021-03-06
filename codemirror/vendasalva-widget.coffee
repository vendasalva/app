CodeMirror = require 'codemirror'

delegator = require('../setup').delegator

CodeMirror.defineMode 'vendasalva', require('./mode.coffee')
CodeMirror.defineExtension 'show-hint', require('./show-hint.js')(CodeMirror)
class CodeMirrorWidget
  type: 'Widget'
  constructor: (initialText, properties) ->
    @text = initialText
    @properties = properties
  init: ->
    elem = document.createElement 'div'
    elem.addEventListener 'DOMNodeInsertedIntoDocument', (e) =>
      @cm = CodeMirror elem, {
        mode: 'vendasalva'
        theme: 'blackboard'
        value: @text
      }
      @cm.focus()

      # autocompletion
      @cm.on 'keyup', (editor, e) =>
        e.preventDefault()
        return if editor.state.completionActive
        editor.showHint({
          hint: require('./hint-vendasalva.coffee')
          completeSingle: false
          completeOnSingleClick: true
        })

      # hooks to virtual-dom dom-delegated 'change' event
      if 'ev-change' of @properties
        delegator.addEventListener elem, 'change', @properties['ev-change']

        for happening in ['changes', 'blur', 'scroll', 'focus']
          @cm.on happening, (cm, ev) =>
            event = new CustomEvent 'change', 'detail': {cm: cm, ev: ev}
            elem.dispatchEvent event

    return elem
  update: (prev, elem) ->
    cm = @cm or prev.cm
    if cm and cm.getValue() != @text
      cm.setValue @text
      cm.focus()

module.exports = CodeMirrorWidget
