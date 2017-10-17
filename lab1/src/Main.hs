module Main where

import Database.HDBC
import Database.HDBC.PostgreSQL (connectPostgreSQL)
import Author
import Redactor
import Article
import Topic

main = do
    connection <- connectPostgreSQL("host=localhost dbname=faculty_newspaper user=redactor password=qwerty")
    putStrLn "-------------Authors--------------"
    allAuthorsResult <- getAllAuthors connection
    putStrLn $ show allAuthorsResult
    r <- addAuthor "Miranda" "Jackson" connection
    putStrLn $ show r
    r <- deleteAuthor 9 connection
    putStrLn $ show r
    r <- updateAuthor 5 "Linn" "Mole" connection
    putStrLn $ show r
    allAuthorsResult <- getAllAuthors connection
    putStrLn $ show allAuthorsResult

    putStrLn "-------------Redactors--------------"
    allRedactorsResult <- getAllRedactors connection
    putStrLn $ show allRedactorsResult
    r <- addRedactor "Quincy" "Quinn" connection
    putStrLn $ show r

    putStrLn "-------------Articles--------------"
    allArticlesResult <- getAllArticles connection
    putStrLn $ show allArticlesResult
    r <- addArticle "Test" "Hello world! My name is Haskell" 3 1 connection
    putStrLn $ show r
    {-articleAuthors <- getArticleAuthors 1 connection
    putStrLn $ show articleAuthors-}

    putStrLn "-------------Topics--------------"
    allTopicsResult <- getAllTopics connection
    putStrLn $ show allTopicsResult
    r <- addTopic "Science" connection
    putStrLn $ show r
    r <- deleteTopic 4 connection
    putStrLn $ show r

    commit connection
    disconnect connection
    return ()