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

