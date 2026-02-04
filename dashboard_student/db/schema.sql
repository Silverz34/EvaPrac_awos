-- db/schema.sql

DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS groups CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS students CASCADE;

-- 1. Alumnos
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    email VARCHAR(255) NOT NULL UNIQUE,
    program VARCHAR(100) NOT NULL, 
    enrollment_year INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Profesores
CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

-- 3. Cursos (Materias)
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE, 
    name VARCHAR(100) NOT NULL,
    credits INTEGER NOT NULL CHECK (credits > 0)
);


CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(id),
    teacher_id INTEGER NOT NULL REFERENCES teachers(id),
    term VARCHAR(20) NOT NULL, -- Ejemplo: "2026-1"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Inscripciones (La tabla de unión)
-- Qué alumno está en qué grupo
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

-- 6. Calificaciones (Hijas de la inscripción)
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    partial1 DECIMAL(4,2) CHECK (partial1 >= 0 AND partial1 <= 10),
    partial2 DECIMAL(4,2) CHECK (partial2 >= 0 AND partial2 <= 10),
    final DECIMAL(4,2) CHECK (final >= 0 AND final <= 10),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Asistencia (Hijas de la inscripción)
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    enrollment_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    present BOOLEAN NOT NULL DEFAULT FALSE 
);