
window.codeutil =
  getParameterByName: (name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    #url取得
    results = regex.exec(location.search)
    if results is null
      null
    else
      decodeURIComponent(results[1].replace(/\+/g, " "))

  syntaxHighlight: (json) ->
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
    return json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
      cls = 'number'
      if /^"/.test match
        if /:$/.test match
          cls = 'key'
        else
          cls = 'string'
      else if /true|false/.test match
        cls = 'boolean'
      else if /null/.test match
        cls = 'null'
      return '<span class="' + cls + '">' + match + '</span>'

  generate_syntax_element: (l) ->
    $('<div></div>',
          class: "ui-widget-content" + " " + l.class_name + " syntax"
          class_name: l.class_name
          string: l.string
          'data-toggle': 'popover'
          'data-trigger': 'hover'
          title: l.name
          'data-content': l.description).text(l.symbol)

  initSyntax: ->
    for item in document.cookie.split("; ")
      kv = item.split('=')
      if kv[0] is 'locale'
        lang = kv[1]
        break
    
    # URL = "http://127.0.0.1:3000/api/v1/abstractsyntax/"
    URL = "https://ootalk-syntax-list.herokuapp.com/"
    LANG = lang ? "en"
    $.get URL + LANG, null, (lists) =>
      abstract_syntax_lists = $("#abstract_syntax_lists")
      this.syntaxList = lists
      for l in lists
        line = codeutil.generate_syntax_element(l)
        # 使えるbuttonを追加
        abstract_syntax_lists.append(line)
        $('[data-toggle="popover"]').popover()
        codeui.enDraggable $('#abstract_syntax_lists div')

      $('#input_code').empty()
      code = localStorage.getItem("auto_saved_code")
      $("#input_code").append($(code))

      #各elemenの入れ子
      $("div.child-line").each(
        ()->
          codeui.enDraggable $(this)

          $(this).droppable
            tolerance: "pointer"
            #入れ子にelement一個しか入らない
            accept: ($element) ->
              return true if $(this).children().length < 1 && $element.parent().attr('id') is 'abstract_syntax_lists'
            hoverClass: "ui-state-hover"
            drop: (event, ui) ->
              $(this).append(codeui.clone_dragged(ui))
              $("#input_code").droppable('enable')
              localStorage.setItem("auto_saved_code", $("#input_code").html())
            #２度ドロップを防ぐ
            over: (event, ui) ->
              $("#input_code").droppable('disable')

          $(this).sortable
            connectWith: '#input_code'
      )

  childProgram: (prog) ->
    node = null
    for syntax in codeutil.syntaxList
      if prog[syntax.class_name]
        node = codeutil.generate_syntax_element(syntax)
        for s in syntax.string.split("\t")
          if s is "@left" or s is "@right"
            if prog[syntax.class_name]['Left']
              child_node = codeutil.childProgram(prog[syntax.class_name]['Left'])
              node.append(child_node)
            if prog[syntax.class_name]['Right']
              child_node = codeutil.childProgram(prog[syntax.class_name]['Right'])
              node.append(child_node)
            if prog[syntax.class_name]['Middle']
              child_node = codeutil.childProgram(prog[syntax.class_name]['Middle'])
              node.append(child_node)
            else
              child_node = codeui.generate_child_node(node, s)
              node.append(child_node)
          else
            child_node = codeui.generate_child_node(node, s)
            node.append(child_node)
        break
    node

  reverseTreeNode: (obj) ->
    results = []
    for code in obj
      program = code['Program']
      results.push codeutil.childProgram(program)
    results

  executeRequest: (params) ->
    $.ajax 'https://ootalkbackend.herokuapp.com/api/v1/execute',
      type: 'POST'
      dataType: 'json'
      data : params
      timeout: 10000
      success: (data) ->
        #    $('#output_code').html syntaxHighlight JSON.stringify(data, undefined, 4)
        headline_text = '<table class = "table table-hover"><thead><tr><th></td><th>' + 'Excute Code' + '</th><th>' + 'Excute Result' + '</th></tr></thead><tbody></tbody></table>'
        $('#output_code').append(headline_text)
        for d, i in data
          line_text = '<tr><th>' + (i+1).toString() + '</th><td>' + d['exec'] + '</td><td>' + d['result'] + '</td></tr>'
          $('#output_code table tbody').append(line_text)
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        alert(textStatus)
