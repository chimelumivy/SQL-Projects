---viewing each table in the database
select *
from admissions
select *
from patients
select *
from diagnoses
select *
from [readmissions link]
---------data cleaning/validation-----------

--to check if all null values really mean no occurence or if they represent texts
SELECT TOP 20
    [30D Readmission ID], DATALENGTH([30D Readmission ID]) AS ID_Length,[Readmission Interval(days)], DATALENGTH([Readmission Interval(days)]) AS Interval_Length
FROM [readmissions link];

---data validation: checking if readmission occured before 30 days but readmission interval says null
SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN [30D Readmission ID] IS NOT NULL
        AND [Readmission Interval(days)] IS NULL
        THEN 1 ELSE 0
    END) AS [Wrong data]
from [readmissions link]

----data validation: to ensure no inconsistencies between columns
SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN [30D Readmission ID] IS NULL
        AND [Readmission Interval(days)] IS NULL
        THEN 1 ELSE 0
    END) AS Both_NULL,

    SUM(CASE
        WHEN [30D Readmission ID] IS NOT NULL
        AND [Readmission Interval(days)] IS NOT NULL
        THEN 1 ELSE 0
    END) AS Both_Present,

    SUM(CASE
        WHEN [30D Readmission ID] IS NOT NULL
        AND [Readmission Interval(days)] IS NULL
        THEN 1 ELSE 0
    END) AS [Wrong data],

    SUM(CASE
        WHEN [30D Readmission ID] IS NULL
        AND [Readmission Interval(days)] IS NOT NULL
        THEN 1 ELSE 0
    END) AS [Readmission Interval >30]
    FROM [readmissions link];

---data validation: to ensure that the number of records that showed values for readmission intervals and none for 30day readmission from the above query represent readmissions after 30days
SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN [Readmission Interval(days)] <= 30
        THEN 1 ELSE 0
    END) AS Within_30_Days,
    SUM(CASE
        WHEN [Readmission Interval(days)] > 30
        THEN 1 ELSE 0
    END) AS Above_30_Days
FROM [dbo].[readmissions link]
WHERE [30D Readmission ID] IS NULL
AND [Readmission Interval(days)] IS NOT NULL;

---data validation:checking for duplicates in readmissions link table
SELECT
    [Index Admission ID],
    COUNT(*) AS Number_of_Occurrences
FROM [readmissions link]
GROUP BY [Index Admission ID]
HAVING COUNT(*) > 1;
--data validation:checking for negative readmissions interval
SELECT *
FROM [readmissions link]
WHERE [Readmission Interval(days)] < 0;

---data validation:checking that the index admission id exists in the admissions table as an admission id
SELECT
    r.[Index Admission ID]
FROM [dbo].[readmissions link] r
LEFT JOIN dbo.admissions a
    ON r.[Index Admission ID] = a.[Admission ID]
WHERE a.[Admission ID] IS NULL;

---data validation:to check that the readmission id exists in the admissions table as an admission id
SELECT
    r.[30D Readmission ID]
FROM [readmissions link] r
LEFT JOIN admissions a
    ON r.[30D Readmission ID] = a.[Admission ID]
WHERE r.[30D Readmission ID] IS NOT NULL
AND a.[Admission ID] IS NULL;

---data validation:to check that there are no identical index admissions and readmission IDs
SELECT *
FROM [readmissions link]
WHERE [Index Admission ID] = [30D Readmission ID];

-- Check whether readmission IDs also appear as index admission IDs

SELECT
    COUNT(DISTINCT r.[30D Readmission ID])
        AS UniqueReadmissionIDs,

    COUNT(DISTINCT r2.[Index Admission ID])
        AS ReadmissionIDsAlsoUsedAsIndex

FROM [Readmissions Link] AS r

INNER JOIN [Readmissions Link] AS r2
    ON r.[30D Readmission ID] = r2.[Index Admission ID];