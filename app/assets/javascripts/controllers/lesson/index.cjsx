React = require('react')
ReactDOM = require('react-dom')

BASEURL = "https://ootalkbackend.herokuapp.com/api/v1"

LessonList = React.createClass
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
          <a key={ l.id } href={ location + "/" + l.id }>
            <div key = { l.id }>
              <i className="fa fa-file-text fa-2x" />
              { l.title }
            </div>
          </a>
        }
      </div>
    )

module.exports = LessonList
