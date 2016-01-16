React = require('react')
ReactDOM = require('react-dom')

Test = require('../../views/hoge/test')

window.onload = ( ->
  ReactDOM.render(
    # <CommentBox />
    React.createElement(Test, null),
    document.getElementById('test')
  )
)
