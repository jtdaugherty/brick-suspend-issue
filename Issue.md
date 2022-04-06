# Brick Suspend Issue

This [github project](https://github.com/danchoi/brick-suspend-issue) demonstrates an issue I've discovered with suspending and halting in [Brick](https://github.com/jtdaugherty/brick). 

I modified Brick's demo program [brick-suspend-resume-demo](https://github.com/jtdaugherty/brick/blob/master/programs/SuspendAndResumeDemo.hs) to use the /dev/tty handle directly as the configured `inputFd`:

    -- void $ defaultMain theApp initialState
    ttyHandle <- openFile "/dev/tty" ReadMode
    ttyFd <- IO.handleToFd ttyHandle
    defConfig <- V.standardIOConfig
    let builder = V.mkVty $ defConfig {
                    V.inputFd = Just ttyFd
                  }
    initialVty <- builder
    void $ customMain initialVty builder Nothing theApp initialState

The reason I wanted to do this was so I can use data piped in through STDIN into a Brick program. Because the `inputFd` is assigned to `stdin` by default, I need it to be reassigned to `/dev/tty` in order to make the terminal UI interactive.

If you compile and run my demo executable in the Ubuntu Terminal (tested on Ubuntu 20.04), pressing SPACE once suspends and pressing ESC once quits -- just like the original demo.

If you run the executable in the MacOS Terminal (macOS Montery, Apple M1 Pro), pressing SPACE or ESC once isn't sufficient. You need to press another key afterward to make the suspend or quit command register. Is this bug, or is there something wrong with my Haskell code?


