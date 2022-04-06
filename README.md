# Brick Suspend Issue

This project demonstrates an issue I've discovered with suspending and
halting in Brick. 

This executable is a slight modification of Brick's demo program
brick-suspend-resume-demo. 

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


If you run this executable in Ubuntu, pressing SPACE once suspends and
pressing ESC once quits -- just like the original demo.

If you run this executable in MacOS Terminal, pressing SPACE or ESC
once isn't sufficient. You need to press another key afterward to make
the suspend or quit command register.

