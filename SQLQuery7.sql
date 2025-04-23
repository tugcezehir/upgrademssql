USE master;
GO

-- Tüm baðlantýlarý sonlandýr
DECLARE @kill varchar(8000) = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM sys.sysprocesses 
WHERE db_name(dbid) = 'AdventureWorks2019'
AND spid != @@SPID;
EXEC(@kill);
GO

-- Þimdi veritabanýný çoklu kullanýcý moduna geçirelim
ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO