USE master;
GO

-- Veritabanýný çoklu kullanýcý moduna geçirmek için
ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO

-- Eðer hala sorun devam ederse, mevcut baðlantýlarý sonlandýrmak için:
ALTER DATABASE AdventureWorks2019 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Sonra tekrar çoklu kullanýcý moduna geçirelim
ALTER DATABASE AdventureWorks2019 SET MULTI_USER;
GO