module Redactor where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Name = String
type Surname = String

getAllRedactors :: IConnection a => a -> IO[(Id, Name, Surname)]
getAllRedactors connection = do
    result <- quickQuery' connection query []
    return $ map unpack result
    where
        query = "select * from redactors order by id"
        unpack [SqlInteger aid, SqlByteString name, SqlByteString surname] =
               (aid, BS.unpack name, BS.unpack surname)
        unpack x = error $ "Unexpected result: " ++ show x

addRedactor :: IConnection a => Name -> Surname -> a -> IO Bool
addRedactor name surname connection =
    withTransaction connection (createRedactor' name surname)

createRedactor' name surname connection = do
    isChanged <- run connection query [SqlString name, SqlString surname]
    return $ isChanged == 1
    where query = "insert into redactors(name, surname) values (?, ?)"

updateRedactor :: IConnection a => Id -> Name -> Surname -> a -> IO Bool
updateRedactor id name surname connection =
    withTransaction connection (update' id name surname)

update' id name surname connection = do
    isChanged <- run connection query[SqlString name, SqlString surname, SqlInteger id]
    return $ isChanged == 1
    where query = "update redactors set name=?, surname=? where id=?"

deleteRedactor :: IConnection a => Id -> a -> IO Bool
deleteRedactor id connection = do
    isChanged <- run connection query [SqlInteger id]
    return $ isChanged == 1
    where query = "delete from redactors where id=?"
