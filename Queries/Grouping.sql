USE [Library]
GO

select * from dbo.[books]
select * from dbo.[authors]
select * from dbo.[m2m_books_genres]
select * from dbo.[m2m_books_authors]

select 
(select top 1 b.b_id from books b where b.b_name = bk.b_name AND b.b_year = bk.b_year AND b.b_id % 2 = 0) as [EvenId]
,bk.b_name 
,bk.b_year
,count(bk.b_id) as [GroupItemsCount]
,sum(bk.b_quantity) [QuantitySum]
from dbo.[books] as bk
where bk.b_quantity > 2
group by bk.b_name, bk.b_year
having sum(bk.b_quantity) >= 10

/*
b_id	b_name								b_year	b_quantity
2		The Art of Computer Programming		1993	3
3		Foundation and Empire				2000	5
5		The C++ Programming Language		1996	3
6		Course of Theoretical Physics		1981	4
7		The Art of Computer Programming		1993	7
9		The Fishermen and the Golden Fish	1990	3
10		Foundation and Empire				2000	5
12		The C++ Programming Language		1996	3
13		Course of Theoretical Physics		1981	12
14		The Art of Computer Programming		1993	7
*/