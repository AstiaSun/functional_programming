module Author where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Name = String
type Surname = String

getAllAuthors :: IConnection a => a -> IO[(Id, Name, Surname)]
getAllAuthors connection = do
    result <- quickQuery' connection query []
    return $ map unpack result
    where
        query = "select * from authors order by id"
        unpack [SqlInteger aid, SqlByteString name, SqlByteString surname] =
               (aid, BS.unpack name, BS.unpack surname)
        unpack x = error $ "Unexpected result: " ++ show x

addAuthor :: IConnection a => Name -> Surname -> a -> IO Bool
addAuthor name surname connection =
    withTransaction connection (createAuthor' name surname)

createAuthor' name surname connection = do
    isChanged <- run connection query [SqlString name, SqlString surname]
    return $ isChanged == 1
    where query = "insert into authors(name, surname) values (?, ?)"

updateAuthor :: IConnection a => Id -> Name -> Surname -> a -> IO Bool
updateAuthor id name surname connection =
    withTransaction connection (update' id name surname)

update' id name surname connection = do
    isChanged <- run connection query[SqlString name, SqlString surname, SqlInteger id]
    return $ isChanged == 1
    where query = "update authors set name=?, surname=? where id=?"

deleteAuthor :: IConnection a => Id -> a -> IO Bool
deleteAuthor id connection = do
    isChanged <- run connection query [SqlInteger id]
    return $ isChanged == 1
    where query = "delete from authors where id=?"
