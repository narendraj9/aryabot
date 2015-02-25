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
# value: boolean flag tell whether to print value
# type: whether print type or not
eval_exp = (robot, msg, say_value=true, say_type=false) ->
  script = msg.match[2]

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
            stdout = result.succes.stdout
            
            # send the expression's value and type to the channel
            if say_value
              msg.send (value + "\n")
            if (say_type or value == "")
              msg.send ("\nit :: " + type + "\n")
            if stdout
              msg.send (stdout ++ "\n")
             
          else if result.error
            msg.send result.error
          else 
            msg.send ":-( No one ever told me how to evaluate this!"

        else
          msg.reply "Unable to evaluate script: #{script}. Request returned with the status code: #{res.statusCode}"

module.exports = (robot) ->
  robot.respond /(haskell)\s+(.*)/i, (msg) -> eval_exp(robot, msg)

  # get it on hearing > or @type.
  robot.hear /(^@type)\s+(.*)/i, (msg) -> eval_exp(robot, msg, false, true)
  robot.hear /(^>)\s+(.*)/i, (msg) -> eval_exp(robot, msg)
  
  # also respond to them in private messages.
  robot.respond /(^@type)\s+(.*)/i, (msg) -> eval_exp(robot, msg, false, true)
  robot.respond /(^>)\s+(.*)/i, (msg) -> eval_exp(robot, msg)
  
