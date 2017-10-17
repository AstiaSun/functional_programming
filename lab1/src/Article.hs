module Article where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS
import qualified Data.Time.LocalTime as LocalTime

type Id = Integer
type Name = String
type Content = String
type CreationDate = LocalTime.LocalTime
type TopicId = Integer
type ReleaseId = Integer

data Article = Article Id Name Content CreationDate TopicId ReleaseId deriving (Show)

aId :: Article -> Id
aId (Article aid _ _ _ _ _) = aid

name :: Article -> Name
name (Article _ aName _ _ _ _) = aName

content :: Article -> Content
content (Article _ _ c _ _ _) = c

creationDate :: Article -> CreationDate
creationDate (Article _ _ _ date _ _) = date

topicId :: Article -> TopicId
topicId (Article _ _ _ _ topic _) = topic

releaseId :: Article -> ReleaseId
releaseId (Article _ _ _ _ _ release) = release



getAllArticles :: IConnection a => a -> IO[(Article)]
getAllArticles connection = do
    result <- quickQuery' connection query[]
    return $ map unpack result
    where
        query = "select * from articles"
        unpack[SqlInteger aid, SqlByteString name,
            SqlByteString content, SqlLocalTime creationDate,
            SqlInteger topicId, SqlInteger releaseId] =
            (aid, BS.unpack name, BS.unpack content,
                creationDate, topicId, releaseId)

addArticle :: IConnection a => Article -> a -> IO Bool
addArticle article connection =
    withTransaction connection (createArticle' article)

createArticle' article connection = do
    isChanged <- run connection query [
        SqlString name article,
        SqlString content article,
        SqlLocalTime creationDate article,
        SqlInteger topicId article,
        SqlInteger releaseId article,
        SqlInteger aId article]
    return $ isChanged == 1
    where
    query = "insert into articles(name, content, creationDate, topicId, releaseId)" ++
        " values (?, ?, ?, ?, ?) where id=?"