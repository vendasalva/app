Titulo = require('titulo').toLaxTitleCase

sendClick = require 'value-event/click'

{div, span, pre, nav,
 small, i, p, a, button,
 h1, h2, h3, h4,
 form, legend, fieldset, input, textarea, select,
 table, thead, tbody, tfoot, tr, th, td,
 ul, li} = require 'virtual-elements'

vrenderSearchResults = (searchResultsState, channels) ->
  (ul id: 'search',
    (li {},
      (a
        href: '#'
        'ev-click': sendClick channels.forceSearch, r.ref
      , r.ref)
    ) for r in searchResultsState.results if searchResultsState.results.length >= 7
    (vrenderItem searchResultsState, channels, item) for item in searchResultsState.results if searchResultsState.results.length < 7
  )

vrenderItem = (searchResultsState, channels, itemData) ->
  (div className: 'item',
    #(div {},
    #  (div className: 'col-md-3',
    #    (div className: 'display-box',
    #      (h3 {className: 'box-label'}, 'EM ESTOQUE')
    #      (h2 {className: 'box-value'}, '' + itemData.stock)
    #    ) if itemData.stock
    #  )
    #  (div className: 'col-md-3',
    #    (div className: 'display-box',
    #      (h3 {className: 'box-label'}, 'R$')
    #      (h2 {className: 'box-value'}, Reais.fromInteger itemData.price)
    #    ) if itemData.price
    #  )
    #)
    (h1 className: 'col-md-4', Titulo itemData.name)
    (div className: 'col-md-8',
      (table className: 'events table table-stripped table-bordered table-hover',
        (thead {},
          (tr {},
            (th {}, 'Dia')
            (th {}, 'Q')
            (th {}, 'R$')
            (th {})
          )
        )
        (tbody {},
          (tr className: (if event.compra then 'success' else ''),
            (td {},
             (a
               href: "##{event.id}"
               value: event.id
               'ev-click': sendClick channels.goToDay, event.id
             , event.day)
            )
            (td {}, '' + event.q + ' ' + event.u)
            (td {}, Reais.fromInteger(event.p, 'R$ ') + ' por ' + event.u)
            (td {}, if event.compra then '(compra)' else '')
          ) for event in itemData.events
        )
      )
    )
  )

module.exports = vrenderSearchResults
