
select a_id, a_name from [Library].dbo.[authors]

select * from [Library].dbo.books

select scope_identity() as LastIdentityOfCurrentSessioninCurrentBatch
select @@identity as LastIdentityOfCurrentSessioninCurrentTransaction
declare @newId int;
select @newId = ident_current('books')
set @newId = @newId + 1

select @newId

