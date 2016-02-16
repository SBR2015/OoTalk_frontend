React = require 'react'
ReactDOM = require 'react-dom'

TutorialButton = React.createClass
  handleClick: (i) ->
    tut = @props.tuts[i]
    video_url = @props.videos[i]
    console.log "Tutorial: " + tut
    Test = React.createClass
      render: ->
        <iframe width="700" height="400" src={ video_url }></iframe>
    ReactDOM.render(
      React.createElement(Test, null),
      document.getElementById('tutorial-video')
    )

  render: ->
    return (
      <div>
      {
        @props.tuts.map ((tut, i) ->
          return (
            # <div onClick={ @handleClick.bind(this, i) }>{ tut }</div>
            <div key={ i } onClick={ @handleClick.bind(this, i) }>{ tut }</div>
          )
        ),this
      }
      </div>
    )


module.exports = TutorialButton
