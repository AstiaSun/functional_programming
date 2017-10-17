INSERT INTO authors(id, name, surname) VALUES (1, 'Mourinho', 'Fizruk');
INSERT INTO authors(id, name, surname) VALUES (2, 'Michael', 'Felps');
INSERT INTO authors(id, name, surname) VALUES (3, 'Cobie', 'Bryant');
INSERT INTO authors(id, name, surname) VALUES (4, 'Johna', 'Soden');

INSERT INTO redactors(id, name, surname) VALUES (1, 'Minna', 'Lindemann');
INSERT INTO redactors(id, name, surname) VALUES (2, 'Nicholas', 'Ruble');
INSERT INTO redactors(id, name, surname) VALUES (3, 'Waylon','Negus');
INSERT INTO redactors(id, name, surname) VALUES (4, 'Ciara', 'Meredith');

INSERT INTO topics(id, name) VALUES (1, 'Arts');
INSERT INTO topics(id, name) VALUES (2, 'Tech');
INSERT INTO topics(id, name) VALUES (3, 'Sports');
INSERT INTO topics(id, name) VALUES (4, 'Competitions');
INSERT INTO topics(id, name) VALUES (5, 'Health');

INSERT INTO releases(id, releaseDate, mainRedactorId) VALUES (1, '2017-09-04', 1);
INSERT INTO releases(id, releaseDate, mainRedactorId) VALUES (2, '2017-10-05', 1);

INSERT INTO articles (id, name, content, topicId, releaseId) VALUES (
  1,
  'Exceptional manners',
  'She who arrival end how fertile enabled. Brother she add yet see minuter natural smiling article painted. Themselves' ||
  ' at dispatched interested insensible am be prosperous reasonably it. In either so spring wished. Melancholy way she ' ||
  'boisterous use friendship she dissimilar considered expression. Sex quick arose mrs lived. Mr things do plenty ' ||
  'others an vanity myself waited to. Always parish tastes at as mr father dining at.',
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
    1,
    2
);
INSERT INTO articles (id, name, content, creationDate, topicId, releaseId) VALUES (
  3,
  'Attention: be careful!',
  'Son agreed others exeter period myself few yet nature. Mention mr manners opinion if garrets enabled. To an ' ||
  'occasional dissimilar impossible sentiments. Do fortune account written prepare invited no passage. Garrets use ' ||
  'ten you the weather ferrars venture friends. Solid visit seems again you nor all.',
  5,
  2
);

INSERT INTO articleAuthors VALUES (1, 1);
INSERT INTO articleAuthors VALUES (2, 4);
INSERT INTO articleAuthors VALUES (3, 1);
INSERT INTO articleAuthors VALUES (3, 2);

INSERT INTO articleRedactors VALUES (1, 1);
INSERT INTO articleRedactors VALUES (1, 2);
INSERT INTO articleRedactors VALUES (2, 4);
INSERT INTO articleRedactors VALUES (3, 3);









