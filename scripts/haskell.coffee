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
  value_str = ""
  type_str = ""
  stdout_str = ""
  err_str = ""
  rest_str = ""

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
            if say_value
              value_str = (value + "\n")
            if (say_type or value == "")
              type_str = ("\nit :: " + type + "\n")
            if result.success.stdout
              stdout_str = (result.success.stdout + "\n")
             
          else if result.error
            err_str = result.error
          else 
             rest_str = ":-( No one ever told me how to evaluate this!"


        else
          rest_str = "Unable to evaluate script: #{script}. Request returned with the status code: #{res.statusCode}"

      return "#{value_str}#{type_str}#{stdout_str}#{rest_str}" 

module.exports = (robot) ->
  robot.respond /(haskell)\s+(.*)/i, (msg) -> msg.send (eval_exp(robot, msg))

  # get it on hearing > or @type.
  robot.hear /(^@type)\s+(.*)/i, (msg) -> msg.send (eval_exp(robot, msg, false, true))
  robot.hear /(^>)\s+(.*)/i, (msg) -> msg.send (eval_exp(robot, msg))
  
  # also respond to them in private messages.
  robot.respond /(^@type)\s+(.*)/i, (msg) -> msg.reply (eval_exp(robot, msg, false, true))
  robot.respond /(^>)\s+(.*)/i, (msg) -> msg.reply (eval_exp(robot, msg))
  
