React = require('react')
ReactDOM = require('react-dom')
Markdown = require('markdown').markdown

BASEURL = "https://ootalkbackend.herokuapp.com/api/v1"

Lesson = React.createClass
  getInitialState: ->
    lesson: ""
    body: ""

  componentDidMount: ->
    $.ajax
      url: BASEURL + location.pathname + ".json"
      type:'GET'
      dataType: 'json'
      success: ((data) ->
        @setState
          lesson: data
          body: Markdown.toHTML(data.body)
      ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        console.log errorThrown
      ).bind(this)

  render: ->
    return (
      <div>
        <h2>{ @state.lesson.title }</h2>
        <p dangerouslySetInnerHTML={{ __html: @state.body }} />
      </div>
    )

module.exports = Lesson
