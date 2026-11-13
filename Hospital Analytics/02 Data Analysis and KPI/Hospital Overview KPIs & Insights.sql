/* =========================================
   1. HOSPITAL OPERATIONS OVERVIEW
   ========================================= */

---1.1 HOSPITAL OPERATIONS OVERVIEW → Key Performance Indicators

    -- KPI 1: Total unique patients admitted
SELECT
    COUNT(DISTINCT [Patient ID]) AS [Total Patients Admitted]
FROM Admissions;
    -- KPI 2: Total admissions
SELECT
    COUNT(*) AS TotalAdmissions
FROM Admissions;
    -- KPI 3: Total hospitalization fees
SELECT
    SUM([Hospitalization Fee(NGN)]) AS [Total Hospitalization Revenue]
FROM Admissions;
    -- KPI 4: Average length of stay
SELECT
    AVG([Admission Period(days)]) AS [Average Admission Period]
FROM Admissions;
    -- KPI 5: Average hospitalization fee
SELECT
    AVG([Hospitalization Fee(NGN)]) AS [Average Hospitalization Fee]
FROM Admissions;
---1.2 HOSPITAL OPERATIONS OVERVIEW → Insights

   --Insight 1: Monthly and yearly admission trends
  SELECT
    YEAR([Admission Date]) AS [Admission Year],
    MONTH([Admission Date]) AS [Admission Month Number],
    DATENAME(MONTH, [Admission Date]) AS [Admission Month],
    COUNT(*) AS [Total Admissions]
FROM Admissions
GROUP BY
    YEAR([Admission Date]),
    MONTH([Admission Date]),
    DATENAME(MONTH, [Admission Date])
ORDER BY
    [Admission Year],
[Admission Month Number]
   -- Insignt 2: Total hospitalization fees by year
SELECT
    YEAR([Admission Date]) AS [Admission Year],
    SUM([Hospitalization Fee(NGN)]) AS [Total Hospitalization Fees]
FROM Admissions
GROUP BY YEAR([Admission Date])
ORDER BY  [Admission Year];
   -- Insight 3: Admissions by admission type
SELECT
    [Admission Type],
    COUNT(*) AS [Total Admissions]
FROM Admissions
GROUP BY [Admission Type]
ORDER BY [Total Admissions] DESC;
   -- Insight 4. Average Admission Period by diagnosis

SELECT
    d.Diagnosis,
    ROUND(AVG(a.[Admission Period(days)]), 2) AS [Average Admission Period(days)]
FROM Admissions AS a
INNER JOIN Diagnoses AS d
    ON a.[Diagnosis ID] = d.[Diagnosis ID]
GROUP BY d.Diagnosis
ORDER BY [Average Admission Period(days)] DESC;
   -- Insight 5: Average hospitalization fee by disease category
SELECT
    d.[Disease Category],
    ROUND(AVG(a.[Hospitalization Fee(NGN)]), 2) AS [Average Hospitalization Fee(NGN)]
FROM Admissions AS a
INNER JOIN Diagnoses AS d
    ON a.[Diagnosis ID] = d.[Diagnosis ID]
GROUP BY d.[Disease Category]
ORDER BY [Average Hospitalization Fee(NGN)] DESC;
   -- Insight 6: Average hospitalization fee by Admission Type
SELECT
    [Admission Type],
    ROUND(AVG([Hospitalization Fee(NGN)]), 2) AS [Average Hospitalization Fee]
FROM Admissions
GROUP BY [Admission Type]
ORDER BY [Average Hospitalization Fee] DESC;


/* =========================================
   2. SQL VIEWS FOR POWER BI
   ========================================= */

--- HOSPITAL OPERATIONS OVERVIEW→ KPI View-------


CREATE OR ALTER VIEW [dbo].[Hospital Operations KPIs]
AS
SELECT
    COUNT(DISTINCT [Patient ID]) AS [Total Patients Admitted],
    COUNT(*) AS [Total Admissions],
    SUM([Hospitalization Fee(NGN)]) AS [Total Hospitalization Fees],
    CAST(AVG(CAST([Admission Period(days)] AS DECIMAL(10,2))) AS DECIMAL(10,2))
        AS [Average Admission Period (days)],
    CAST(AVG([Hospitalization Fee(NGN)]) AS DECIMAL(18,2))
        AS [Average Hospitalization Fee]
