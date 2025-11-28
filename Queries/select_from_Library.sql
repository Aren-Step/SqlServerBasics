USE Library
GO


SELECT s_name, sb_is_active
FROM subscriptions AS sb
         JOIN subscribers AS s ON s.s_id = sb.sb_subscriber;

SELECT  b.b_name,
        a.a_name,
        g.g_name
FROM    Library.dbo.books             AS b
            JOIN    Library.dbo.m2m_books_authors AS mba ON mba.b_id = b.b_id
            JOIN    Library.dbo.authors           AS a   ON a.a_id  = mba.a_id
            JOIN    Library.dbo.m2m_books_genres  AS mbg ON mbg.b_id = b.b_id
            JOIN    Library.dbo.genres            AS g   ON g.g_id  = mbg.g_id;

SELECT b_name, s_id, s_name, sb_start, sb_finish
FROM books AS b
         JOIN subscriptions AS sb ON sb.sb_book = b.b_id
         JOIN subscribers AS s ON s.s_id = sb.sb_subscriber;

SELECT COUNT(DISTINCT sb_book) AS in_use
FROM subscriptions AS sb
WHERE sb_is_active = 'Y';

SELECT b_name, b_year, b_quantity
FROM books AS b
WHERE b_quantity >= 3
  AND b_year BETWEEN 1900 AND 2000
ORDER BY b_quantity DESC, b_year;

SELECT AVG(CAST(books_per_subscriber AS FLOAT)) AS avg_book_year
FROM (SELECT COUNT(DISTINCT sb_book) AS books_per_subscriber
      FROM subscriptions
      WHERE sb_is_active = 'Y'
      GROUP BY sb_subscriber
     ) AS sub_count;

SELECT YEAR(sb_start) AS year,
       COUNT(sb_id) AS books_taken
FROM subscriptions
GROUP BY YEAR(sb_start) -- 'year' alias cannot be used in GROUP BY
ORDER BY year;

SELECT b_name AS book,
       STRING_AGG(a_name, ', ') WITHIN GROUP (ORDER BY a_name) AS Authors
FROM Books AS b
         JOIN m2m_books_authors AS mba ON mba.b_id = b.b_id
         JOIN Authors AS a ON a.a_id = mba.a_id
GROUP BY b_name, b.b_id
ORDER BY book;

-- Show all subscribers who doesn't have a book now (use JOIN)
SELECT s_id, s_name
FROM subscribers AS s
         LEFT OUTER JOIN subscriptions AS sb ON sb.sb_subscriber = s.s_id
GROUP BY s_id, s_name
HAVING COUNT(CASE
                 WHEN sb.sb_is_active = 'Y' THEN sb.sb_is_active
    END) = 0;

SELECT s_id, s_name
FROM subscribers AS s
WHERE s_id NOT IN (
    SELECT DISTINCT sb_subscriber
    FROM subscriptions AS sb
    WHERE sb_is_active = 'Y'
)

-- Select all books from Programming and/or Classic genres (do not use JOIN, g_id is known)
SELECT b_name, b_year
FROM books AS b
WHERE b_id IN (
    SELECT DISTINCT mbg.b_id
    FROM M2M_Books_Genres AS mbg
    WHERE mbg.g_id IN (2, 5)
)
ORDER BY b_year;

-- Select all books from Programming and/or Classic genres (do not use JOIN, g_id is not known)
SELECT b_id, b_name, b_year
FROM books AS b
WHERE b_id IN (
    SELECT DISTINCT mbg.b_id
    FROM M2M_Books_Genres AS mbg
    WHERE mbg.g_id IN (
        SELECT DISTINCT g_id
        FROM Genres AS g
        WHERE g.g_name IN ('Programming', 'Classics')
    )
)
ORDER BY b_year;

-- Select all books from Programming and/or Classic genres (use JOIN, g_id is known)
SELECT b.b_id, b.b_name, b.b_year
FROM books AS b
         JOIN m2m_books_genres AS mbg ON mbg.b_id = b.b_id
WHERE mbg.g_id IN (2, 5)
ORDER BY b_year;

-- Select all books from Programming and/or Classic genres (use JOIN, g_id is not known)
SELECT b.b_id, b.b_name, b.b_year
FROM books AS b
         JOIN m2m_books_genres AS mbg ON mbg.b_id = b.b_id
WHERE mbg.g_id IN (
    SELECT DISTINCT g_id
    FROM Genres AS g
    WHERE g.g_name IN ('Programming', 'Classics')
)

-- Show all books that have more than one author
SELECT b.b_id, b.b_name,
       COUNT(m2m_books_authors.a_id) AS authors_count
FROM books AS b
         JOIN m2m_books_authors ON m2m_books_authors.b_id = b.b_id
GROUP BY b.b_id, b.b_name
HAVING COUNT(m2m_books_authors.a_id) > 1;

GO