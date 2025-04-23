USE master;
GO

-- T�m ba�lant�lar� sonland�r
DECLARE @kill varchar(8000) = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM sys.sysprocesses 
WHERE db_name(dbid) = 'AdventureWorks2019'
AND spid != @@SPID;
EXEC(@kill);
GO

-- �imdi veritaban�n� �oklu kullan�c� moduna ge�irelim
ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO