USE AdventureWorks2019;
GO

-- �nce s�tunu ekleyelim
IF NOT EXISTS (SELECT 1 FROM DatabaseVersionControl WHERE VersionNumber = '1.1.0')
BEGIN
    ALTER TABLE HumanResources.Employee
    ADD LastPerformanceReviewDate DATE NULL;
END
GO

-- �imdi yeni eklenen s�tun i�in de�er g�ncellemesi yapal�m
BEGIN TRANSACTION;
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM DatabaseVersionControl WHERE VersionNumber = '1.1.0')
    BEGIN
        -- Verileri g�ncelle
        UPDATE HumanResources.Employee
        SET LastPerformanceReviewDate = DATEADD(month, -6, GETDATE());

        -- Versiyon bilgisini g�ncelleyelim
        INSERT INTO DatabaseVersionControl 
            (VersionNumber, AppliedBy, ScriptName, Description)
        VALUES 
            ('1.1.0', 
             SYSTEM_USER, 
             'Add_PerformanceReview_Column.sql',
             'Added LastPerformanceReviewDate column to Employee table');

        PRINT 'Database successfully upgraded to version 1.1.0';
    END
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Hata durumunda geri al
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    -- Hata detaylar�n� al
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    
    -- Hatay� logla
    INSERT INTO SchemaChangeLog 
        (EventType, ObjectName, ObjectType, SQLCommand, LoginName)
    VALUES 
        ('ERROR',
         'HumanResources.Employee',
         'TABLE',
         @ErrorMessage,
         SYSTEM_USER);
    
    -- Hatay� f�rlat
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO