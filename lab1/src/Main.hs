module Main where

import Database.HDBC
import Database.HDBC.PostgreSQL (connectPostgreSQL)
import Author
import Redactor
import Article

main = do
    connection <- connectPostgreSQL("host=localhost dbname=faculty_newspaper user=redactor password=qwerty")
    putStrLn "-------------Authors--------------"
    allAuthorsResult <- getAllAuthors connection
    putStrLn $ show allAuthorsResult

    putStrLn "-------------Redactors--------------"
    allRedactorsResult <- getAllRedactors connection
    putStrLn $ show allRedactorsResult

    putStrLn "-------------Redactors--------------"
    allArticlesResult <- getAllArticles connection
    printStrLn $ show allArticlesResult

    commit connection
    disconnect connection
    return ()