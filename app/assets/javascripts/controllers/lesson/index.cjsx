React = require('react')
ReactDOM = require('react-dom')

BASEURL = "https://ootalkbackend.herokuapp.com/api/v1"

LessonList = React.createClass
  getInitialState: ->
    course: ""
    lessons: []

  componentDidMount: ->
    $.ajax
      url: BASEURL + location.pathname
      type:'GET'
      dataType: 'json'
      success: ((data) ->
        @setState
          course: data.course.title
          lessons: data.lessons
      ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        console.log errorThrown
      ).bind(this)

  render: ->
    return (
      <div id="lesson-list">
        <h2><i className="fa fa-book fa-2x" /><span>{ @state.course }</span></h2>
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
