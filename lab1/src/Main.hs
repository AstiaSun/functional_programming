module Main where

import Database.HDBC
import Database.HDBC.PostgreSQL (connectPostgreSQL)
import Output

main :: IO ()
main = do
    connection <- connectPostgreSQL("host=localhost dbname=faculty_newspaper user=redactor password=qwerty")

    processMainOptions connection

    commit connection
    disconnect connection
    return ()