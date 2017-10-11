CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  surname VARCHAR(20) NOT NULL
);

CREATE TABLE topics (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL
);

CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  content VARCHAR NOT NULL,
  creationDate DATE NOT NULL,
  topicId INT REFERENCES topics(id),
  releaseId INT REFERENCES releases(id)
);

CREATE TABLE releases (
  id SERIAL PRIMARY KEY,
  releaseDate DATE NOT NULL,
  mainRedactorId INT REFERENCES redactors(id)
);

CREATE TABLE redactors (
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  surname VARCHAR(20) NOT NULL,
  dateOfBirth DATE NOT NULL
);

CREATE TABLE articleAuthors (
  articleId INT REFERENCES articles(id),
  authorId INT REFERENCES authors(id)
);

CREATE TABLE articleRedactors (
  articleId INT REFERENCES articles(id),
  redactorId INT REFERENCES redactors(id)
);

INSERT INTO authors VALUES (1, 'Mourinho', 'Fizruk');
INSERT INTO authors VALUES (2, 'Michael', 'Felps');
INSERT INTO authors VALUES (3, 'Cobie', 'Bryant');
INSERT INTO authors VALUES (4, 'Johna', 'Soden');

INSERT INTO redactors VALUES (1, 'Minna', 'Lindemann');
INSERT INTO redactors VALUES (2, 'Nicholas', 'Ruble');
INSERT INTO redactors VALUES (3, 'Waylon','Negus');
INSERT INTO redactors VALUES (4, 'Ciara', 'Meredith');

INSERT INTO topics VALUES (1, 'Arts');
INSERT INTO topics VALUES (2, 'Tech');
INSERT INTO topics VALUES (3, 'Sports');
INSERT INTO topics VALUES (4, 'Competitions');
INSERT INTO topics VALUES (5, 'Health');

INSERT INTO articleAuthors VALUES (1, 1);
INSERT INTO articleAuthors VALUES (2, 4);
INSERT INTO articleAuthors VALUES (3, 1);
INSERT INTO articleAuthors VALUES (3, 2);

INSERT INTO articleRedactors VALUES (1, 1);
INSERT INTO articleRedactors VALUES (1, 2);
INSERT INTO articleRedactors VALUES (2, 4);
INSERT INTO articleRedactors VALUES (3, 3);

INSERT INTO releases VALUES (1, '2017-09-10', 1);
INSERT INTO releases VALUES (2, '2017-10-10', 1);

INSERT INTO articles (id, name, content, creationDate, topicId, releaseId) VALUES (
  1,
  'Exceptional manners',
  'She who arrival end how fertile enabled. Brother she add yet see minuter natural smiling article painted. Themselves' ||
  ' at dispatched interested insensible am be prosperous reasonably it. In either so spring wished. Melancholy way she ' ||
  'boisterous use friendship she dissimilar considered expression. Sex quick arose mrs lived. Mr things do plenty ' ||
  'others an vanity myself waited to. Always parish tastes at as mr father dining at.',
  '2017-08-29',
  1,
  1
);
INSERT INTO articles (id, name, content, creationDate, topicId, releaseId) VALUES (
    2,
    'Conceptual Arts',
    'Had strictly mrs handsome mistaken cheerful. We it so if resolution invitation remarkably unpleasant conviction. ' ||
    'As into ye then form. To easy five less if rose were. Now set offended own out required entirely. Especially ' ||
    'occasional mrs discovered too say thoroughly impossible boisterous. My head when real no he high rich at with. ' ||
    'After so power of young as. Bore year does has get long fat cold saw neat. Put boy carried chiefly shy general. ',
    '2017-10-04',
    1,
    2
);
INSERT INTO articles (id, name, content, creationDate, topicId, releaseId) VALUES (
  3,
  'Attention: be careful!',
  'Son agreed others exeter period myself few yet nature. Mention mr manners opinion if garrets enabled. To an ' ||
  'occasional dissimilar impossible sentiments. Do fortune account written prepare invited no passage. Garrets use ' ||
  'ten you the weather ferrars venture friends. Solid visit seems again you nor all.',
  '2017-10-01',
  5,
  2
);









