-- 1. Basic counts for each table
SELECT 'Teachers' as table_name, COUNT(*) as count FROM demo.teachers
UNION ALL
SELECT 'Classes', COUNT(*) FROM demo.classes
UNION ALL
SELECT 'Students', COUNT(*) FROM demo.students
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM demo.classes_students
UNION ALL
SELECT 'Grades', COUNT(*) FROM demo.grades;

-- 2. List teachers and their classes
SELECT 
    t.first_name,
    t.last_name,
    c.name as class_name,
    c.subject,
    COUNT(cs.student_id) as enrolled_students
FROM demo.teachers t
JOIN demo.classes c ON t.id = c.teacher_id
LEFT JOIN demo.classes_students cs ON c.id = cs.class_id
GROUP BY t.id, t.first_name, t.last_name, c.name, c.subject
ORDER BY t.last_name, t.first_name;

-- 3. Student performance report
SELECT 
    s.first_name,
    s.last_name,
    COUNT(g.id) as classes_taken,
    ROUND(AVG(g.grade), 2) as average_grade,
    MAX(g.grade) as highest_grade,
    MIN(g.grade) as lowest_grade
FROM demo.students s
LEFT JOIN demo.grades g ON s.id = g.student_id
GROUP BY s.id, s.first_name, s.last_name
ORDER BY average_grade DESC
LIMIT 10;

-- 4. Class performance summary
SELECT 
    c.name as class_name,
    t.last_name as teacher_name,
    COUNT(g.id) as total_students,
    ROUND(AVG(g.grade), 2) as class_average,
    MAX(g.grade) as highest_grade,
    MIN(g.grade) as lowest_grade
FROM demo.classes c
JOIN demo.teachers t ON c.teacher_id = t.id
LEFT JOIN demo.grades g ON c.id = g.class_id
GROUP BY c.id, c.name, t.last_name
ORDER BY class_average DESC;

-- 5. Students and their classes
SELECT 
    s.first_name,
    s.last_name,
    STRING_AGG(c.name, ', ') as enrolled_classes,
    STRING_AGG(g.grade::TEXT, ', ') as grades
FROM demo.students s
JOIN demo.classes_students cs ON s.id = cs.student_id
JOIN demo.classes c ON cs.class_id = c.id
LEFT JOIN demo.grades g ON cs.class_id = g.class_id AND cs.student_id = g.student_id
GROUP BY s.id, s.first_name, s.last_name
ORDER BY s.last_name, s.first_name
LIMIT 10;

-- 6. Find top performers in each class
WITH RankedGrades AS (
    SELECT 
        c.name as class_name,
        s.first_name,
        s.last_name,
        g.grade,
        RANK() OVER (PARTITION BY c.id ORDER BY g.grade DESC) as rank
    FROM demo.grades g
    JOIN demo.students s ON g.student_id = s.id
    JOIN demo.classes c ON g.class_id = c.id
)
SELECT *
FROM RankedGrades
WHERE rank = 1
ORDER BY class_name;

-- 7. Class enrollment distribution
SELECT 
    s.id as student_id,
    s.first_name,
    s.last_name,
    COUNT(cs.class_id) as number_of_classes
FROM demo.students s
LEFT JOIN demo.classes_students cs ON s.id = cs.student_id
GROUP BY s.id, s.first_name, s.last_name
HAVING COUNT(cs.class_id) > 0
ORDER BY number_of_classes DESC;