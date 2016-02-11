request = require 'request'
User = require '../models/user'

class Authentication
  _email = ''
  _password = ''
  _password_confirmation = ''
  env = process.env.NODE_ENV || 'development'
  _confirm_success_url = if env == 'production' then 'https://ootalk.herokuapp.com/users/success' else 'http://localhost:3000/users/success'
  BASEURL = 'https://ootalkbackend.herokuapp.com/api/v1'

  constructor: (params = {}) ->
    _email = params.email
    _password = params.password
    _password_confirmation = params.password_confirmation
    _confirm_success_url = params.confirm_success_url

  sign_in: (callback) ->
    request.post {
      url: BASEURL + '/auth/sign_in'
      json: true
      form:
        email: _email
        password: _password
    },  (err, httpResponse, body) ->
      # サインイン成功時
      if httpResponse.statusCode == 200
        User.findOne { email: body.data.email }, (err, result) ->
          # エラー時
          if err
            return callback err
          # ユーザーが存在したとき
          if result
            return callback null, result, { message: 'login succeed' }
          # ユーザーが存在しないとき
          else
            # return callback null, false
            User.create {
              id: body.data.id
              email: body.data.email
              admin: body.data.admin
              headers:
                client: httpResponse.headers.client
                expiry: httpResponse.headers.expiry
                uid: httpResponse.headers.uid
                'access-token': httpResponse.headers['access-token']
                'token-type': httpResponse.headers['token-type']
            }, (err, result) ->
              if err
                console.log 'unsaved user = ' + body.data.email
                return callback err
              return callback null, result, { message: 'login succeed' }

      # サインイン失敗時
      else if httpResponse.statusCode == 401
        return callback null, false, { message: body.errors[0] }

  sign_up: (callback) ->
    request.post {
      url: BASEURL + '/auth'
      json: true
      form:
        email: _email
        password: _password
        password_confirmation: _password_confirmation
        confirm_success_url: _confirm_success_url
    },  (err, httpResponse, body) ->
      # サインアップ成功時
      if httpResponse.statusCode == 200
        console.log 'please confirmed on email'
        # return callback
      # サインアップ失敗時
      else if httpResponse.statusCode == 403
        console.log body.errors.full_messages[0]

      console.log '~~~~~~~~~~httpResponse is here~~~~~~~~~~~~~~~~'
      # console.log httpResponse.statusCode
    return

  sign_out: (callback) ->
    request.del {
      url: BASEURL + '/auth/sign_out'
      json: true
    }, (err, httpResponse, body) ->
      console.log httpResponse
    return

module.exports = Authentication
