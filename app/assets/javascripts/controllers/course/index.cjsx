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
        @setState
          course: data
      ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        console.log errorThrown
      ).bind(this)

  render: ->
    return (
      <div id="course-list">
        { @state.course.map (c) ->
          <a key={ c.id } href={"/courses/" + c.id + "/lessons"}>
            <div>
              <i className="fa fa-book fa-3x" />
              <br /><br />{ c.title }
            </div>
          </a>
        }
      </div>
    )
module.exports = Course

# $(window).load ->
#   ReactDOM.render(
#       # <CommentBox />
#       # console.log("helooooooooooo"),
#       React.createElement(Course, null),
#       document.getElementById('course-content')
#       # console.log("2222222222222222222222222222222")
#
#   )
