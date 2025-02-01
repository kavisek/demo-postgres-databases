-- Clear existing data (in correct order due to foreign key constraints)
TRUNCATE TABLE public.grades CASCADE;
TRUNCATE TABLE public.classes_students CASCADE;
TRUNCATE TABLE public.students CASCADE;
TRUNCATE TABLE public.classes CASCADE;
TRUNCATE TABLE public.teachers CASCADE;

-- Insert Teachers
INSERT INTO public.teachers (first_name, last_name, email) VALUES
    ('John', 'Smith', 'john.smith@school.edu'),
    ('Maria', 'Garcia', 'maria.garcia@school.edu'),
    ('James', 'Johnson', 'james.johnson@school.edu'),
    ('Sarah', 'Williams', 'sarah.williams@school.edu'),
    ('Michael', 'Brown', 'michael.brown@school.edu'),
    ('Lisa', 'Davis', 'lisa.davis@school.edu'),
    ('Robert', 'Miller', 'robert.miller@school.edu'),
    ('Jennifer', 'Wilson', 'jennifer.wilson@school.edu');

-- Insert Classes (using subqueries to get the actual teacher IDs)
INSERT INTO public.classes (teacher_id, name, subject)
SELECT
    t.id,
    c.name,
    c.subject
FROM (
    VALUES
        (1, 'Advanced Mathematics', 'Mathematics'),
        (2, 'World History', 'History'),
        (3, 'Physics 101', 'Science'),
        (4, 'English Literature', 'English'),
        (5, 'Chemistry Basics', 'Science'),
        (6, 'Spanish I', 'Languages'),
        (7, 'Computer Science', 'Technology'),
        (8, 'Biology', 'Science')
) AS c(teacher_num, name, subject)
JOIN public.teachers t ON t.id = (
    SELECT id FROM public.teachers ORDER BY id LIMIT 1 OFFSET (c.teacher_num - 1)
);

-- Insert 100 Students
INSERT INTO public.students (first_name, last_name, email)
SELECT
    'Student_' || id::text,
    'LastName_' || id::text,
    'student' || id::text || '@school.edu'
FROM generate_series(1, 100) AS id;

-- Enroll students in classes (each student takes 4 classes)
INSERT INTO public.classes_students (class_id, student_id)
SELECT 
    classes.id AS class_id,
    students.id AS student_id
FROM public.students
CROSS JOIN public.classes
WHERE 
    -- Students with ID % 2 = 0 take Mathematics, History, Physics, and English
    (students.id % 2 = 0 AND classes.subject IN ('Mathematics', 'History', 'Science', 'English'))
    OR
    -- Students with ID % 2 = 1 take Chemistry, Spanish, Computer Science, and Biology
    (students.id % 2 = 1 AND classes.subject IN ('Science', 'Languages', 'Technology', 'Science'))
ORDER BY students.id, classes.id;

-- Insert Grades (using a deterministic pattern)
INSERT INTO public.grades (class_id, student_id, grade)
SELECT 
    class_id,
    student_id,
    CASE 
        WHEN student_id % 4 = 0 THEN 95  -- Top students
        WHEN student_id % 4 = 1 THEN 85  -- Above average students
        WHEN student_id % 4 = 2 THEN 75  -- Average students
        ELSE 65                          -- Below average students
    END as grade
FROM public.classes_students;
