module Main where

import Database.HDBC
import Database.HDBC.PostgreSQL (connectPostgreSQL)
import Author

main = do
    connection <- connectPostgreSQL("host=localhost dbname=faculty_newspaper user=redactor password=qwerty")
    putStrLn "-------------Authors--------------"
    allAuthorsResult <- getAllAuthors connection
    putStrLn $ show allAuthorsResult
    commit connection
    disconnect connection
    return ()