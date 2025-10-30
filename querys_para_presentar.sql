-- Alumnos_clase:

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

-- Alumnos por profesor
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
    v.nombre AS vertical,
	p.mes AS promocion,
	pr.rol AS rol,
	pr.nombre AS profesor,
    pr.apellido AS apellido,
    COALESCE(ap.total_alumnos, 0) AS alumnos_matriculados
FROM profesor_promocion pp
JOIN profesor pr ON pp.id_profesor  = pr.id_profesor
JOIN promocion p ON pp.id_promocion = p.id_promocion
JOIN vertical v ON p.id_vertical   = v.id_vertical
LEFT JOIN alumnos_por_promo ap
       ON ap.id_promocion = p.id_promocion
ORDER BY vertical, promocion, rol;

-- Mostrar profesores por campus y vertical

SELECT c.nombre AS Campus, v.nombre AS Vertical, p.nombre AS nombre, p.apellido AS apellido, p.rol
FROM profesor p
JOIN campus c ON p.id_campus = c.id_campus
JOIN vertical v ON p.id_vertical = v.id_vertical
ORDER BY c.nombre, v.nombre;

-- Porcentaje de aptos y no aptos por proyecto dentro de cada vertical
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