USE master;
GO


ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO


ALTER DATABASE AdventureWorks2019 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO


ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO
