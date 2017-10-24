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

getAllArticles :: IConnection a => a -> IO[(Id, Name, Content, TopicId, ReleaseId)]
getAllArticles connection = do
    result <- quickQuery' connection query[]
    return $ map unpack result
    where
        query = "select id, name, content, topicId, releaseId from articles"
        unpack[SqlInteger id, SqlByteString name,
            SqlByteString content, SqlInteger topicId, SqlInteger releaseId] =
            (id, BS.unpack name, BS.unpack content, topicId, releaseId)

addArticle :: IConnection a => Name -> Content -> TopicId -> ReleaseId -> a -> IO Bool
addArticle name content topicId releaseId connection =
    withTransaction connection (createArticle' name content topicId releaseId)

createArticle' name content topicId releaseId connection = do
    isChanged <- run connection query [
        SqlString name,
        SqlString content,
        SqlInteger topicId,
        SqlInteger releaseId]
    return $ isChanged == 1
    where
        query = "insert into articles(name, content, topicId, releaseId)" ++
            " values (?, ?, ?, ?)"

getArticleAuthors :: IConnection a => Id -> a -> IO[(Id, Name, Name)]
getArticleAuthors id connection = do
    result <- quickQuery' connection query[]
    return $ map unpack result
    where
        query = "select * from authors join articleAuthors on authors.id = articleAuthors.authorId where articleAuthors.articleId=1"
        unpack [SqlInteger aid, SqlByteString name, SqlByteString surname] =
            (aid, BS.unpack name, BS.unpack surname)

deleteArticle :: IConnection a => Id -> a -> IO(Bool)
deleteArticle id connection = do
    isChanged <- run connection query [SqlInteger id]
    return $ isChanged == 1
    where query = "delete from articles where id=?"