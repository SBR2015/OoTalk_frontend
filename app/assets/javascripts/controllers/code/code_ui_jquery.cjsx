# Author: Linh, Ounenhei, yuchan, Tsukasa Arima, Olivia

ootalk = require 'OoTalk-js'

window.codeui =
  generate_child_node: (parent, s) ->
    child_line = $('<div></div>').text(s).attr('class', 'plain')
    if s.charAt(0) is "@"
      $(child_line).attr('class_name', s.charAt(1).toUpperCase() + s.slice(2)).attr('class', "child-line")
      #コンスタントの処理
      if (parent.attr("class_name") is "Constant") or (parent.attr("class_name") is "Variable")
        consInput = $("<input class='child-line-input' placeholder='@value'>").css
          height: "25px"
          width: "70px"
          "background-color": "lightpink"
          color: "white"
        consInput
        .focus ->
          $(this).css
            "background-color": "#f5f5f5"
            color: "black"
        .change ->
          $(this).attr('value', $(this).val())

        $(child_line).css(padding: "0px")
        $(child_line).text('').append(consInput)
        $(child_line).removeClass('child-line')

    child_line

  clone_dragged: (ui) ->
    clone_drag = $(ui.draggable).clone()
    clone_string = clone_drag.attr('string')
    this_string = clone_string
    if typeof clone_string isnt 'undefined' then clone_string else null

    # もう既に子がいればbreak
    return if this_string is null

    clone_drag.text('')

    for s in this_string.split('\t')
      child_line = codeui.generate_child_node(ui.draggable, s)
      if s.charAt(0) is "@"
        #各elemenの入れ子
        $(child_line).droppable
          tolerance: "pointer"
          #入れ子にelement一個しか入らない
          accept: ($element) ->
            return true if $(this).children().length < 1 && $element.parent().attr('id') is 'abstract_syntax_lists'
          hoverClass: "ui-state-hover"
          drop: (event, ui) ->
            $(this).append(codeui.clone_dragged(ui))
            $("#input_code").droppable('enable')
            localStorage.setItem("auto_saved_code", $("#input_code").html())
            current_height = $("#input_code").outerHeight()
            $('#trash-can').css("height", current_height + "px")
          #２度ドロップを防ぐ
          over: (event, ui) ->
            $("#input_code").droppable('disable')

      $(child_line).sortable
        connectWith: '#input_code'
      $(clone_drag).append(child_line)

    return clone_drag

  createNode: (childnode, className, operand) ->
    hasClass = false
    if className is null
      return null

    if operand is 'Left' or operand is 'Right'
      hasClass = true
    else
      for list in codeutil.syntaxList
        if list.class_name is className
          hasClass = true
          break

    if hasClass
      leftValue = null
      rightValue = null
      if ($(childnode).attr("class_name")) is 'Constant'
        leftValue = parseInt($($(childnode).find("input")[0]).val())
      else if ($(childnode).attr("class_name")) is 'Variable'
        leftValue = $($(childnode).find("input")[0]).val()
      else
        for n in $(childnode).children()
          if $(n).attr("class_name") is 'Left'
            for _n in $(n).children()
              leftValue = codeui.createNode(_n, $(_n).attr("class_name"), 'Left')
          else if $(n).attr("class_name") is 'Right'
            for _n in $(n).children()
              rightValue = codeui.createNode(_n, $(_n).attr("class_name"), 'Right')

      node = ootalk.newNode(className, leftValue, rightValue)
      return node

    return null

  # Drag初期化
  enDraggable: (obj) ->
    obj.draggable
      appendTo: "body"
      helper: "clone"
      start: (event, ui) ->
        $(ui.helper).addClass("ui-draggable-helper")
        console.log "start drag"
      drag: (event, ui) ->
        console.log "while drag"
      stop: (event, ui) ->
        console.log "stop drag"
    obj

  initNode: ->
    ootalk.init()

  treeNode: ->
    ootalk.tree()

  createTreeNode: (parent, parentnodeid) ->
    children = parent.children()
    node = null
    for childnode in children
      className = $(childnode).attr "class_name"
      node = codeui.createNode childnode, className
      if node
        if parent.attr('id') is 'input_code'
          ootalk.append(node)
        codeui.createTreeNode($(childnode), node.nodeid)
      else
        codeui.createTreeNode($(childnode))
