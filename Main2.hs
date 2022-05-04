module Main where

import Control.Monad (forever)
import GHC.Conc (threadWaitRead)
import System.IO (openFile, stdin, IOMode(..), BufferMode(..), hSetBuffering)
import System.Posix (FdOption(..), setFdOption, fdRead, handleToFd)
import System.Exit (exitFailure)
import System.Environment (getArgs)

main :: IO ()
main = do
    args <- getArgs
    handle <- case args of
        ["stdin"] -> return stdin
        ["tty"]   -> openFile "/dev/tty" ReadMode
        _         -> putStrLn "Usage: minimal <stdin|tty>" >> exitFailure

    hSetBuffering handle NoBuffering
    ttyFd <- handleToFd handle
    setFdOption ttyFd NonBlockingRead False

    forever $ do
        putStrLn "Calling threadWaitRead"
        threadWaitRead ttyFd
        putStrLn "Calling fdRead"
        (b, _) <- fdRead ttyFd 16
        putStrLn $ "read: " <> show b
