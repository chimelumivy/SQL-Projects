SELECT *
from admissions
--Renaming table colums

---rename admission_id
EXEC sp_rename
'admissions.admission_id', [Admission ID], 'COLUMN'
---rename patient_id
EXEC sp_rename
'admissions.patient_id', [Patient ID], 'COLUMN'
---rename department_id
EXEC sp_rename
'admissions.department_id', [Department ID], 'COLUMN'
---rename diagnosis_id
EXEC sp_rename
'admissions.diagnosis_id', [Diagnosis ID], 'COLUMN'
---rename admission_date
EXEC sp_rename
'admissions.admission_date', [Admission Date], 'COLUMN'
---rename discharge_date
EXEC sp_rename
'admissions.discharge_date', [Discharge Date], 'COLUMN'
---rename length_of_stay_days
EXEC sp_rename
'admissions.length_of_stay_days', [Admission Period(days)], 'COLUMN'
--rename admission_type
EXEC sp_rename
'admissions.admission_type', [Admission Type], 'COLUMN'
--rename discharge_disposition
EXEC sp_rename
'admissions.discharge_disposition', [Discharge Outcome], 'COLUMN'
--rename total_cost_ng
EXEC sp_rename
'admissions.[Hospitalization Cost(NGN)]', [Hospitalization Fee(NGN)], 'COLUMN'
---Converting values in the admission period column to whole numbers
UPDATE Admissions
SET [Admission Period(days)] = ROUND([Admission Period(days)], 0);
--Checking for NULL values accross the table
SELECT *
FROM Admissions
WHERE [Admission ID] IS NULL
   OR [Patient ID] IS NULL
   OR [Department ID] IS NULL
   OR [Diagnosis ID] IS NULL
   OR [Admission Date] IS NULL
   OR [Discharge Date] IS NULL
   OR [Admission Period(days)] IS NULL
   OR [Admission Type] IS NULL
   OR [Discharge Outcome] IS NULL
   OR [Hospitalization Fee(NGN)] IS NULL;
---Creating a new column for Admission Year
ALTER TABLE Admissions
ADD [Admission Year] INT
---Inputing values from the admission date column for Admission Year
UPDATE Admissions
SET
    [Admission Year] = YEAR([Admission Date])

----Inserting a column for patient's age at admission 
ALTER TABLE Admissions
ADD [Age At Admission] INT

----Inputing values for age at admission
UPDATE a
SET [Age At Admission] =
    DATEDIFF(YEAR, p.[Date of Birth], a.[Admission Date])
    -
    CASE
        WHEN DATEADD(
            YEAR,
            DATEDIFF(YEAR, p.[Date of Birth], a.[Admission Date]),
            p.[Date of Birth]
        ) > a.[Admission Date]
        THEN 1
        ELSE 0
    END
FROM Admissions AS a
INNER JOIN Patients AS p
    ON a.[Patient ID] = p.[Patient ID];

-- Count unique patients with hospital admissions

SELECT
    COUNT(DISTINCT PatientID) AS UniquePatientsAdmitted
FROM Admissions;
