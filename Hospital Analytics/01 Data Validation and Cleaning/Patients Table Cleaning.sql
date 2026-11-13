SELECT *
from patients

---Renaming Columns
EXEC sp_rename
'patients.patient_id', [Patient ID], 'COLUMN'
EXEC sp_rename
'patients.date_of_birth', [Date of Birth], 'COLUMN'
EXEC sp_rename
'patients.sex', [Sex], 'COLUMN'
EXEC sp_rename
'patients.residence_state', [State of Residence], 'COLUMN'
EXEC sp_rename
'patients.insurance_status', [Insurance Status], 'COLUMN'


