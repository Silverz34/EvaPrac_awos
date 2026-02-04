--cacade para eliminacion 
DROP TABLE IF EXISTS tabla_relacion CASCADE;
DROP TABLE IF EXISTS tabla_hija CASCADE;
DROP TABLE IF EXISTS tabla_padre CASCADE;


-- tabla student 
CREATE TABLE students(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    program VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE teacher(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
);

CREATE TABLE courses(
    id SERIAL PRIMARY KEY,
    code VARCHAR(225) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    credit DECIMAL(10, 2) NOT NULL CHECK (credit >= 0),
);

CREATE TABLE grupos(
    id SERIAL PRIMARY KEY,
    term VARCHAR(12) NOT NULL,
    courses_id INTEGER NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    teacher_id INTEGER NOT NULL REFERENCES teacher(id) ON DELETE CASCADE, 

    UNIQUE (courses_id, teacher_id)
);

-- tengo dudas en esta 
CREATE TABLE enrollments(
    id SERIAL PRIMARY KEY,
    students_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    grupos_id INTEGER NOT NULL REFERENCES grupos(id) ON DELETE RESTRICT,
);

CREATE TABLE grades(
    id SERIAL key,
    enrollments_id INTEGER NOT NULL REFERENCES enrollments(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE attendance(
    
);