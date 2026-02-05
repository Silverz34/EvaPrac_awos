

DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS students CASCADE;

-- 1. Alumnos
-- Requisito: students(id, name, email, program, enrollment_year) 
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    program VARCHAR(100) NOT NULL,
    enrollment_year INTEGER NOT NULL
);

-- 2. Profesores
-- Requisito: teachers(id, name, email)
CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

-- 3. Cursos
-- Requisito: courses(id, code, name, credits) 
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL CHECK (credits > 0) 
);

-- 4. Grupos
-- Requisito: groups(id, course_id, teacher_id, term) 
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(id),
    teacher_id INTEGER NOT NULL REFERENCES teachers(id),
    term VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- 5. Inscripciones
-- Requisito: enrollments(id, student_id, group_id, enrolled_at)
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Requerido por PDF [cite: 13]
    UNIQUE(student_id, group_id) -- Evita duplicados lógicos
);

-- 6. Calificaciones
-- Requisito: grades(id, enrollment_id, partial1, partial2, final) [cite: 14]
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    partial1 DECIMAL(4,2) CHECK (partial1 >= 0 AND partial1 <= 10),
    partial2 DECIMAL(4,2) CHECK (partial2 >= 0 AND partial2 <= 10),
    final DECIMAL(4,2) CHECK (final >= 0 AND final <= 10),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- 7. Asistencia
-- Requisito: attendance(id, enrollment_id, date, present)
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    date DATE NOT NULL, 
    present BOOLEAN NOT NULL DEFAULT FALSE
);