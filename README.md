daisy-bell
==========

>*"My instructor was Mr. Langley, and he taught me to sing a song. If you'd like to hear it I can sing it for you..."*


Computer performances of Daisy Bell have marked several significant milestones in computer audio synthesis. Consequently, this repository aims to demonstrate implementations of synthesis (realtime or otherwise) of Daisy Bell in a variety of languages/platforms.

### Score
In its most basic form, the score of Daisy Bell can be represented by two vectors, where one vector gives the pitch of each respective note, and the other vector gives note durations. Consequently, when pitch is represented by MIDI notes and note duration by quarter note multiples, the following data suffices:

	# PITCH
    74, 71, 67, 62, 64, 66, 67, 64, 67, 62,
    69, 74, 71, 67, 64, 66, 67, 69, 71, 69,
    71, 72, 71, 69, 74, 71, 69, 67, 69, 71, 67, 64, 67, 64, 62,
    62, 67, 71, 69, 67, 71, 69, 71, 72, 74, 71, 67, 69, 62, 67
    # DURATION
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
    3,  3,  3,  3,  1,  1,  1,  2,  1,  6,
    1,  1,  1,  1,  2,  1,  1,  4,  1,  2,  1,  2,  1,  1,  5,
    1,  2,  1,  2,  2,  1,  1,  1,  1,  1,  1,  1,  2,  1,  5


