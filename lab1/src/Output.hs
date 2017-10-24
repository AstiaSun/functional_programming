module Output where

import Author
import Redactor
import Article
import Topic
import Database.HDBC
import System.Exit

readInteger :: IO Integer
readInteger = readLn

{-------Author output------}

processAddAuthor :: IConnection a => a -> IO()
processAddAuthor connection = do
    putStrLn "Name:"
    name <- getLine
    putStrLn "Surname:"
    surname <- getLine
    r <- addAuthor name surname connection
    putStrLn $ show r

processUpdateAuthor connection = do
    putStrLn "Id:"
    id <- readInteger
    putStrLn "Name:"
    name <- getLine
    putStrLn "Surname:"
    surname <- getLine
    r <- updateAuthor id name surname connection
    putStrLn $ show r

processDeleteAuthor connection = do
    putStrLn "Id:"
    id <- readInteger
    r <- deleteAuthor id connection
    putStrLn $ show r

showArray [] = return()
showArray (x:xs) = do
    print x
    showArray xs

showAllAuthors connection = do
    r <- getAllAuthors connection
    showArray r

{-------Redactor output------}

processAddRedactor connection = do
    putStrLn "Name:"
    name <- getLine
    putStrLn "Surname:"
    surname <- getLine
    r <- addRedactor name surname connection
    putStrLn $ show r

processUpdateRedactor connection = do
    putStrLn "Id:"
    id <- readInteger
    putStrLn "Name:"
    name <- getLine
    putStrLn "Surname:"
    surname <- getLine
    r <- updateRedactor id name surname connection
    putStrLn $ show r

processDeleteRedactor connection = do
    putStrLn "Id:"
    id <- readInteger
    r <- deleteRedactor id connection
    putStrLn $ show r

showAllRedactors connection = do
    r <- getAllRedactors connection
    showArray r

{-------Redactor output------}

processAddTopic connection = do
    putStrLn "Name:"
    name <- getLine
    r <- addTopic name connection
    putStrLn $ show r

{-processUpdateTopic connection = do
    putStrLn "Id:"
    id <- readInteger
    putStrLn "Name:"
    name <- getLine
    r <- updateTopic id name connection
    putStrLn $ show r-}

processDeleteTopic connection = do
    putStrLn "Id:"
    id <- readInteger
    r <- deleteTopic id connection
    putStrLn $ show r

showAllTopics connection = do
    r <- getAllTopics connection
    showArray r

{-------Article output------}

processAddArticle connection = do
    putStrLn "Title:"
    name <- getLine
    putStrLn "Content:"
    content <- getLine
    putStrLn "Topic id:"
    tId <- readInteger
    putStrLn "Release id:"
    rId <- readInteger
    r <- addArticle name content tId rId connection
    putStrLn $ show r

{-processUpdateArticle connection = do
    putStrLn "Id:"
    id <- readInteger
    putStrLn "Name:"
    name <- getLine
    putStrLn "Surname:"
    surname <- getLine
    r <- updateArticle id name surname connection
    putStrLn $ show r-}

processDeleteArticle connection = do
    putStrLn "Id:"
    id <- readInteger
    r <- deleteArticle id connection
    putStrLn $ show r

showAllArticles connection = do
    r <- getAllArticles connection
    showArray r

showMainOptions = do
    putStrLn "1 - authors"
    putStrLn "2 - redactors"
    putStrLn "3 - articles"
    putStrLn "4 - topics"

processMainDecision desicion connection = do
    case desicion of
        1 -> processAuthorOptions connection
        2 -> processRedactorOptions connection
        3 -> processArticleOptions connection
        _   -> exitFailure

processMainOptions :: IConnection a => a -> IO()
processMainOptions connection = do
    showMainOptions
    d <- readInteger
    processMainDecision d connection

showOptions :: String -> IO()
showOptions object = do
    putStrLn $ "1 - show all " ++ (object ++ "s")
    putStrLn $ "2 - add new " ++ object
    putStrLn $ "3 - update " ++ object
    putStrLn $ "4 - delete " ++ object
    putStrLn "5 - back"

processAuthorDecision :: IConnection a => a -> IO()
processAuthorDecision connection = do
    decision <- readInteger
    case decision of
        1 -> showAllAuthors connection
        2 -> processAddAuthor connection
        3 -> processUpdateAuthor connection
        4 -> processDeleteAuthor connection
        5 -> processMainOptions connection
        _ -> processAuthorOptions connection
    processAuthorOptions connection

processRedactorDecision :: IConnection a => a -> IO()
processRedactorDecision connection = do
    decision <- readInteger
    case decision of
        1 -> showAllRedactors connection
        2 -> processAddRedactor connection
        3 -> processUpdateRedactor connection
        4 -> processDeleteRedactor connection
        5 -> processMainOptions connection
        _ -> processRedactorOptions connection
    processRedactorOptions connection

processTopicDecision :: IConnection a => a -> IO()
processTopicDecision connection = do
    decision <- readInteger
    case decision of
        1 -> showAllTopics connection
        2 -> processAddTopic connection
        {-3 -> processUpdateTopic connection-}
        4 -> processDeleteTopic connection
        5 -> processMainOptions connection
        _ -> processTopicOptions connection
    processTopicOptions connection

processArticleDecision :: IConnection a => a -> IO()
processArticleDecision connection = do
    decision <- readInteger
    case decision of
        1 -> showAllArticles connection
        2 -> processAddArticle connection
        {-3 -> processUpdateArticle connection-}
        4 -> processDeleteArticle connection
        5 -> processMainOptions connection
        _ -> processArticleOptions connection
    processArticleOptions connection

processAuthorOptions :: IConnection a => a -> IO()
processAuthorOptions connection = do
    showOptions "author"
    processAuthorDecision connection

processRedactorOptions :: IConnection a => a -> IO()
processRedactorOptions connection = do
    showOptions "redactor"
    processRedactorDecision connection

processTopicOptions :: IConnection a => a -> IO()
processTopicOptions connection = do
    showOptions "topic"
    processTopicDecision connection

processArticleOptions :: IConnection a => a -> IO()
processArticleOptions connection = do
    showOptions "article"
    processArticleDecision connection