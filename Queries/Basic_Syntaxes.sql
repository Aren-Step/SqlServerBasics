USE [Library]
GO

------------------------ PROCEDURES -----------------------
DROP procedure [dbo].[sp_GetAuthors]
go
create or alter procedure [dbo].[sp_GetAuthors]
(
	@count int = null,
	@result varchar(50) output
)
as
begin
--declare @tranName nvarchar(50) = 'MyTransaction';
BEGIN TRANSACTION --@tranName
    BEGIN TRY
	SET NOCOUNT ON;

    --....

	if (@count is null)
    begin
		select * from [Library].dbo.[authors]
        --set @result = 'YES'
        --COMMIT TRANSACTION
    end
	else
    begin
        select top(@count) * from [Library].dbo.[authors]
        --set @result = 'NO'
		--ROLLBACK TRANSACTION 
    end

	select @result = 'OK'
	
    COMMIT TRANSACTION --@tranName
    END TRY
    BEGIN CATCH
        IF (@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION --@tranName
    END CATCH
end
GO

------------------------ FUNCTIONS -----------------------
CREATE or alter FUNCTION [dbo].[ufn_GetAuthorsCount] ()
RETURNS int
AS
BEGIN
	
	RETURN (select count(a_id) from dbo.authors)

END
GO

DROP function [dbo].[ufn_ZZZGetAllAuthors]
go
CREATE OR ALTER FUNCTION [dbo].[ufn_ZZZGetAllAuthors]()
--RETURNS TABLE
RETURNS @ResultTable TABLE
(
    [a_id] INT,
	[a_name] [nvarchar](150)
)
AS
    --RETURN select [a_id], [a_name] from [dbo].[authors]
BEGIN
	INSERT INTO @ResultTable([a_id], [a_name])
		select [a_id], [a_name] from [dbo].[authors];
	RETURN;
END
GO

------------------------ TRIGGERS -----------------------

CREATE TRIGGER [dbo].[trg_save_deleted_books]
ON [dbo].[books]
AFTER DELETE--, UPDATE, INSERT
AS
BEGIN
    INSERT INTO books_AllDeleted (
        b_id, 
        b_name, 
        b_year, 
        b_quantity
    )
    SELECT b_id, 
        b_name, 
        b_year, 
        b_quantity
    FROM deleted
END;
GO

CREATE TRIGGER [dbo].[trg_save_books_with_updated_names]
ON [dbo].[books]
AFTER UPDATE
AS
BEGIN
    IF UPDATE(b_name)
    BEGIN
        INSERT INTO books_b_name_Updated (
            b_id, 
            b_name, 
            b_year, 
            b_quantity
        )
        SELECT b_id, 
            b_name, 
            b_year, 
            b_quantity
        FROM deleted
    END
END;
GO

-------------------------- ADD COLUMN --------------------------

--ALTER TABLE [dbo].[books] DROP CONSTRAINT [DF_b_date] GO
--truncate table [dbo].[books]
ALTER TABLE [dbo].[books] ADD [b_date] datetime NOT NULL 
GO

-------------------------- DROP COLUMN --------------------------

ALTER TABLE [dbo].[books] DROP COLUMN [b_date]
GO

-------------------------- ADD CONSTRAINT --------------------------

ALTER TABLE [dbo].[books] ADD  CONSTRAINT [UN_b_name] UNIQUE 
(
	[b_name] ASC
)
GO

ALTER TABLE [dbo].[books] ADD CONSTRAINT [DF_b_date] DEFAULT(getutcdate()) FOR [b_date]
GO

----------------------------- CREATE INDEX  ------------------------

CREATE UNIQUE NONCLUSTERED INDEX [IX_Name] ON [dbo].[A_table] ([Name] ASC)
GO

------------------------------------------------------------

CREATE OR ALTER VIEW [dbo].[books_after_1990]
AS
select b_id, b_name, b_year, b_quantity
from books
where b_year > 1990

GO

-- ////////////////////////////////////////////////////////////////////////////////////////////

SELECT STRING_AGG(a_name, ' | ') FROM authors

SELECT subQuery.b_id, subQuery.b_quantity, subQuery.b_name, subQuery.row_num 
FROM (SELECT b_id, b_quantity, b_name, ROW_NUMBER() OVER (ORDER BY b_quantity ASC) AS row_num FROM books) as subQuery

declare @page_num int = 2, @items_count int = 3;
SELECT subQuery.b_id, subQuery.b_quantity, subQuery.b_name, subQuery.row_num 
FROM (SELECT b_id, b_quantity, b_name, ROW_NUMBER() OVER (ORDER BY b_quantity ASC) AS row_num FROM books) as subQuery
WHERE subQuery.row_num > (@page_num - 1) * @items_count AND subQuery.row_num <= (@page_num - 1) * @items_count + @items_count

SELECT * from Scores ORDER BY Score desc
SELECT Name, Score,
       RANK() OVER (ORDER BY Score desc) AS Rank,
       DENSE_RANK() OVER (ORDER BY Score desc) AS Rank
FROM Scores;

Alter table Scores add id int

SELECT * FROM Scores ORDER BY [Name], Score

SELECT [Name], Score, avg(cast(id as decimal)) as [MidId]  
FROM Scores
GROUP BY [Name], Score
ORDER BY [MidId] desc

declare @temp  = N'fsgnfdա ghfg'
select @temp

SELECT * from Scores ORDER BY [Name] asc--, id desc
SELECT *, ROW_NUMBER() OVER (partition by Score ORDER BY [Name] asc) from Scores
