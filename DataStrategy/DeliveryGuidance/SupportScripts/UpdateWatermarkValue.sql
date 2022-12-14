UPDATE dbo.ControlTable
SET DataLoadingBehaviorSettings = JSON_MODIFY(DataLoadingBehaviorSettings,'$."watermarkColumnStartValue"','2008-04-08T00:00:00')

