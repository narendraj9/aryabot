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

# common function for respond and hear
eval_exp = (robot, msg)->
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

                        if result.success
                            value = result.success.value
                            type = result.success.type
                           
                            # send the expression's value and type to the channel
                            msg.send value
                            msg.send ("\nit :: " + type)
                            msg.send "\n"
                        else 
                            msg.send result.error
                    else
                        msg.reply "Unable to evaluate script: #{script}. Request returned with the status code: #{res.statusCode}"

module.exports = (robot) ->
  robot.respond /(haskell)\s+(.*)/i, (msg) -> eval_exp(robot, msg)
  robot.hear /(^>)\s+(.*)/i, (msg) -> eval_exp(robot, msg)
    
  
