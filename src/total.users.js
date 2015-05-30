// Generated by CoffeeScript 1.9.2
var Keen, client, config, query;

Keen = require('keen.io');

config = require('./config');

client = Keen.configure({
  projectId: config.keen_project_id,
  readKey: config.keen_readkey,
  writeKey: config.keen_writekey
});

query = new Keen.Query('count', {
  eventCollection: 'agh3',
  timeframe: 'previous_550_days',
  interval: 'monthly',
  groupBy: 'remark'
});

client.run(query, function(err, res) {
  var i, item, len, ref, total_user;
  if (err) {
    return console.log(err);
  }
  total_user = 0;
  ref = res.result;
  for (i = 0, len = ref.length; i < len; i++) {
    item = ref[i];
    total_user += item.value[0]['result'];
    console.log(item.timeframe['end'] + ", " + total_user);
  }
});
