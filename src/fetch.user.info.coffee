https = require 'https'
fs = require 'fs'
accesskey = require('./accesskey').accesskey
config = require './config'
keenio = require 'keen.io'
keenclient = keenio.configure(
  projectId: config.keen_project_id
  writeKey: config.keen_writekey
)



#get user info
accesskey.getKey (access_token) ->
  console.log "AccesKey =  " + access_token
  getUserList = do ->
    console.log "==> get openid list <=="
    options =
      host: 'api.weixin.qq.com'
      port: 443
      path: "/cgi-bin/user/get?access_token=#{access_token}"
      method: 'GET'
      headers: accept: '*/*'
    req = https.request options, (res) ->
      body = ''
      res.on 'data', (d) ->
        body = body + d

      res.on 'end', ->
        console.log "===> USER DATA <=== "
        data = JSON.parse body
        console.log "Number of users = " + data['count']
        openidArray = data['data']['openid']
        numberOfRecord = 0
        callAPI = (openidList) ->
          openid = openidList.shift()
          options.path = "/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}"
          req = https.request options, (res) ->
            body = ''
            res.on 'data', (d) ->
              body = body + d

            res.on 'end', ->
              try
                data = JSON.parse body
                #console.log data
                dt = new Date(parseInt(data.subscribe_time)*1000)
                data.keen = { "timestamp" : dt.toISOString() }
                keenclient.addEvent 'agh3', data, (err, res) ->
                  if err
                   # there was an error!
                    console.log err
                  else
                    console.log res
              catch err
                console.log err
              finally
                if openidArray.length
                  console.log "numberOfRecord = #{numberOfRecord}"
                  numberOfRecord += 1
                  callAPI(openidList)
                
          req.end()

        callAPI(openidArray)


    req.end()
          