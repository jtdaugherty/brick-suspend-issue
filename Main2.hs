module Main where

import Control.Monad (void, forever, forM_)
import Control.Concurrent (threadDelay, forkIO)
import GHC.Conc
import System.IO
import System.Posix
import System.Posix.IO

threadBody :: Fd -> IO ()
threadBody fd = forever $ do
    putStrLn "Calling threadWaitRead"
    threadWaitRead fd
    putStrLn "Calling fdRead"
    (b, _) <- fdRead fd 1
    putStrLn $ "read: " <> show b

main :: IO ()
main = do
    -- Approach 1:
    hClose stdin
    ttyHandle <- openFile "/dev/tty" ReadMode
    ttyFd <- handleToFd ttyHandle

    -- Approach 2:
    -- ttyFd <- handleToFd stdin

    setFdOption ttyFd NonBlockingRead False

    forkIO (threadBody ttyFd)
    threadDelay $ 100 * 1000 * 1000
