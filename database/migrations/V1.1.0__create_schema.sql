-- Drop existing tables if they exist (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS demo.grades CASCADE;
DROP TABLE IF EXISTS demo.classes_students CASCADE;
DROP TABLE IF EXISTS demo.students CASCADE;
DROP TABLE IF EXISTS demo.classes CASCADE;
DROP TABLE IF EXISTS demo.teachers CASCADE;

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS demo;

-- Teachers table
CREATE TABLE IF NOT EXISTS demo.teachers (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Classes table
CREATE TABLE IF NOT EXISTS demo.classes (
    id BIGSERIAL PRIMARY KEY,
    teacher_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES demo.teachers (id)
);

-- Students table
CREATE TABLE IF NOT EXISTS demo.students (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Classes_students (junction table for many-to-many relationship)
CREATE TABLE IF NOT EXISTS demo.classes_students (
    class_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (class_id, student_id),
    FOREIGN KEY (class_id) REFERENCES demo.classes (id),
    FOREIGN KEY (student_id) REFERENCES demo.students (id)
);

-- Grades table
CREATE TABLE IF NOT EXISTS demo.grades (
    id BIGSERIAL PRIMARY KEY,
    class_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    grade NUMERIC(5,2) NOT NULL CHECK (grade >= 0 AND grade <= 100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES demo.classes (id),
    FOREIGN KEY (student_id) REFERENCES demo.students (id)
);

-- Set ownership
ALTER TABLE demo.teachers OWNER TO postgres;
ALTER TABLE demo.classes OWNER TO postgres;
ALTER TABLE demo.students OWNER TO postgres;
ALTER TABLE demo.classes_students OWNER TO postgres;
ALTER TABLE demo.grades OWNER TO postgres;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_classes_teacher_id ON demo.classes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_classes_students_class_id ON demo.classes_students(class_id);
CREATE INDEX IF NOT EXISTS idx_classes_students_student_id ON demo.classes_students(student_id);
CREATE INDEX IF NOT EXISTS idx_grades_class_id ON demo.grades(class_id);
CREATE INDEX IF NOT EXISTS idx_grades_student_id ON demo.grades(student_id);