USE master;
GO

-- Veritaban�n� �oklu kullan�c� moduna ge�irmek i�in
ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO

-- E�er hala sorun devam ederse, mevcut ba�lant�lar� sonland�rmak i�in:
ALTER DATABASE AdventureWorks2019 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Sonra tekrar �oklu kullan�c� moduna ge�irelim
ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO