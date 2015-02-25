# Description:
# Stacy cares for everybody
# I intend to make stacy a little smarter than she is now.

module.exports = (robot) ->
    robot.hear /good(\s*)night/i, (msg) ->
        msg.send "goodnight! :)"
