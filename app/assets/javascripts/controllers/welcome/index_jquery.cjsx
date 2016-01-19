$ ->
  $.ajax
    url: 'https://api.github.com/orgs/SBR2015/members'
    type:'GET'
    dataType: 'json'
    success: (data) ->
      line = ""
      for m_data in data
        img = "<img src=" + m_data.avatar_url + "/>"
        name = "<div id ='name'>" + m_data.login + "</div>"
        url = "<a href =" + m_data.html_url + ">" + img + name + "</a>"
        line += "<div id='profile-photo'>" + url + "</div>"
      $("#team-members").append(line)

    error: (XMLHttpRequest, textStatus, errorThrown) ->
      $("#team-info").append(m_info)
      console.log "error"
