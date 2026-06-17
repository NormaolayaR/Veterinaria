-- =====================================================================
--  CLINICA VETERINARIA - Datos de ejemplo (PostgreSQL)
-- ---------------------------------------------------------------------
--  Ejecutar DESPUES de crear el esquema (usa especie/raza/servicio que
--  ya carga el script del esquema: especie 1-4, raza 1-3, servicio 1-4).
--  Re-ejecutable: vacia las tablas transaccionales antes de insertar.
--  En DBeaver: conectate a clinica_veterinaria y usa
--              menu SQL Editor -> Execute SQL Script.
-- =====================================================================

-- Vacia las tablas de datos (NO toca los catalogos especie/raza/servicio)
TRUNCATE cliente, veterinario, mascota, cita, cita_servicio,
         consulta, tratamiento, vacuna, factura
  RESTART IDENTITY CASCADE;

-- CLIENTES (quedan con id 1..5)
INSERT INTO cliente (tipo_documento, num_documento, nombre, apellido, telefono, email, direccion) VALUES
  ('CC','1018203040','Ana Maria','Gomez',    '3001112233','ana.gomez@email.com',  'Calle 12 #4-56, Bogota'),
  ('CC','79854123',  'Carlos',   'Rodriguez','3104445566','carlos.r@email.com',   'Carrera 70 #45-10, Medellin'),
  ('CC','1032567890','Laura',    'Martinez', '3157778899','laura.m@email.com',    'Av 6N #23-15, Cali'),
  ('CE','456789',    'Jorge',    'Perez',    '3200001122','jorge.perez@email.com','Calle 100 #15-20, Bogota'),
  ('CC','1144556677','Sofia',    'Ramirez',  '3019998877','sofia.r@email.com',    'Cra 51B #80-22, Barranquilla');

-- VETERINARIOS (id 1..3)
INSERT INTO veterinario (nombre, apellido, num_documento, num_licencia, especialidad, telefono, email) VALUES
  ('Andres','Torres','80112233','MV-12345','Medicina general','3011234567','a.torres@vetwala.com'),
  ('Diana', 'Lopez', '52334455','MV-67890','Cirugia',         '3022345678','d.lopez@vetwala.com'),
  ('Felipe','Castro','94556677','MV-11223','Dermatologia',    '3033456789','f.castro@vetwala.com');

-- MASCOTAS (id 1..6)  | id_cliente 1..5, id_raza 1..3 (Labrador, Chihuahua, Siames)
INSERT INTO mascota (id_cliente, id_raza, nombre, sexo, fecha_nacimiento, peso_kg, color, microchip, esterilizado) VALUES
  (1,1,'Firulais','M','2020-05-10',28.5,'Dorado','900000000000001',TRUE),
  (1,3,'Michi',   'H','2021-03-15', 4.2,'Gris',  '900000000000002',FALSE),
  (2,2,'Rocky',   'M','2019-11-20', 3.1,'Cafe',  '900000000000003',TRUE),
  (3,3,'Luna',    'H','2022-01-05', 3.8,'Blanco','900000000000004',FALSE),
  (4,1,'Max',     'M','2018-07-30',32.0,'Negro', '900000000000005',TRUE),
  (5,2,'Nina',    'H','2023-02-14', 2.5,'Crema', '900000000000006',FALSE);

-- CITAS (id 1..6) | id_mascota 1..6, id_veterinario 1..3
INSERT INTO cita (id_mascota, id_veterinario, fecha_hora, motivo, tipo_consulta, estado) VALUES
  (1,1,'2026-06-10 09:00','Control anual',           'GENERAL',    'ATENDIDA'),
  (2,1,'2026-06-10 10:30','Vacuna triple felina',    'VACUNACION', 'ATENDIDA'),
  (3,2,'2026-06-12 14:00','Esterilizacion',          'CIRUGIA',    'ATENDIDA'),
  (4,3,'2026-06-15 11:00','Rascado y enrojecimiento','GENERAL',    'ATENDIDA'),
  (5,1,'2026-06-22 08:30','Control y bano',          'CONTROL',    'PROGRAMADA'),
  (6,2,'2026-06-24 16:00','Primera consulta',        'GENERAL',    'CONFIRMADA');

-- SERVICIOS POR CITA | id_servicio: 1=Consulta, 2=Vacunacion, 3=Esterilizacion, 4=Bano
INSERT INTO cita_servicio (id_cita, id_servicio, cantidad, precio_unitario) VALUES
  (1,1,1, 45000),
  (2,2,1, 35000),
  (2,1,1, 45000),
  (3,3,1,220000),
  (4,1,1, 45000);

-- CONSULTAS (una por cada cita ATENDIDA: citas 1..4)
INSERT INTO consulta (id_cita, motivo_consulta, sintomas, diagnostico, temperatura, peso_actual, observaciones) VALUES
  (1,'Control anual',  'Sin sintomas',            'Paciente sano',       38.5,28.5,'Continuar dieta y ejercicio'),
  (2,'Vacunacion',     'Sin sintomas',            'Apto para vacuna',    38.7, 4.2,'Proxima dosis en 12 meses'),
  (3,'Esterilizacion', 'Prequirurgico normal',    'Cirugia exitosa',     38.6, 3.1,'Reposo 10 dias, collar isabelino'),
  (4,'Rascado excesivo','Enrojecimiento y picazon','Dermatitis alergica',38.9, 3.8,'Evitar alergenos, control en 15 dias');

-- TRATAMIENTOS | id_consulta
INSERT INTO tratamiento (id_consulta, medicamento, dosis, frecuencia, duracion_dias) VALUES
  (3,'Amoxicilina',     '250 mg','Cada 12 horas',      7),
  (4,'Prednisolona',    '5 mg',  'Cada 24 horas',      5),
  (4,'Shampoo medicado','Aplicar en bano','2 veces por semana',14);

-- VACUNAS | id_mascota, id_veterinario
INSERT INTO vacuna (id_mascota, id_veterinario, nombre_vacuna, lote, fecha_aplicacion, fecha_proxima) VALUES
  (2,1,'Triple Felina',     'LOTE-TF-2026','2026-06-10','2027-06-10'),
  (1,1,'Antirrabica',       'LOTE-AR-2026','2026-06-10','2027-06-10'),
  (5,1,'Polivalente Canina','LOTE-PC-2025','2025-12-01','2026-12-01');

-- FACTURAS (una por cita ATENDIDA) | id_cliente = dueno de la mascota de esa cita
INSERT INTO factura (id_cita, id_cliente, subtotal, descuento, impuesto, total, estado_pago) VALUES
  (1,1, 45000,    0,0, 45000,'PAGADA'),
  (2,1, 80000,    0,0, 80000,'PAGADA'),
  (3,2,220000,20000,0,200000,'PENDIENTE'),
  (4,3, 45000,    0,0, 45000,'PAGADA');

-- Comprobacion: cuantas filas quedaron por tabla
SELECT 'cliente' AS tabla, count(*) AS filas FROM cliente
UNION ALL SELECT 'veterinario',  count(*) FROM veterinario
UNION ALL SELECT 'mascota',      count(*) FROM mascota
UNION ALL SELECT 'cita',         count(*) FROM cita
UNION ALL SELECT 'cita_servicio',count(*) FROM cita_servicio
UNION ALL SELECT 'consulta',     count(*) FROM consulta
UNION ALL SELECT 'tratamiento',  count(*) FROM tratamiento
UNION ALL SELECT 'vacuna',       count(*) FROM vacuna
UNION ALL SELECT 'factura',      count(*) FROM factura
ORDER BY tabla;
