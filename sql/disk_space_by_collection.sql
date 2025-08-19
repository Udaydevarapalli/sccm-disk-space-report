/*
  SCCM: Disk space by collection (C: drive only)
  - v_GS_LOGICAL_DISK Size0 & FreeSpace0 are in MB → divide by 1024.0 for GB
  - Filter DriveType0=3 (fixed disks) and DeviceID0='C:' for OS drive
  - In SSRS, turn @CollectionID into a parameter (NVARCHAR(10))
*/

DECLARE @CollectionID nvarchar(10) = 'SMS000AB'; -- TODO: replace with your ID (e.g., IRV005E9)

SELECT
    sys.Name0                                  AS [Computer Name],
    ld.DeviceID0                               AS [Drive Letter],
    CAST(ld.Size0 / 1024.0 AS DECIMAL(12,2))      AS [Disk Size (GB)],
    CAST(ld.FreeSpace0 / 1024.0 AS DECIMAL(12,2)) AS [Free Space (GB)],
    CAST(CASE WHEN ld.Size0 > 0
              THEN (ld.FreeSpace0 * 100.0) / ld.Size0
              ELSE NULL END AS DECIMAL(5,2))      AS [Free %],
    coll.CollectionID,
    coll.Name                                  AS [Collection Name]
FROM v_FullCollectionMembership fcm
JOIN v_R_System sys        ON sys.ResourceID     = fcm.ResourceID
JOIN v_GS_LOGICAL_DISK ld  ON ld.ResourceID      = sys.ResourceID
JOIN v_Collection coll     ON coll.CollectionID  = fcm.CollectionID
WHERE fcm.CollectionID = @CollectionID
  AND ld.DriveType0 = 3
  AND ld.DeviceID0 = 'C:'
ORDER BY sys.Name0;
