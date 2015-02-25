# Description:
# Stacy cares for everybody
# I intend to make stacy a little smarter than she is now.

module.exports = (robot) ->
    robot.hear /good(\s*)night/i, (msg) ->

        # generate a random number and say it 1/4 of the time
        say_it = msg.random [false, true, false, false]
        if say_it
            msg.send "goodnight! :)"
