start: check_location

# check_location #
    [unless insideTheMediaLab]
        speech: You need to be in the E14 lobby to begin.
    -- for testing purposes, we removed the actual Media Lab check
    -> headphone_check

# headphone_check #
    speech: Hi!

    [if headphones and not proximity]
        speech: "I'm glad you're already wearing headphones. I just need you to
            put your {device} in your pocket or your handbag. Don't worry,
            I'll wait for you."

    [if headphones is false and proximity is false]
        speech: "I need you to put on headphones, and then put your {device}
            in your pocket or handbag. Don't worry, I'll wait for you."

    -> take_the_elevator: [headphones and proximity]

# take_the_elevator #
    speech: Awesome. Now take the elevator to the fourth floor.
    -> fourth_floor: [altitude >= 11 and altitude <= 12]

# fourth_floor #
    speech: Welcome to the fourth floor!
    deadEnd

## went_down ##
    [altitude <= graph.previousChoice.predicate.altitude.gte]
    speech: "I didn't tell you to go back down!"

## bg_music ##
    [ graph.currentNodeId is check_location ]
    track: background
    mp3: SoWhat
