React = require 'react'
ReactDOM = require 'react-dom'

Course = require './course/index.cjsx'
LessonList = require './lesson/index.cjsx'
Lesson = require './lesson/show.cjsx'
TutorialButton = require './tutorial/show.cjsx'
TUTORIALS = ['Drag & Drop', 'Submit', 'Delete', 'Course']

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

  ReactDOM.render(
    # <CommentBox />
    React.createElement(TutorialButton, tuts: TUTORIALS),
    document.getElementById('tutorial-button')
  )

  console.log location.hash
