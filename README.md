# SCCM SQL – Disk Space by Collection (C:)

This query lists **C: drive free space in GB** for all devices in a specified **SCCM collection**.

## How to use
1. Open `sql/disk_space_by_collection.sql`.
2. Replace `@CollectionID` with your collection (e.g., `IRV005E9`).
3. Run against your **CM_<SiteCode>** database.

## Notes
- `Size0` and `FreeSpace0` are in **MB** → divided by **1024.0** to show **GB**.
- Filters only fixed disks (`DriveType0=3`) and C: (`DeviceID0='C:'`).

## SSRS (optional)
- Parameterize `@CollectionID` via a dataset:
  ```sql
  SELECT CollectionID, Name FROM v_Collection ORDER BY Name;
