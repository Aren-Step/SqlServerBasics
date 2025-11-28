USE Library
GO

CREATE TABLE books (
    b_id int IDENTITY(1,1),
    b_name nvarchar(150),
    b_year smallint,
    b_quantity smallint,
    CONSTRAINT PK_books PRIMARY KEY (b_id)
)

CREATE TABLE genres (
    g_id int IDENTITY(1,1),
    g_name nvarchar(150),
    CONSTRAINT PK_genres PRIMARY KEY (g_id),
    CONSTRAINT UQ_genres_g_name UNIQUE (g_name)
)

CREATE TABLE authors (
    a_id int IDENTITY(1,1),
    a_name nvarchar(150),
    CONSTRAINT PK_authors PRIMARY KEY (a_id)
)

CREATE TABLE subscribers (
    s_id int IDENTITY(1,1),
    s_name nvarchar(150),
    CONSTRAINT PK_subscribers PRIMARY KEY (s_id)
)

CREATE TABLE subscriptions (
    sb_id int,
    sb_subscriber int,
    sb_book int,
    sb_start date,
    sb_finish date,
    sb_is_active char(1),
    CONSTRAINT PK_subscriptions PRIMARY KEY (sb_id),
    CONSTRAINT FK_subscriptions_books FOREIGN KEY (sb_book) REFERENCES books(b_id),
    CONSTRAINT FK_subscriptions_subscribers FOREIGN KEY (sb_subscriber) REFERENCES subscribers(s_id),
    CONSTRAINT check_enum CHECK (sb_is_active IN ('Y','N'))
)

CREATE TABLE m2m_books_genres (
    b_id int,
    g_id int,
    CONSTRAINT PK_m2m_books_genres PRIMARY KEY (b_id, g_id),
    CONSTRAINT FK_m2m_books_genres_books FOREIGN KEY (b_id) REFERENCES books(b_id),
    CONSTRAINT FK_m2m_books_genres_genres FOREIGN KEY (g_id) REFERENCES genres(g_id)
)

CREATE TABLE m2m_books_authors (
    b_id int,
    a_id int,
    CONSTRAINT PK_m2m_books_authors PRIMARY KEY (b_id, a_id),
    CONSTRAINT FK_m2m_books_authors_books FOREIGN KEY (b_id) REFERENCES books(b_id),
    CONSTRAINT FK_m2m_books_authors_authors FOREIGN KEY (a_id) REFERENCES authors(a_id)
)

GO

INSERT INTO books(b_name, b_year, b_quantity)
VALUES ('Eugene Onegin', 1985, 2),
       ('The Fishermen and the Golden Fish', 1990, 3),
       ('Foundation and Empire', 2000, 5),
       ('Programming Psychology', 1998, 1),
       ('The C++ Programming Language', 1996, 3),
       ('Course of Theoretical Physics', 1981, 12),
       ('The Art of Computer Programming', 1993, 7);

INSERT INTO authors(a_name)
VALUES ('Donald Knuth'),
       ('Isaac Asimov'),
       ('Dale Carnegie'),
       ('Lev Landau'),
       ('Evgeny Lifshitz'),
       ('Bjarne Stroustrup'),
       ('Alexander Pushkin');

INSERT INTO genres(g_name)
VALUES ('Poetry'),
       ('Programming'),
       ('Psychology'),
       ('Science'),
       ('Classics'),
       ('Science Fiction');

INSERT INTO subscribers(s_name)
VALUES ('Ivanov I.I.'),
       ('Petrov P.P.'),
       ('Sidorov S.S.'),
       ('Sidorov S.s.');

INSERT INTO m2m_books_authors(b_id, a_id)
VALUES (1, 7),
       (2, 7),
       (3, 2),
       (4, 3),
       (4, 6),
       (5, 6),
       (6, 5),
       (6, 4),
       (7, 1);

INSERT INTO m2m_books_genres(b_id, g_id)
VALUES (1, 1),
       (1, 5),
       (2, 1),
       (2, 5),
       (3, 6),
       (4, 2),
       (4, 3),
       (5, 2),
       (6, 5),
       (7, 2),
       (7, 5);

INSERT INTO subscriptions(sb_id, sb_subscriber, sb_book, sb_start, sb_finish, sb_is_active)
VALUES (100, 1, 3, '2011-01-12', '2011-02-12', 'N'),
       (2, 1, 1, '2011-01-12', '2011-02-12', 'N'),
       (3, 3, 3, '2012-05-17', '2012-07-17', 'Y'),
       (42, 1, 2, '2012-06-11', '2012-08-11', 'N'),
       (57, 4, 5, '2012-06-11', '2012-08-11', 'N'),
       (61, 1, 7, '2014-08-03', '2014-10-03', 'N'),
       (62, 3, 5, '2014-08-03', '2014-10-03', 'Y'),
       (86, 3, 1, '2014-08-03', '2014-09-03', 'Y'),
       (91, 4, 1, '2015-10-07', '2015-03-07', 'Y'),
       (95, 1, 4, '2015-10-07', '2015-11-07', 'N'),
       (99, 4, 4, '2015-10-08', '2025-11-08', 'Y');

GO

SELECT *
FROM books
SELECT *
FROM authors
SELECT *
FROM genres
SELECT *
FROM m2m_books_authors
SELECT *
FROM m2m_books_genres
SELECT *
FROM subscribers
SELECT *
FROM subscriptions
GO

/*
DROP TABLE m2m_books_authors;
DROP TABLE m2m_books_genres;
DROP TABLE subscriptions;
DROP TABLE subscribers;
DROP TABLE authors;
DROP TABLE genres;
DROP TABLE books;
GO
*/