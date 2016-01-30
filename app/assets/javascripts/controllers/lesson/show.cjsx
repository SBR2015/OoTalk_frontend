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
        console.log data
        @setState
          lesson: data
          body: Markdown.toHTML(data.body)
      ).bind(this)
      error: ((XMLHttpRequest, textStatus, errorThrown) ->
        console.log errorThrown
      ).bind(this)

  render: ->
    return (
      # <div>
      #   adjakdjak
      #   <h2>{ @state.lesson.title }</h2>
      #   <p dangerouslySetInnerHTML={{ __html: @state.body }} />
      # </div>
      # <div id="lesson-list">
      #   { @state.lessons.map (l) ->
      #     <a key={ l.id } href={ location + "/" + l.id }>
      #       <div key = { l.id }>
      #         <i className="fa fa-file-text fa-2x" />
      #         { l.title }
      #       </div>
      #     </a>
      #   }
      # </div>
      # <div><i className="fa fa-book"></i></div>

      # <div>abc</div>
      <div>
        <h2>{ @state.lesson.title }</h2>
        <p dangerouslySetInnerHTML={{ __html: @state.body }} />
      </div>
    )

module.exports = Lesson
