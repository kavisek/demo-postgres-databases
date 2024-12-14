
DROP VIEW IF EXISTS demo.latest_grades;

CREATE VIEW demo.latest_grades
AS
SELECT id, grade, last_modified, batch_uuid FROM demo.grades
ORDER BY id ASC;