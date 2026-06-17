-- =====================================================================
--  CLINICA VETERINARIA - Consultas de ejemplo (PostgreSQL)
-- ---------------------------------------------------------------------
--  Cada consulta es INDEPENDIENTE: pon el cursor en una y dale
--  Ctrl+Enter (Execute SQL Statement) para ver su resultado.
--  Requiere el esquema + los datos de ejemplo ya cargados.
-- =====================================================================

-- 1) AGENDA: proximas citas (programadas o confirmadas)
SELECT c.id_cita, c.fecha_hora,
       m.nombre AS mascota,
       cl.nombre || ' ' || cl.apellido AS dueno,
       v.nombre || ' ' || v.apellido AS veterinario,
       c.tipo_consulta, c.estado
FROM cita c
JOIN mascota m      ON m.id_mascota = c.id_mascota
JOIN cliente cl     ON cl.id_cliente = m.id_cliente
JOIN veterinario v  ON v.id_veterinario = c.id_veterinario
WHERE c.estado IN ('PROGRAMADA','CONFIRMADA')
ORDER BY c.fecha_hora;

-- 2) Citas de un dia especifico
SELECT c.fecha_hora, m.nombre AS mascota, c.motivo, c.estado
FROM cita c
JOIN mascota m ON m.id_mascota = c.id_mascota
WHERE c.fecha_hora::date = DATE '2026-05-04'
ORDER BY c.fecha_hora;

-- 3) Mascotas de un cliente (cambia el id_cliente = 1)
SELECT cl.nombre || ' ' || cl.apellido AS dueno,
       m.nombre AS mascota, e.nombre AS especie, r.nombre AS raza,
       m.sexo, m.peso_kg
FROM mascota m
JOIN cliente cl ON cl.id_cliente = m.id_cliente
JOIN raza r     ON r.id_raza = m.id_raza
JOIN especie e  ON e.id_especie = r.id_especie
WHERE cl.id_cliente = 1
ORDER BY m.nombre;

-- 4) HISTORIA CLINICA de una mascota (consultas + diagnostico)
SELECT m.nombre AS mascota, c.fecha_hora,
       co.motivo_consulta, co.diagnostico, co.temperatura, co.peso_actual
FROM consulta co
JOIN cita c     ON c.id_cita = co.id_cita
JOIN mascota m  ON m.id_mascota = c.id_mascota
WHERE m.id_mascota = 3
ORDER BY c.fecha_hora DESC;

-- 5) CUENTA de una cita: servicios y subtotal (cambia id_cita = 3)
SELECT c.id_cita, m.nombre AS mascota, s.nombre AS servicio,
       cs.cantidad, cs.precio_unitario,
       cs.cantidad * cs.precio_unitario AS subtotal
FROM cita_servicio cs
JOIN cita c     ON c.id_cita = cs.id_cita
JOIN mascota m  ON m.id_mascota = c.id_mascota
JOIN servicio s ON s.id_servicio = cs.id_servicio
WHERE c.id_cita = 3;

-- 6) Total facturado por estado de pago
SELECT estado_pago, COUNT(*) AS num_facturas, SUM(total) AS monto_total
FROM factura
GROUP BY estado_pago
ORDER BY monto_total DESC;

-- 7) Facturas PENDIENTES con su dueno
SELECT f.id_factura, cl.nombre || ' ' || cl.apellido AS cliente,
       f.total, f.fecha_emision
FROM factura f
JOIN cliente cl ON cl.id_cliente = f.id_cliente
WHERE f.estado_pago = 'PENDIENTE'
ORDER BY f.total DESC;

-- 8) Ingresos por veterinario (de citas con factura)
SELECT v.nombre || ' ' || v.apellido AS veterinario,
       COUNT(DISTINCT c.id_cita) AS citas_atendidas,
       COALESCE(SUM(f.total),0) AS total_facturado
FROM veterinario v
LEFT JOIN cita c    ON c.id_veterinario = v.id_veterinario
LEFT JOIN factura f ON f.id_cita = c.id_cita
GROUP BY v.id_veterinario, v.nombre, v.apellido
ORDER BY total_facturado DESC;

-- 9) Servicios mas solicitados (veces e ingresos)
SELECT s.nombre AS servicio,
       SUM(cs.cantidad) AS veces_realizado,
       SUM(cs.cantidad * cs.precio_unitario) AS ingresos
FROM cita_servicio cs
JOIN servicio s ON s.id_servicio = cs.id_servicio
GROUP BY s.id_servicio, s.nombre
ORDER BY ingresos DESC;

-- 10) Carnet de vacunas: dias que faltan para la proxima dosis
SELECT m.nombre AS mascota, va.nombre_vacuna,
       va.fecha_aplicacion, va.fecha_proxima,
       (va.fecha_proxima - CURRENT_DATE) AS dias_para_vencer
FROM vacuna va
JOIN mascota m ON m.id_mascota = va.id_mascota
ORDER BY va.fecha_proxima;

-- 11) Clientes con mas mascotas
SELECT cl.nombre || ' ' || cl.apellido AS cliente,
       COUNT(m.id_mascota) AS num_mascotas
FROM cliente cl
LEFT JOIN mascota m ON m.id_cliente = cl.id_cliente
GROUP BY cl.id_cliente, cl.nombre, cl.apellido
ORDER BY num_mascotas DESC, cliente;

-- 12) Edad de las mascotas (en anios)
SELECT m.nombre AS mascota, e.nombre AS especie, m.fecha_nacimiento,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento)) AS edad_anios
FROM mascota m
JOIN raza r    ON r.id_raza = m.id_raza
JOIN especie e ON e.id_especie = r.id_especie
ORDER BY edad_anios DESC;
