/*
VIEW 1: vw_course_performance
REPORTE 1: Rendimiento por curso 
Qué devuelve: lista de cursos con acantidad de alumnos reprobados
Grain (una fila representa): un curso
Métrica(s): reprobados SUM(CASE WHEN), tasa_aprobados(ROUND (SUM(CASE WHEN)/COUNT(*))*100,2), 
promedio_general(ROUND(AVG(final),2))
Por qué GROUP BY / HAVING / subconsulta: HAVING para filtrar cursos que
tuvieron al menos 1 alumno COUNT(e.id) > 0
*/
-- VIEW
CREATE OR REPLACE VIEW vw_course_performance AS
SELECT 
    c.name AS materia,               
    g.term AS periodo,               
    c.code AS clave,                 
    COUNT(e.id) AS total_alumnos,    
    SUM(CASE WHEN gr.final < 6.0 THEN 1 ELSE 0 END) AS reprobados,
    ROUND((SUM(CASE WHEN gr.final < 6.0 THEN 1 ELSE 0 END)::numeric / NULLIF(COUNT(e.id), 0) * 100), 2) AS tasa_reprobacion,
    ROUND(AVG(gr.final), 2) AS promedio_general
FROM courses c
JOIN groups g ON c.id = g.course_id
LEFT JOIN enrollments e ON g.id = e.group_id
LEFT JOIN grades gr ON e.id = gr.enrollment_id
GROUP BY c.id, c.name, c.code, g.term
HAVING COUNT(e.id) > 0;

-- VERIFY: 
SELECT * FROM vw_course_performance ORDER BY materia, periodo;

---------------------------------------------------------------------------------------------------------------------------------
/*
VIEW 2: vw_teacher_load
REPORTE 2: Carga de trabajo por profesor 
Qué devuelve: lista de maestros con su carga de alumnos y desempeño de sus alumnos.
Grain (una fila representa): un maestro
Métrica(s): cantidad de grupos COUNT(DISTINCT g.id), cantidad alumnos COUNT(e.id), 
desempeño promedio de alumnos ROUND(AVG(gr.final),2)
Por qué GROUP BY / HAVING / subconsulta: HAVING para filtrar  que
tuvieron al menos 1 alumno COUNT(e.id) > 0
*/
-- VIEW
CREATE VIEW vw_teacher_load AS
SELECT 
    t.id AS id,
    t.name AS nombre
    g.term AS periodo
    COUNT(DISTINCT g.id) AS total_grupos,
    COUNT(e.id) AS total_estudiantes,
    COALESCE(ROUND(AVG(gr.final), 2), 0) AS desempeño_promedio
FROM teachers t
JOIN groups g ON t.id = g.teacher_id
LEFT JOIN enrollments e ON g.id = e.group_id
LEFT JOIN grades gr ON e.id = gr.enrollment_id
GROUP BY t.id, t.name, g.term
HAVING COUNT(e.id) > 0;

-- VERIFY:
SELECT * FROM vw_teacher_load ORDER BY nombre, total_grupos;

------------------------------------------------------------------------------------------------------
/*
VIEW 3: vw_students_at_risk 
REPORTE 3: alumnos en riesgo académico
Qué devuelve: casos distintos de riesgo académico 
Grain (una fila representa): un alumno
Métrica(s): promedio general AVG(COALESCE(gr.final, 0)), asistencia baja AVG(CASE WHEN a.present) )
Por qué GROUP BY / HAVING / subconsulta: CASE para mostrar mensajes, dependiendo la validacion.
WHERE para filtar alumnos con promedio < 6.0 o asistencia < 75%
*/

-- VIEW
CREATE VIEW vw_students_at_risk AS
WITH estudiante_status AS (
    SELECT 
        s.id AS id,
        s.name AS nombre_alumno,
        s.email AS correo,
        s.program AS licenciatura,
        AVG(COALESCE(gr.final, 0)) AS promedio_general,
        AVG(CASE WHEN a.present THEN 100 ELSE 0 END) AS asistencia
    FROM students s
    JOIN enrollments e ON s.id = e.student_id
    LEFT JOIN grades gr ON e.id = gr.enrollment_id
    LEFT JOIN attendance a ON e.id = a.enrollment_id
    GROUP BY s.id, s.name, s.email, s.program
)
SELECT 
    id,
    nombre_alumno,
    correo,
    licenciatura,
    ROUND(promedio_general, 2) AS current_avg,
    ROUND(asistencia, 2) AS attendance_pct,
    CASE 
        WHEN promedio_general < 6.0 AND asistencia < 75 THEN 'CRITICO: Académico y Asistencia'
        WHEN promedio_general < 6.0 THEN 'Riesgo Académico'
        ELSE 'Riesgo Asistencia'
    END AS riesgo_academico
FROM estudiante_status
WHERE promedio_general < 6.0 OR asistencia< 75;

-- VERIFY:
SELECT * FROM vw_students_at_risk ORDER BY nombre_alumno;

---------------------------------------------------------------------------------------------------------------------------------
/*
VIEW 4:vw_attendance_by_group
REPORTE 4: asistencia promedio por grupo 
Qué devuelve: lista de grupos con su asistencia promedio
Grain (una fila representa): un grupo 
Métrica(s): registro de asistencia (AVG(CASE WHEN )), sesiones totales COUNT(DISTINCT a.date)
Por qué GROUP BY / HAVING / subconsulta: COALESCE para manejar casos sin registros de asistencia. 
GROUP BY para agrupar las columnas.
*/

CREATE VIEW vw_attendance_by_group AS
SELECT 
    g.id AS id,
    c.name AS nombre_curso,
    g.term AS periodo,
    t.name AS maestro_nombre,
    COALESCE(
        ROUND(AVG(CASE WHEN a.present THEN 1.0 ELSE 0.0 END) * 100, 2), 
        0
    ) AS asistencia_promedio,
    COUNT(DISTINCT a.date) AS sesiones_totales
FROM groups g
JOIN courses c ON g.course_id = c.id
JOIN teachers t ON g.teacher_id = t.id
JOIN enrollments e ON g.id = e.group_id
LEFT JOIN attendance a ON e.id = a.enrollment_id
GROUP BY g.id, c.name, g.term, t.name;

-- VERIFY:
SELECT * FROM vw_attendance_by_group;

-----------------------------------------------------------------------------------------------------------
/*
VIEW 5: vw_rank_students 
REPORTE 5: cuadro de honor  
Qué devuelve: ranking de estudiantes con mejor desempeño
Grain (una fila representa): un estudiante
Métrica(s): promedio final ROUND(AVG(gr.final),2).
Por qué GROUP BY / HAVING / subconsulta: RANK para asignar posiciones, dependiendo el promedio final. 
ORDER BY para ordenar el ranking de mayor a menor desempeño.
*/

CREATE VIEW vw_rank_students AS
SELECT 
    s.id AS id,
    s.name AS nombre_alumno,
    s.program licenciatura,
    g.term AS periodo,
    ROUND(AVG(gr.final), 2) AS promedio_final,
    RANK() OVER (
        PARTITION BY s.program, g.term 
        ORDER BY AVG(gr.final) DESC
    ) AS ranking 
FROM students s
JOIN enrollments e ON s.id = e.student_id
JOIN groups g ON e.group_id = g.id
JOIN grades gr ON e.id = gr.enrollment_id
GROUP BY s.id, s.name, s.program, g.term
ORDER BY s.program, ranking;

-- VERIFY:
SELECT * FROM vw_rank_students WHERE ranking <= 3;
