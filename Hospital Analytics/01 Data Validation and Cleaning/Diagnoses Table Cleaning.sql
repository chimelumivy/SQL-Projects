SELECT *
FROM diagnoses

--Renaming the columns
EXEC sp_rename
'diagnoses.diagnosis_id', [Diagnosis ID], 'COLUMN'
EXEC sp_rename
'diagnoses.diagnosis_name', [Diagnosis], 'COLUMN'
EXEC sp_rename
'diagnoses.diagnosis_group', [Disease Category], 'COLUMN'

--Renaming fields
UPDATE diagnoses
SET [Disease Category] = 'Infectious Disease'
WHERE [Diagnosis]= 'Malaria'
UPDATE diagnoses
SET [Disease Category] = 'Respiratory Disorders'
WHERE [Diagnosis]= 'Pneumonia'
UPDATE diagnoses
SET [Disease Category] = 'Cardiovascular Disorders'
WHERE [Diagnosis]= 'Hypertension'
UPDATE diagnoses
SET [Disease Category] = 'Endocrine Disorders'
WHERE [Diagnosis]= 'Diabetes Mellitus'
UPDATE diagnoses
SET [Disease Category] = 'Surgical Conditions'
WHERE [Diagnosis]= 'Appendicitis'
UPDATE diagnoses
SET [Disease Category] = 'Trauma and Injury'
WHERE [Diagnosis]= 'Road traffic injury'
UPDATE diagnoses
SET [Disease Category] = 'Haematological Disorders'
WHERE [Diagnosis]= 'Sickle cell crisis'
UPDATE diagnoses
SET [Disease Category] = 'Gastrointestinal Disorders'
WHERE [Diagnosis]= 'Gastroenteritis'
UPDATE diagnoses
SET [Disease Category] = 'Cardiovascular Disorders'
WHERE [Diagnosis]= 'Heart Failure'
UPDATE diagnoses
SET [Disease Category] = 'Obstetric Conditions'
WHERE [Diagnosis]= 'Pregnancy-related condition'