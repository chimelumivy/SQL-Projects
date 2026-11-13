/* =========================================
   1. DEPARTMENTAL PERFORMANCE
   ========================================= */

---1.1 DEPARTMENTAL PERFORMANCE → Key Performance Indicators
   -- KPI 1: Total Departments
SELECT
    COUNT(*) AS [Total Departments]
FROM Departments;

   -- KPI 2: Total Admissions
SELECT
    COUNT(*) AS [Total Admissions]
FROM Admissions;

   -- KPI 3: Total Hospitalization Fees
SELECT
    SUM([Hospitalization Fee(NGN)]) AS [Total Hospitalization Fees]
FROM Admissions;

   -- KPI 4: Overall Mortality Rate
SELECT
    ROUND(
        SUM(CASE WHEN [Discharge Outcome] = 'Died' THEN 1 ELSE 0
            END)
            * 100.0 / COUNT(*), 2) 
    AS [Overall Mortality Rate (%)]
FROM Admissions;

   -- KPI 5: Average Admission Period(days)
SELECT
    ROUND(AVG([Admission Period(days)]), 2)
        AS [Average Admission Period(days)]
FROM Admissions;

---1.1 DEPARTMENTAL PERFORMANCE → Insights
   -- Insight 1: Admissions by Department
   SELECT
    D.Department,
    COUNT(A.[Admission ID]) AS [Total Admissions]
FROM Admissions AS A
INNER JOIN Departments AS D
    ON A.[Department ID] = D.[Department ID]
GROUP BY
    D.Department
ORDER BY
    [Total Admissions] DESC;
  -- Insight 2: Hospitalization Fees by Department
SELECT
    D.Department,
    SUM(A.[Hospitalization Fee(NGN)]) AS [Total Hospitalization Fees]
FROM Admissions AS A
JOIN Departments AS D
    ON A.[Department ID] = D.[Department ID]
GROUP BY
    D.Department
ORDER BY
    [Total Hospitalization Fees] DESC;
  -- Insight 3: Mortality rate by Department
  SELECT
    D.Department,
    COUNT(A.[Admission ID]) AS [Total Admissions],
    SUM(CASE WHEN A.[Discharge Outcome] = 'Died' THEN 1 ELSE 0
        END) AS [Deaths],
    CAST(ROUND(SUM(CASE WHEN A.[Discharge Outcome]= 'Died' THEN 1 ELSE 0
                   END) * 100.0 / COUNT(A.[Admission ID]), 2) AS DECIMAL(10,2)
    ) AS [Mortality Rate (%)]
FROM Admissions AS A
JOIN Departments AS D
    ON A.[Department ID] = D.[Department ID]
GROUP BY
    D.Department
ORDER BY
    [Mortality Rate (%)] DESC;
    -- Insight 4: Average Admission Period(days) by Department
SELECT
    D.Department,
    COUNT(A.[Admission ID]) AS [Total Admissions],
    ROUND(
        AVG(A.[Admission Period(days)]), 2)
    AS [Average Admission Period(days)]
FROM Admissions AS A
JOIN Departments AS D
    ON A.[Department ID] = D.[Department ID]
GROUP BY
    D.Department
ORDER BY
    [Average Admission Period(days)] DESC;

   -- Insight 5: 30-Day Readmission Rate by Department(have to investigate the data before this calculation)
     -- Investigation: Verify Readmission Intervals by ensuring that readmission interval calucated from admissions table is same as that recorded in readmissions table
SELECT
    R.[Index Admission ID],
    R.[30D Readmission ID],
    R.[Readmission Interval(days)] AS [Recorded Readmission Interval (days)],
    A1.[Discharge Date] AS [Index Discharge Date],
    A2.[Admission Date] AS [Readmission Date],
    DATEDIFF( DAY,A1.[Discharge Date],A2.[Admission Date]) AS [Calculated Readmission Interval (days)]
FROM [Readmissions Link] AS R
JOIN Admissions AS A1
    ON R.[Index Admission ID] = A1.[Admission ID]
JOIN Admissions AS A2
    ON R.[30D Readmission ID] = A2.[Admission ID]
WHERE R.[30D Readmission ID] IS NOT NULL;----Correct Intervals
   
     -- Count Unique Index Admissions With Linked 30 day Readmissions
SELECT
    COUNT(DISTINCT [Index Admission ID])
        AS [Unique Index Admissions With Readmissions]
FROM [Readmissions Link]
WHERE [30D Readmission ID] IS NOT NULL;

    -- Determining the outcomes of admissions resulting in readmissions as only index admissions resulting in discharge can be included as denominator in finding 30 day readmission rate
SELECT
    A.[Discharge Outcome],
    COUNT(A.[Admission ID]) AS [Total Admissions],
    COUNT(R.[Index Admission ID]) AS [Admissions With 30-Day Readmission]
