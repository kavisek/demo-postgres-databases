-- Drop existing tables if they exist (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS public.grades CASCADE;
DROP TABLE IF EXISTS public.classes_students CASCADE;
DROP TABLE IF EXISTS public.students CASCADE;
DROP TABLE IF EXISTS public.classes CASCADE;
DROP TABLE IF EXISTS public.teachers CASCADE;

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS public;

-- Teachers table
CREATE TABLE IF NOT EXISTS public.teachers (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Classes table
CREATE TABLE IF NOT EXISTS public.classes (
    id BIGSERIAL PRIMARY KEY,
    teacher_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES public.teachers (id)
);

-- Students table
CREATE TABLE IF NOT EXISTS public.students (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Classes_students (junction table for many-to-many relationship)
CREATE TABLE IF NOT EXISTS public.classes_students (
    class_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (class_id, student_id),
    FOREIGN KEY (class_id) REFERENCES public.classes (id),
    FOREIGN KEY (student_id) REFERENCES public.students (id)
);

-- Grades table
CREATE TABLE IF NOT EXISTS public.grades (
    id BIGSERIAL PRIMARY KEY,
    class_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    grade NUMERIC(5,2) NOT NULL CHECK (grade >= 0 AND grade <= 100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES public.classes (id),
    FOREIGN KEY (student_id) REFERENCES public.students (id)
);

-- Set ownership
ALTER TABLE public.teachers OWNER TO postgres;
ALTER TABLE public.classes OWNER TO postgres;
ALTER TABLE public.students OWNER TO postgres;
ALTER TABLE public.classes_students OWNER TO postgres;
ALTER TABLE public.grades OWNER TO postgres;

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_classes_teacher_id ON public.classes(teacher_id);
CREATE INDEX IF NOT EXISTS idx_classes_students_class_id ON public.classes_students(class_id);
CREATE INDEX IF NOT EXISTS idx_classes_students_student_id ON public.classes_students(student_id);
CREATE INDEX IF NOT EXISTS idx_grades_class_id ON public.grades(class_id);
CREATE INDEX IF NOT EXISTS idx_grades_student_id ON public.grades(student_id);