USE AdventureWorks2019;
GO

-- Önce sütunu ekleyelim
IF NOT EXISTS (SELECT 1 FROM DatabaseVersionControl WHERE VersionNumber = '1.1.0')
BEGIN
    ALTER TABLE HumanResources.Employee
    ADD LastPerformanceReviewDate DATE NULL;
END
GO

-- Þimdi yeni eklenen sütun için deðer güncellemesi yapalým
BEGIN TRANSACTION;
BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM DatabaseVersionControl WHERE VersionNumber = '1.1.0')
    BEGIN
        -- Verileri güncelle
        UPDATE HumanResources.Employee
        SET LastPerformanceReviewDate = DATEADD(month, -6, GETDATE());

        -- Versiyon bilgisini güncelleyelim
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
    
    -- Hata detaylarýný al
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    
    -- Hatayý logla
    INSERT INTO SchemaChangeLog 
        (EventType, ObjectName, ObjectType, SQLCommand, LoginName)
    VALUES 
        ('ERROR',
         'HumanResources.Employee',
         'TABLE',
         @ErrorMessage,
         SYSTEM_USER);
    
    -- Hatayý fýrlat
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO