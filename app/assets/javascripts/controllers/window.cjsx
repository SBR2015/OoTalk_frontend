React = require 'react'
ReactDOM = require 'react-dom'

Course = require './course/index.cjsx'
Lesson = require './lesson/index.cjsx'

$ ->
  ReactDOM.render(
    # <CommentBox />
    React.createElement(Lesson, null),
    document.getElementById('lesson-content')
  )

  ReactDOM.render(
    # <CommentBox />
    React.createElement(Course, null),
    document.getElementById('course-content')
  )
