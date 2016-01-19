React = require('react')
ReactDOM = require('react-dom')

Course = require('../../views/course/index')
URL = "https://ootalkbackend.herokuapp.com/api/v1/courses.json"

window.onload = ( ->
  ReactDOM.render(
    # <CommentBox />
    React.createElement(Course, null),
    document.getElementById('course-content')
  )
)
