React = require 'react'
ReactDOM = require 'react-dom'

TutorialButton = React.createClass
  handleClick: (i) ->
    tut = @props.tuts[i]
    console.log "Tutorial: " + tut
    Test = React.createClass
      render: ->
        <video controls autoPlay src="https://s3.amazonaws.com/f.cl.ly/items/0W3o0X1N3O2V0G051L2Y/Screen%20Recording%202016-02-03%20at%2004.30%20PM.mov"></video>
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
