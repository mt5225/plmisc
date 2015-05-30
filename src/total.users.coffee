Keen = require 'keen.io'
config = require './config'

client = Keen.configure(
  projectId: config.keen_project_id
  readKey: config.keen_readkey
  writeKey: config.keen_writekey)

query = new (Keen.Query)('count',
  eventCollection: 'agh3'
  timeframe: 'previous_550_days'
  interval: 'monthly'
  groupBy: 'remark')

client.run query, (err, res) ->
  if err 
    return console.log(err)
  # response.result
  total_user = 0
  for item in res.result
    total_user += item.value[0]['result']
    console.log  "#{item.timeframe['end']}, #{total_user}"
  return
  