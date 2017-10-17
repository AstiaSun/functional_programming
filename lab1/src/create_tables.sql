CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  surname VARCHAR(20) NOT NULL
);

CREATE TABLE topics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL
);

CREATE TABLE redactors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  surname VARCHAR(20) NOT NULL
);

CREATE TABLE releases (
  id SERIAL PRIMARY KEY,
  releaseDate DATE NOT NULL,
  mainRedactorId INT REFERENCES redactors(id)
);

CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  content VARCHAR NOT NULL,
  topicId INT REFERENCES topics(id),
  releaseId INT REFERENCES releases(id)
);

CREATE TABLE articleAuthors (
  articleId INT REFERENCES articles(id),
  authorId INT REFERENCES authors(id)
);

CREATE TABLE articleRedactors (
  articleId INT REFERENCES articles(id),
  redactorId INT REFERENCES redactors(id)
);