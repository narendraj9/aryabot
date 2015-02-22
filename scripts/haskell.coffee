# Description:
#   Evaluate one line of Haskell
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot haskell <script> - Evaluate one line of Haskell
#
# Author:
#   edwardgeorge, slightly modified from code by jingweno

HASKELLJSON="1234567789"

module.exports = (robot) ->
  robot.respond /(haskell)\s+(.*)/i, (msg)->
    script = msg.match[2]
    msg.send script

    data = {
        'exp': script,
        'dataType': 'json'
    }

    robot.http("http://tryhaskell.org/eval")
      .headers(Cookie: "HASKELLJSON=#{HASKELLJSON}")
      .query(data)
      .post() (err, res, body) ->
        switch res.statusCode
          when 200

            # cookies? ? ?
            #if res.headers["set-cookie"]
            #  HASKELLJSON = res.headers["set-cookie"][0].match(/HASKELLJSON=([-a-z0-9]+);/)[1]

            result = JSON.parse(body)

            # debug
            msg.send JSON.stringify(result)

            if result.error
              msg.reply result.error
            else
              if result.result
                outputs = result.result.split("\n")
                for output in outputs
                  msg.reply output
              msg.reply result.type
          else
            msg.reply "Unable to evaluate script: #{script}. Request returned with the status code: #{res.statusCode}"
