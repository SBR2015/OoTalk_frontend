React = require('react')
ReactDOM = require('react-dom')

URL = "https://ootalkbackend.herokuapp.com/api/v1/courses.json"

Course = React.createClass
  getInitialState: ->
    course: []

  componentDidMount: ->
    # obj = []
    # request.get {
    #   url: "https://ootalkbackend.herokuapp.com/api/v1/courses.json"
    #   json: true
    #   }, (err, httpResponse, body) ->
    $.ajax
      url: URL
      type:'GET'
      dataType: 'json'
      success: ((data) ->
        title = []
        for d in data
          title.push d.title
        @setState
          course: title
      ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        console.log errorThrown
      ).bind(this)

  render: ->
    return (
      <div id="course-list">
        { @state.course.map (c, i) ->
          <div key={i}>
            <i className="fa fa-book fa-3x" />
            <br /><br />{ c }
          </div>
        }
      </div>
      # <div><i className="fa fa-book"></i></div>
    )

# $ ->
#   ReactDOM.render(
#     # <CommentBox />
#     React.createElement(Course, null),
#     document.getElementById('course-content')
#   )
