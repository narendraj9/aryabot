# Description:
# Stacy cares for everybody
# I intend to make stacy a little smarter than she is now.

module.exports = (robot) ->
    robot.hear /good(\s*)night/i, (msg) ->

        # generate a random number and say it 1/4 of the time
        say_it = msg.random [false, true, false, false]
        if say_it
            msg.send "goodnight! :)"

    robot.hear /anybody\s+there\s*?/i, (msg) ->
        # send Walter De' Lamere's poem [I don't care about the speeling.]
        msg.send "http://www.poetryfoundation.org/poem/177007"
        msg.send "Yes!"

    robot.hear /who\s+is\s+theKillingJoke\s*?/i, (msg) ->
    	# Based on the epic interaction between pranavk and akshika.
    	msg.send "I'm not theKillingJoke."
    	msg.send "You are theKillingJoke."

    robot.hear /logs\s*?\s*/i, (msg) ->
        # show logs url
        msg.send "Logs at: https://botbot.me/freenode/fpnith/"

    robot.hear /^I have gone mad. I need a break/i, (msg) ->
        msg.send "Go have some sleep narendra!"

    robot.hear /^\s*why\s+fp\s*?/i, (msg) ->
        msg.send "Tail recursion is its own reward."
        msg.send "https://xkcd.com/1270/"