FROM Admissions;

------HOSPITAL OPERATIONS OVERVIEW→ Insights View------

-----ADMISSIONS BY YEAR AND MONTH
CREATE OR ALTER VIEW [dbo].[Admissions by Year and Month]
AS
SELECT
    YEAR([Admission Date]) AS [Admission Year],
    MONTH([Admission Date]) AS [Admission Month Number],
    DATENAME(MONTH, [Admission Date]) AS [Admission Month],
    COUNT(*) AS [Total Admissions]
FROM Admissions
GROUP BY
    YEAR([Admission Date]),
    MONTH([Admission Date]),
    DATENAME(MONTH, [Admission Date]);

GO

-- HOSPITALIZATION FEES BY YEAR

CREATE OR ALTER VIEW [dbo].[Hospitalization Fees by Year]
AS
SELECT
    YEAR([Admission Date]) AS [Admission Year],
    SUM([Hospitalization Fee(NGN)]) AS [Total Hospitalization Revenue]
FROM Admissions
GROUP BY YEAR([Admission Date]);

GO

--ADMISSIONS BY ADMISSION TYPE

CREATE OR ALTER VIEW [dbo].[Admissions by Admission Type]
AS
SELECT
    [Admission Type],
    COUNT(*) AS [Total Admissions]
FROM Admissions
GROUP BY [Admission Type];

GO

--AVERAGE LENGTH OF STAY BY DIAGNOSIS

CREATE OR ALTER VIEW [dbo].[Average Admission Period by Diagnosis]
AS
SELECT
    d.Diagnosis AS [Diagnosis],
    ROUND(AVG(a.[Admission Period(days)]), 2)
        AS [Average Admission Period (days)]
FROM Admissions AS a
INNER JOIN Diagnoses AS d
    ON a.[Diagnosis ID] = d.[Diagnosis ID]
GROUP BY d.Diagnosis;

GO

--AVERAGE HOSPITALIZATION FEE BY DISEASE CATEGORY

CREATE OR ALTER VIEW [dbo].[Average Hospitalization Fee by Disease Category]
AS
SELECT
    d.[Disease Category] AS [Disease Category],
    ROUND(AVG(a.[Hospitalization Fee(NGN)]), 2)
        AS [Average Hospitalization Fee]
FROM Admissions AS a
INNER JOIN Diagnoses AS d
    ON a.[Diagnosis ID] = d.[Diagnosis ID]
GROUP BY d.[Disease Category];

GO

--AVERAGE HOSPITALIZATION FEE BY ADMISSION TYPE

CREATE OR ALTER VIEW [dbo].[Average Hospitalization Fee by Admission Type]
AS
SELECT
    [Admission Type] AS [Admission Type],
    ROUND(AVG([Hospitalization Fee(NGN)]), 2)
        AS [Average Hospitalization Fee]
FROM Admissions
GROUP BY [Admission Type];

GO
-----VIEWING ALL CREATED VISUALS-----
-- 1. KPIs
SELECT * FROM [dbo].[Hospital Operations KPIs];

-- 2. Admissions by Year and Month
SELECT * FROM [dbo].[Admissions by Year and Month];

-- 3. Hospitalization Fees by Year
SELECT * FROM [dbo].[Hospitalization Fees by Year];

-- 4. Admissions by Admission Type
SELECT * FROM [dbo].[Admissions by Admission Type];

-- 5. Average Length of Stay by Diagnosis
SELECT * FROM [dbo].[Average Admission Period by Diagnosis];

-- 6. Average Fee by Disease Category
SELECT * FROM [dbo].[Average Hospitalization Fee by Disease Category];

-- 7. Average Fee by Admission Type
SELECT * FROM [dbo].[Average Hospitalization Fee by Admission Type];