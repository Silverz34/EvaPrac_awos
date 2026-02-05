-- db/seed.sql
-- Semillas para el esquema de la aplicación
-- Volumen moderado: 12 alumnos, 4 profesores, 6 cursos, 4 grupos, 24 inscripciones

BEGIN;

-- Cursos
INSERT INTO courses (id, code, name, credits) VALUES
(1, 'MAT101', 'Cálculo I', 4),
(2, 'PHY101', 'Física I', 4),
(3, 'CS101', 'Introducción a la Programación', 5),
(4, 'HIS101', 'Historia Universal', 3),
(5, 'ENG101', 'Inglés I', 2),
(6, 'BIO101', 'Biología I', 3);

-- Profesores
INSERT INTO teachers (id, name, email) VALUES
(1, 'Ana López', 'ana.lopez@uni.edu'),
(2, 'Carlos Mendoza', 'carlos.mendoza@uni.edu'),
(3, 'María Pérez', 'maria.perez@uni.edu'),
(4, 'Luis Gómez', 'luis.gomez@uni.edu');

-- Alumnos
INSERT INTO students (id, name, email, program, enrollment_year) VALUES
(1, 'Juan Fernández', 'juan.fernandez@student.edu', 'Ingeniería', 2024),
(2, 'Lucía Martínez', 'lucia.martinez@student.edu', 'Ingeniería', 2024),
(3, 'Pedro Sánchez', 'pedro.sanchez@student.edu', 'Medicina', 2023),
(4, 'Sofía Ramírez', 'sofia.ramirez@student.edu', 'Arquitectura', 2025),
(5, 'Diego Torres', 'diego.torres@student.edu', 'Derecho', 2022),
(6, 'Valentina Ruiz', 'valentina.ruiz@student.edu', 'Psicología', 2024),
(7, 'Mateo Castro', 'mateo.castro@student.edu', 'Ingeniería', 2023),
(8, 'Camila Ortiz', 'camila.ortiz@student.edu', 'Administración', 2025),
(9, 'Andrés Varela', 'andres.varela@student.edu', 'Medicina', 2024),
(10, 'Mariana Blanco', 'mariana.blanco@student.edu', 'Arquitectura', 2023),
(11, 'Diego Alvarez', 'diego.alvarez@student.edu', 'Derecho', 2024),
(12, 'Natalia Rojas', 'natalia.rojas@student.edu', 'Psicología', 2022);

-- Grupos (cada grupo es una oferta de curso con un profesor en un término)
INSERT INTO groups (id, course_id, teacher_id, term) VALUES
(1, 1, 1, '2026-1'),
(2, 2, 2, '2026-1'),
(3, 3, 3, '2026-1'),
(4, 4, 4, '2026-1');

-- Inscripciones: cada alumno se inscribe en 2 grupos (volumen moderado)
-- Distribución: alumnos 1-6 -> grupos 1 y 2 ; alumnos 7-12 -> grupos 3 y 4
INSERT INTO enrollments (id, student_id, group_id, enrolled_at) VALUES
(1, 1, 1, NOW()),
(2, 1, 2, NOW()),
(3, 2, 1, NOW()),
(4, 2, 2, NOW()),
(5, 3, 1, NOW()),
(6, 3, 2, NOW()),
(7, 4, 1, NOW()),
(8, 4, 2, NOW()),
(9, 5, 1, NOW()),
(10, 5, 2, NOW()),
(11, 6, 1, NOW()),
(12, 6, 2, NOW()),
(13, 7, 3, NOW()),
(14, 7, 4, NOW()),
(15, 8, 3, NOW()),
(16, 8, 4, NOW()),
(17, 9, 3, NOW()),
(18, 9, 4, NOW()),
(19, 10, 3, NOW()),
(20, 10, 4, NOW()),
(21, 11, 3, NOW()),
(22, 11, 4, NOW()),
(23, 12, 3, NOW()),
(24, 12, 4, NOW());

