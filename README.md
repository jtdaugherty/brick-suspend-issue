# Brick Suspend Issue

This project demonstrates an issue I've discovered with suspending and
halting in [Brick](https://github.com/jtdaugherty/brick). 

This executable is a slight modification of Brick's demo program
[brick-suspend-resume-demo](https://github.com/jtdaugherty/brick/blob/master/programs/SuspendAndResumeDemo.hs). 

The only modification is to use the /dev/tty handle directly as
the configured `inputFd`:

    -- void $ defaultMain theApp initialState
    ttyHandle <- openFile "/dev/tty" ReadMode
    ttyFd <- IO.handleToFd ttyHandle
    defConfig <- V.standardIOConfig
    let builder = V.mkVty $ defConfig {
                    V.inputFd = Just ttyFd
                  }
    initialVty <- builder
    void $ customMain initialVty builder Nothing theApp initialState

Compile and run with:

    cabal run

If you compile and run this executable in the Ubuntu Terminal (tested
on Ubuntu 20.04), pressing SPACE once suspends and pressing ESC once
quits -- just like the original demo.

If you run this executable in the MacOS Terminal (macOS Montery, Apple
M1 Pro), pressing SPACE or ESC once isn't sufficient. You need to
press another key afterward to make the suspend or quit command
register. Is this bug, or is there something wrong with my Haskell
code?

