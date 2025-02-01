
DROP VIEW IF EXISTS public.latest_grades;

CREATE VIEW public.latest_grades
AS
SELECT id, grade, last_modified, batch_uuid FROM public.grades
ORDER BY id ASC;