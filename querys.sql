--- VISTA ALUMNO POR VERTICAL
CREATE VIEW Alumno_vertical
AS
SELECT alumno.nombre AS nombre, alumno.apellido AS apellido, vertical.id_vertical AS cod_vertical, vertical.nombre AS nombre_vertical
FROM promocion
INNER JOIN alumno ON alumno.id_promocion = promocion.id_promocion 
INNER JOIN vertical ON vertical.id_vertical = promocion.id_vertical;

--- VISTA PROFESORES
CREATE VIEW listado_profesores
AS
SELECT prof.nombre AS nombre, prof.apellido AS apellido, prof.rol AS rol, prof.modalidad AS modalidad, vert.id_vertical AS vertical, camp.nombre AS campus
FROM profesor_promocion AS prof_prom
INNER JOIN profesor AS prof ON prof.id_profesor = prof_prom.id_profesor
INNER JOIN campus AS camp ON camp.id_campus = prof.id_campus
INNER JOIN vertical AS vert ON vert.id_vertical = prof.id_vertical
ORDER BY campus, vertical, rol, apellido;

--- VERTICALES EN CADA CAMPUS
CREATE VIEW verticales_campus
AS
SELECT DISTINCT camp.nombre AS campus, vert.nombre AS vertical
FROM profesor AS prof
INNER JOIN campus AS camp ON camp.id_campus = prof.id_campus 
INNER JOIN vertical AS vert ON vert.id_vertical = prof.id_vertical
ORDER BY vertical, campus;

--- MATRICULADOS POR PROMOCION
CREATE VIEW matriculados_promocion
AS
SELECT
    prom.mes AS promocion,
	vert.nombre AS vertical,
    COUNT(al.id_alumno) AS alumnos_matriculados
FROM
    alumno AS al
JOIN
    promocion AS prom ON al.id_promocion  = prom.id_promocion
JOIN
    vertical AS vert ON vert.id_vertical  = prom.id_vertical
GROUP BY
    prom.mes,
	vert.nombre
ORDER BY
    promocion DESC; 

-- Mostrar profesores por campus y vertical
CREATE VIEW profesores_campus_vertical
AS
SELECT c.nombre AS Campus, v.nombre AS Vertical, p.nombre AS nombre, p.apellido AS apellido, p.rol
FROM profesor p
JOIN campus c ON p.id_campus = c.id_campus
JOIN vertical v ON p.id_vertical = v.id_vertical
ORDER BY c.nombre, v.nombre;

-- Query de Clases, Alumnos, Promocion, Vertical, Campus:
CREATE VIEW alumnos_clase
AS
SELECT
    a.nombre AS nombre,
	a.apellido AS apellido,
    c.nombre AS Clase,
    p.mes AS Promocion,
    v.nombre AS Vertical,
    ca.nombre AS Campus
FROM alumno a
JOIN alumno_clase ac ON a.id_alumno = ac.id_alumno
JOIN clase c ON ac.id_clase = c.id_clase
JOIN promocion p ON a.id_promocion = p.id_promocion
JOIN vertical v ON p.id_vertical = v.id_vertical
JOIN campus ca ON a.id_campus = ca.id_campus
ORDER BY v.nombre, p.mes, c.nombre, a.nombre;

-- matriculados verticales por campus 

CREATE VIEW verticales_campus_matriculados
AS
SELECT
    ca.nombre     AS campus,
    v.nombre      AS vertical,
    COUNT(a.id_alumno) AS alumnos_matriculados
FROM alumno a
JOIN promocion p ON a.id_promocion = p.id_promocion
JOIN vertical v  ON p.id_vertical  = v.id_vertical
JOIN campus ca   ON a.id_campus    = ca.id_campus
GROUP BY ca.nombre, v.nombre
ORDER BY ca.nombre, v.nombre;

--- alumnos por campus
CREATE VIEW alumnos_campus
AS
SELECT
    c.nombre AS campus,
    COUNT(a.id_alumno) AS total_alumnos
FROM alumno a
JOIN campus c ON a.id_campus = c.id_campus
GROUP BY c.nombre
ORDER BY total_alumnos DESC;

--- Promociones por vertical
CREATE VIEW promociones_vertical
AS
SELECT
    v.nombre AS vertical,
    COUNT(p.id_promocion) AS total_promociones
FROM vertical v
LEFT JOIN promocion p ON v.id_vertical = p.id_vertical
GROUP BY v.nombre
ORDER BY v.nombre

-- Proyecto - Alumno - Apto / No apto
CREATE VIEW alumnos_aptos
AS
SELECT a.nombre AS nombre, a.apellido AS apellido, p.nombre AS proyecto, e.resultado
FROM evaluacion e
JOIN alumno a ON e.id_alumno = a.id_alumno
JOIN proyecto p ON e.id_proyecto = p.id_proyecto
ORDER BY proyecto, apellido;

-- Profesores con el nº de alumnos de las promociones que imparten (incluye rol)
CREATE VIEW cuantos_alumnos_por_profesor
AS
WITH alumnos_por_promo AS (
    SELECT
        a.id_promocion,
        COUNT(*) AS total_alumnos
    FROM alumno a
    GROUP BY a.id_promocion
)
SELECT
    v.nombre        AS vertical,
	p.mes           AS promocion,
	pr.rol          AS rol,
	pr.nombre       AS profesor,
    pr.apellido     AS apellido,
    COALESCE(ap.total_alumnos, 0) AS alumnos_matriculados
FROM profesor_promocion pp
JOIN profesor pr     ON pp.id_profesor  = pr.id_profesor
JOIN promocion p     ON pp.id_promocion = p.id_promocion
JOIN vertical v      ON p.id_vertical   = v.id_vertical
LEFT JOIN alumnos_por_promo ap
       ON ap.id_promocion = p.id_promocion
ORDER BY vertical, promocion, rol;

-- Porcentaje de aptos y no aptos por proyecto dentro de cada vertical
CREATE VIEW porcentaje_aptos_por_proyecto
AS
WITH evals AS (
    SELECT
        v.nombre    AS vertical,
        prj.nombre  AS proyecto,
        e.resultado
    FROM evaluacion e
    JOIN alumno a     ON e.id_alumno = a.id_alumno
    JOIN promocion p  ON a.id_promocion = p.id_promocion
    JOIN vertical v   ON p.id_vertical  = v.id_vertical
    JOIN proyecto prj ON e.id_proyecto  = prj.id_proyecto
)
SELECT
    vertical,
    proyecto,
    COUNT(*) AS total_eval,
    -- conteos
    SUM(CASE WHEN resultado = 'Apto'    THEN 1 ELSE 0 END) AS total_apto,
    SUM(CASE WHEN resultado = 'No Apto' THEN 1 ELSE 0 END) AS total_no_apto,
    -- porcentajes
    ROUND(
        100.0 * SUM(CASE WHEN resultado = 'Apto' THEN 1 ELSE 0 END) / COUNT(*)
    , 2) AS pct_apto,
    ROUND(
        100.0 * SUM(CASE WHEN resultado = 'No Apto' THEN 1 ELSE 0 END) / COUNT(*)
    , 2) AS pct_no_apto
FROM evals
GROUP BY vertical, proyecto
ORDER BY vertical, pct_apto DESC;