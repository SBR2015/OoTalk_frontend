React = require('react')
ReactDOM = require('react-dom')

BASEURL = "https://ootalkbackend.herokuapp.com/api/v1"

Lesson = React.createClass
  getInitialState: ->
    lessons: []

  componentDidMount: ->
    $.ajax
      url: BASEURL + location.pathname
      type:'GET'
      dataType: 'json'
      success: ((data) ->
        @setState
          lessons: data
      ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        console.log errorThrown
      ).bind(this)

  render: ->
    return (
      <div id="lesson-list">
        { @state.lessons.map (l) ->
          <div key = { l.id }>
            <i className="fa fa-file-text fa-2x" />
            { l.title }
          </div>
        }
      </div>
      # <div><i className="fa fa-book"></i></div>
    )

# addLoadEvent = (func) ->
#   oldonload = window.onload
#   if typeof window.onload != 'function'
#     window.onload = func
#   else
#     window.onload = ->
#       if oldonload
#         oldonload()
#       func()
#       return
#   return
#
# addLoadEvent ( ->
#   ReactDOM.render(
#     # <CommentBox />
#     React.createElement(Lesson, null),
#     document.getElementById('lesson-content')
#   )
# )

module.exports = Lesson
