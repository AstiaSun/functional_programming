module Topic where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Name = String

getAllTopics :: IConnection a => a -> IO[(Id, Name)]
getAllTopics connection = do
    result <- quickQuery' connection query []
    return $ map unpack result
    where
        query = "select * from topics order by id"
        unpack [SqlInteger id, SqlByteString name] =
               (id, BS.unpack name)
        unpack x = error $ "Unexpected result: " ++ show x

addTopic :: IConnection a => Name -> a -> IO Bool
addTopic name connection =
    withTransaction connection (createTopic' name)

createTopic' name connection = do
    isChanged <- run connection query [SqlString name]
    return $ isChanged == 1
    where query = "insert into topics(name) values (?)"

deleteTopic :: IConnection a => Id -> a -> IO Bool
deleteTopic id connection = do
    isChanged <- run connection query [SqlInteger id]
    return $ isChanged == 1
    where query = "delete from topics where id=?"

