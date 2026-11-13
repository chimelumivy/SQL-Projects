SELECT * 
FROM departments
--Renaming the columns
EXEC sp_rename
'departments.department_id', [Department ID], 'COLUMN'
EXEC sp_rename
'departments.department_name', [Department], 'COLUMN'