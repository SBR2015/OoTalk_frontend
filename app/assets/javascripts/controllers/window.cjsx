React = require 'react'
ReactDOM = require 'react-dom'

Course = require './course/index.cjsx'
LessonList = require './lesson/index.cjsx'
Lesson = require './lesson/show.cjsx'

$ ->
  ReactDOM.render(
    # <CommentBox />
    React.createElement(LessonList, null),
    document.getElementById('lesson')
  )

  ReactDOM.render(
    # <CommentBox />
    React.createElement(Course, null),
    document.getElementById('course')
  )

  ReactDOM.render(
    # <CommentBox />
    React.createElement(Lesson, null),
    document.getElementById('lesson-content')
  )