-- Calificaciones (valores de ejemplo, escala 0-10)
INSERT INTO grades (id, enrollment_id, partial1, partial2, final) VALUES
(1, 1, 7.5, 8.0, 8.2),
(2, 2, 6.0, 6.5, 7.0),
(3, 3, 9.0, 8.8, 9.2),
(4, 4, 5.5, 6.0, 6.0),
(5, 5, 7.0, 7.5, 7.8),
(6, 6, 8.2, 8.0, 8.5),
(7, 7, 6.8, 7.0, 7.1),
(8, 8, 7.9, 8.1, 8.0),
(9, 9, 5.0, 5.5, 6.0),
(10, 10, 9.5, 9.0, 9.3),
(11, 11, 6.2, 6.8, 7.0),
(12, 12, 8.0, 7.5, 8.1),
(13, 13, 7.3, 7.6, 7.5),
(14, 14, 6.5, 6.9, 7.0),
(15, 15, 8.8, 9.0, 9.1),
(16, 16, 5.7, 6.0, 6.2),
(17, 17, 7.0, 7.4, 7.6),
(18, 18, 8.3, 8.5, 8.4),
(19, 19, 6.0, 6.2, 6.5),
(20, 20, 7.7, 8.0, 8.1),
(21, 21, 5.9, 6.1, 6.3),
(22, 22, 8.4, 8.6, 8.5),
(23, 23, 7.2, 7.0, 7.3),
(24, 24, 6.8, 6.9, 7.0);

-- Asistencia: 2 fechas por inscripción (presente = TRUE/FALSE)
-- Fechas de ejemplo: 2026-02-01 y 2026-02-08
INSERT INTO attendance (id, enrollment_id, date, present) VALUES
(1, 1, '2026-02-01', TRUE),
(2, 1, '2026-02-08', TRUE),
(3, 2, '2026-02-01', FALSE),
(4, 2, '2026-02-08', TRUE),
(5, 3, '2026-02-01', TRUE),
(6, 3, '2026-02-08', TRUE),
(7, 4, '2026-02-01', TRUE),
(8, 4, '2026-02-08', FALSE),
(9, 5, '2026-02-01', TRUE),
(10, 5, '2026-02-08', TRUE),
(11, 6, '2026-02-01', FALSE),
(12, 6, '2026-02-08', TRUE),
(13, 7, '2026-02-01', TRUE),
(14, 7, '2026-02-08', TRUE),
(15, 8, '2026-02-01', TRUE),
(16, 8, '2026-02-08', TRUE),
(17, 9, '2026-02-01', FALSE),
(18, 9, '2026-02-08', FALSE),
(19, 10, '2026-02-01', TRUE),
(20, 10, '2026-02-08', TRUE),
(21, 11, '2026-02-01', TRUE),
(22, 11, '2026-02-08', FALSE),
(23, 12, '2026-02-01', TRUE),
(24, 12, '2026-02-08', TRUE),
(25, 13, '2026-02-01', TRUE),
(26, 13, '2026-02-08', TRUE),
(27, 14, '2026-02-01', FALSE),
(28, 14, '2026-02-08', TRUE),
(29, 15, '2026-02-01', TRUE),
(30, 15, '2026-02-08', TRUE),
(31, 16, '2026-02-01', TRUE),
(32, 16, '2026-02-08', FALSE),
(33, 17, '2026-02-01', TRUE),
(34, 17, '2026-02-08', TRUE),
(35, 18, '2026-02-01', FALSE),
(36, 18, '2026-02-08', TRUE),
(37, 19, '2026-02-01', TRUE),
(38, 19, '2026-02-08', TRUE),
(39, 20, '2026-02-01', TRUE),
(40, 20, '2026-02-08', TRUE),
(41, 21, '2026-02-01', FALSE),
(42, 21, '2026-02-08', TRUE),
(43, 22, '2026-02-01', TRUE),
(44, 22, '2026-02-08', TRUE),
(45, 23, '2026-02-01', TRUE),
(46, 23, '2026-02-08', FALSE),
(47, 24, '2026-02-01', TRUE),
(48, 24, '2026-02-08', TRUE);

-- Ajustar secuencias para mantener coherencia si se insertaron IDs explícitos
SELECT setval(pg_get_serial_sequence('students','id'), (SELECT COALESCE(MAX(id),0) FROM students));
SELECT setval(pg_get_serial_sequence('teachers','id'), (SELECT COALESCE(MAX(id),0) FROM teachers));
SELECT setval(pg_get_serial_sequence('courses','id'), (SELECT COALESCE(MAX(id),0) FROM courses));
SELECT setval(pg_get_serial_sequence('groups','id'), (SELECT COALESCE(MAX(id),0) FROM groups));
SELECT setval(pg_get_serial_sequence('enrollments','id'), (SELECT COALESCE(MAX(id),0) FROM enrollments));
SELECT setval(pg_get_serial_sequence('grades','id'), (SELECT COALESCE(MAX(id),0) FROM grades));
SELECT setval(pg_get_serial_sequence('attendance','id'), (SELECT COALESCE(MAX(id),0) FROM attendance));

COMMIT;