FROM Admissions AS A
LEFT JOIN (SELECT DISTINCT[Index Admission ID]
           FROM [Readmissions Link]
           WHERE [30D Readmission ID] IS NOT NULL) 
AS R
ON A.[Admission ID] = R.[Index Admission ID]
GROUP BY
    A.[Discharge Outcome]
ORDER BY
    [Total Admissions] DESC --8 index admissions resulting in death were linked to 30 day readmissions(data quality questioned)
  
    -- Investigate Readmissions Linked to Admissions Ending in Death
SELECT
    A.[Admission ID] AS [Index Admission ID],
    A.[Patient ID],
    A.[Discharge Outcome],
    A.[Discharge Date] AS [Index Discharge Date],
    R.[30D Readmission ID],
    A2.[Admission Date] AS [Readmission Date],
    A2.[Discharge Outcome] AS [Readmission Discharge Outcome]
FROM Admissions AS A
JOIN [Readmissions Link] AS R
    ON A.[Admission ID] = R.[Index Admission ID]
JOIN Admissions AS A2
    ON R.[30D Readmission ID] = A2.[Admission ID]
WHERE
    A.[Discharge Outcome] = 'Died'
    AND R.[30D Readmission ID] IS NOT NULL; --Revealed the 8 admissions resulting in death and still linked to readmissions
     -- Validate Patient Identity Across Linked Readmissions(ensuring that patient ID linked to Index admission ID and 30 Day readmission ID is the same
SELECT
    COUNT(*) AS [Total Linked Records],
    SUM(CASE
            WHEN A1.[Patient ID] = A2.[Patient ID] THEN 1
            ELSE 0
        END) 
    AS [Same Patient],
    SUM(CASE
            WHEN A1.[Patient ID] <> A2.[Patient ID] THEN 1
            ELSE 0
        END) 
    AS [Different Patients]
FROM [Readmissions Link] AS R
JOIN Admissions AS A1
    ON R.[Index Admission ID] = A1.[Admission ID]
JOIN Admissions AS A2
    ON R.[30D Readmission ID] = A2.[Admission ID]
WHERE R.[30D Readmission ID] IS NOT NULL;---Every linked readmission belongs to the same patient as its index admission.
    --Final Calculation for 30 Day readmission rate following discharge per Department
SELECT
    D.[Department],
    COUNT(A.[Admission ID]) AS [Total Home Discharges],
    COUNT(R.[Index Admission ID]) AS [Home Discharges With 30-Day Readmission],
    CAST(ROUND(COUNT(R.[Index Admission ID]) * 100.0
                                                   / COUNT(A.[Admission ID]),2) AS DECIMAL(10,2)) 
    AS [30-Day Readmission Rate (%)]
FROM Admissions AS A
JOIN Departments AS D
ON A.[Department ID] = D.[Department ID]
LEFT JOIN (SELECT DISTINCT[Index Admission ID]
           FROM [Readmissions Link]
           WHERE [30D Readmission ID] IS NOT NULL) 
AS R
ON A.[Admission ID] = R.[Index Admission ID]
WHERE A.[Discharge Outcome] = 'Home'
GROUP BY D.Department
ORDER BY [30-Day Readmission Rate (%)] DESC;
-- Investigate Readmission Links Following an Admission Marked as Died

SELECT
    A1.[Admission ID] AS [Index Admission ID],
    A1.[Patient ID] AS [Patient ID],
    A1.[Admission Date] AS [Index Admission Date],
    A1.[Discharge Date] AS [Index Discharge Date],
    A1.[Discharge Outcome] AS [Index Discharge Outcome],

    A2.[Admission ID] AS [Readmission ID],
    A2.[Admission Date] AS [Readmission Date],
    A2.[Discharge Date] AS [Readmission Discharge Date],
    A2.[Discharge Outcome] AS [Readmission Discharge Outcome],
    R.[Readmission Interval(days)] AS [Recorded Readmission Interval]
FROM [Readmissions Link] AS R
JOIN Admissions AS A1
    ON R.[Index Admission ID] = A1.[Admission ID]
JOIN Admissions AS A2
    ON R.[30D Readmission ID] = A2.[Admission ID]
WHERE
    R.[30D Readmission ID] IS NOT NULL
    AND A1.[Discharge Outcome] = 'Died'
ORDER BY
    A1.[Discharge Date];

   --Insight 6: Admissions by Department and Diagnosis Category

SELECT
    D.Department,
    DG.[Disease Category],
    COUNT(A.[Admission ID]) AS [Total Admissions]
FROM Admissions AS A
JOIN Departments AS D
    ON A.[Department ID] = D.[Department ID]
JOIN Diagnoses AS DG
    ON A.[Diagnosis ID] = DG.[Diagnosis ID]
GROUP BY
    D.Department,DG.[Disease Category]
ORDER BY
    D.Department,[Total Admissions] DESC;