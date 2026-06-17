-- =====================================================================
--  CLINICA VETERINARIA - Datos de ejemplo AMPLIADOS (PostgreSQL)
--  Mas de 10 filas por tabla. Re-ejecutable y autocontenido:
--  vacia las 12 tablas e inserta todo (incluye catalogos).
--  En DBeaver: conectate a clinica_veterinaria y usa
--              menu SQL Editor -> Execute SQL Script.
-- =====================================================================

TRUNCATE especie, raza, servicio, cliente, veterinario, mascota,
         cita, cita_servicio, consulta, tratamiento, vacuna, factura
  RESTART IDENTITY CASCADE;

-- ESPECIE (12)
INSERT INTO especie (nombre) VALUES
  ('Canino'),('Felino'),('Ave'),('Roedor'),('Conejo'),('Reptil'),
  ('Equino'),('Porcino'),('Bovino'),('Pez'),('Huron'),('Anfibio');

-- RAZA (15) | id_especie 1..12
INSERT INTO raza (id_especie, nombre, tamano) VALUES
  (1,'Labrador','GRANDE'),(1,'Chihuahua','PEQUENO'),(1,'Poodle','MEDIANO'),
  (1,'Bulldog','MEDIANO'),(1,'Pastor Aleman','GRANDE'),
  (2,'Siames','PEQUENO'),(2,'Persa','MEDIANO'),(2,'Angora','MEDIANO'),
  (3,'Canario','PEQUENO'),(3,'Loro','PEQUENO'),
  (4,'Hamster','PEQUENO'),(5,'Mini Lop','PEQUENO'),
  (6,'Iguana','MEDIANO'),(7,'Criollo','GRANDE'),(10,'Goldfish','PEQUENO');

-- SERVICIO (12)
INSERT INTO servicio (nombre, categoria, precio, duracion_min) VALUES
  ('Consulta general','CONSULTA',45000,30),
  ('Vacunacion','PREVENCION',35000,20),
  ('Esterilizacion','CIRUGIA',220000,90),
  ('Bano y peluqueria','ESTETICA',50000,60),
  ('Desparasitacion','PREVENCION',25000,15),
  ('Cirugia menor','CIRUGIA',180000,75),
  ('Radiografia','DIAGNOSTICO',90000,30),
  ('Ecografia','DIAGNOSTICO',110000,40),
  ('Examen de laboratorio','DIAGNOSTICO',70000,20),
  ('Limpieza dental','ODONTOLOGIA',130000,60),
  ('Hospitalizacion (dia)','INTERNACION',95000,1440),
  ('Implante de microchip','PREVENCION',40000,15);

-- CLIENTE (12)
INSERT INTO cliente (tipo_documento, num_documento, nombre, apellido, telefono, email, direccion) VALUES
  ('CC','1018203040','Ana Maria','Gomez',    '3001112233','ana.gomez@email.com',  'Calle 12 #4-56, Bogota'),
  ('CC','79854123',  'Carlos',   'Rodriguez','3104445566','carlos.r@email.com',   'Carrera 70 #45-10, Medellin'),
  ('CC','1032567890','Laura',    'Martinez', '3157778899','laura.m@email.com',    'Av 6N #23-15, Cali'),
  ('CE','456789',    'Jorge',    'Perez',    '3200001122','jorge.perez@email.com','Calle 100 #15-20, Bogota'),
  ('CC','1144556677','Sofia',    'Ramirez',  '3019998877','sofia.r@email.com',    'Cra 51B #80-22, Barranquilla'),
  ('CC','52998877',  'Andrea',   'Castro',   '3012223344','andrea.castro@email.com','Calle 45 #30-12, Bucaramanga'),
  ('CC','1098765432','Miguel',   'Sanchez',  '3145556677','miguel.s@email.com',   'Cra 8 #18-40, Pereira'),
  ('TI','1005544332','Valentina','Diaz',     '3168889900','valen.diaz@email.com', 'Calle 9 #5-21, Manizales'),
  ('CC','80223344',  'Ricardo',  'Moreno',   '3023334455','ricardo.m@email.com',  'Av 1 Mayo #34-67, Bogota'),
  ('CC','1026789012','Camila',   'Vargas',   '3176667788','camila.v@email.com',   'Cra 43A #5-90, Medellin'),
  ('CE','998877',    'David',    'Jimenez',  '3134445566','david.j@email.com',    'Calle 72 #11-30, Bogota'),
  ('CC','1077665544','Daniela',  'Torres',   '3009990011','daniela.t@email.com',  'Cra 15 #93-60, Bogota');

-- VETERINARIO (11)
INSERT INTO veterinario (nombre, apellido, num_documento, num_licencia, especialidad, telefono, email) VALUES
  ('Andres',    'Torres',   '80112233','MV-12345','Medicina general','3011234567','a.torres@vetwala.com'),
  ('Diana',     'Lopez',    '52334455','MV-67890','Cirugia',         '3022345678','d.lopez@vetwala.com'),
  ('Felipe',    'Castro',   '94556677','MV-11223','Dermatologia',    '3033456789','f.castro@vetwala.com'),
  ('Marcela',   'Ruiz',     '39887766','MV-22334','Medicina interna','3044567890','m.ruiz@vetwala.com'),
  ('Juan Pablo','Nieto',    '80556644','MV-33445','Cardiologia',     '3055678901','jp.nieto@vetwala.com'),
  ('Paola',     'Mendez',   '52776655','MV-44556','Oftalmologia',    '3066789012','p.mendez@vetwala.com'),
  ('Sergio',    'Herrera',  '94001122','MV-55667','Ortopedia',       '3077890123','s.herrera@vetwala.com'),
  ('Carolina',  'Rios',     '39112233','MV-66778','Etologia',        '3088901234','c.rios@vetwala.com'),
  ('Oscar',     'Pena',     '80998877','MV-77889','Anestesiologia',  '3099012345','o.pena@vetwala.com'),
  ('Lucia',     'Fernandez','52443322','MV-88990','Medicina general','3010123456','l.fernandez@vetwala.com'),
  ('Tomas',     'Acosta',   '94334455','MV-99001','Oncologia',       '3021234560','t.acosta@vetwala.com');

-- MASCOTA (15) | id_cliente 1..12, id_raza 1..15
INSERT INTO mascota (id_cliente, id_raza, nombre, sexo, fecha_nacimiento, peso_kg, color, microchip, esterilizado) VALUES
  ( 1, 1,'Firulais','M','2020-05-10',28.5,'Dorado',  '900000000000001',TRUE),
  ( 1, 6,'Michi',   'H','2021-03-15', 4.2,'Gris',    '900000000000002',FALSE),
  ( 2, 2,'Rocky',   'M','2019-11-20', 3.1,'Cafe',    '900000000000003',TRUE),
  ( 3, 7,'Luna',    'H','2022-01-05', 3.8,'Blanco',  '900000000000004',FALSE),
  ( 4, 5,'Max',     'M','2018-07-30',32.0,'Negro',   '900000000000005',TRUE),
  ( 5, 2,'Nina',    'H','2023-02-14', 2.5,'Crema',   '900000000000006',FALSE),
  ( 6, 3,'Coco',    'M','2021-09-01', 6.0,'Blanco',  '900000000000007',TRUE),
  ( 7, 4,'Thor',    'M','2020-12-12',22.0,'Atigrado','900000000000008',FALSE),
  ( 8, 8,'Pelusa',  'H','2022-06-20', 3.5,'Blanco',  '900000000000009',FALSE),
  ( 9, 9,'Piolin',  'M','2023-01-10',0.03,'Amarillo','900000000000010',FALSE),
  (10,11,'Bolita',  'H','2024-02-01',0.12,'Cafe',    '900000000000011',FALSE),
  (11,12,'Orejas',  'M','2023-08-15', 1.8,'Gris',    '900000000000012',FALSE),
  (12, 1,'Duque',   'M','2019-04-25',30.0,'Negro',   '900000000000013',TRUE),
  ( 2,10,'Paco',    'M','2018-03-03', 0.4,'Verde',   '900000000000014',FALSE),
  ( 3,13,'Spike',   'M','2021-07-07', 1.2,'Verde',   '900000000000015',FALSE);

-- CITA (15) | id_mascota 1..15, id_veterinario 1..11 (citas 1-13 ATENDIDA)
INSERT INTO cita (id_mascota, id_veterinario, fecha_hora, motivo, tipo_consulta, estado) VALUES
  ( 1, 1,'2026-05-04 09:00','Control anual',            'GENERAL',   'ATENDIDA'),
  ( 2, 3,'2026-05-04 10:30','Vacuna triple felina',     'VACUNACION','ATENDIDA'),
  ( 3, 2,'2026-05-05 14:00','Esterilizacion',           'CIRUGIA',   'ATENDIDA'),
  ( 4, 3,'2026-05-06 11:00','Rascado y enrojecimiento', 'GENERAL',   'ATENDIDA'),
  ( 5, 7,'2026-05-07 08:30','Cojera pata trasera',      'URGENCIA',  'ATENDIDA'),
  ( 6, 1,'2026-05-08 16:00','Vacuna anual',             'VACUNACION','ATENDIDA'),
  ( 7, 4,'2026-05-11 09:30','Control de peso',          'CONTROL',   'ATENDIDA'),
  ( 8, 2,'2026-05-12 13:00','Bulto en la piel',         'CIRUGIA',   'ATENDIDA'),
  ( 9, 6,'2026-05-13 10:00','Ojo irritado',             'GENERAL',   'ATENDIDA'),
  (10, 1,'2026-05-14 15:30','Chequeo general',          'GENERAL',   'ATENDIDA'),
  (11, 1,'2026-05-15 11:30','Apatia y poco apetito',    'GENERAL',   'ATENDIDA'),
  (12, 4,'2026-05-18 09:00','Vacunacion conejo',        'VACUNACION','ATENDIDA'),
  (13, 5,'2026-05-19 14:30','Control cardiaco',         'CONTROL',   'ATENDIDA'),
  (14, 1,'2026-06-25 10:00','Primera consulta',         'GENERAL',   'PROGRAMADA'),
  (15, 3,'2026-06-26 12:00','Revision de piel',         'GENERAL',   'CONFIRMADA');

-- CITA_SERVICIO (20) | id_servicio 1..12
INSERT INTO cita_servicio (id_cita, id_servicio, cantidad, precio_unitario) VALUES
  ( 1, 1,1, 45000),
  ( 2, 2,1, 35000),( 2, 1,1, 45000),
  ( 3, 3,1,220000),( 3, 9,1, 70000),
  ( 4, 1,1, 45000),( 4, 5,1, 25000),
  ( 5, 1,1, 45000),( 5, 7,1, 90000),
  ( 6, 2,1, 35000),
  ( 7, 1,1, 45000),
  ( 8, 6,1,180000),
  ( 9, 1,1, 45000),( 9, 8,1,110000),
  (10, 1,1, 45000),
  (11, 1,1, 45000),(11, 9,1, 70000),
  (12, 2,1, 35000),
  (13, 1,1, 45000),(13, 8,1,110000);

-- CONSULTA (13) | una por cita ATENDIDA (citas 1..13)
INSERT INTO consulta (id_cita, motivo_consulta, sintomas, diagnostico, temperatura, peso_actual, observaciones) VALUES
  ( 1,'Control anual',   'Sin sintomas',             'Paciente sano',        38.5,28.5,'Continuar dieta y ejercicio'),
  ( 2,'Vacunacion',      'Sin sintomas',             'Apto para vacuna',     38.7, 4.2,'Proxima dosis en 12 meses'),
  ( 3,'Esterilizacion',  'Prequirurgico normal',     'Cirugia exitosa',      38.6, 3.1,'Reposo 10 dias, collar isabelino'),
  ( 4,'Rascado excesivo','Enrojecimiento y picazon', 'Dermatitis alergica',  38.9, 3.8,'Evitar alergenos, control en 15 dias'),
  ( 5,'Cojera',          'Dolor en pata trasera',    'Esguince leve',        39.0,32.5,'Reposo y antiinflamatorio'),
  ( 6,'Vacuna anual',    'Sin sintomas',             'Sano',                 38.4, 2.6,'Refuerzo en un ano'),
  ( 7,'Sobrepeso',       'Aumento de peso',          'Obesidad grado 1',     38.3, 7.5,'Dieta hipocalorica 60 dias'),
  ( 8,'Bulto en piel',   'Inflamacion local',        'Absceso',              39.2,22.5,'Drenaje y antibiotico'),
  ( 9,'Ojo irritado',    'Secrecion ocular',         'Conjuntivitis',        38.6, 3.6,'Gotas oftalmicas 7 dias'),
  (10,'Chequeo general', 'Sin sintomas',             'Sano',                 38.5,0.03,'Control en 6 meses'),
  (11,'Apatia',          'Decaimiento, poco apetito','Deshidratacion leve',  38.0,0.12,'Fluidos y vitaminas'),
  (12,'Vacunacion',      'Sin sintomas',             'Apto',                 38.8, 1.8,'Refuerzo anual'),
  (13,'Control cardiaco','Tos ocasional',            'Soplo cardiaco leve',  38.4,30.0,'Ecocardiograma de control');

-- TRATAMIENTO (14) | id_consulta 1..13
INSERT INTO tratamiento (id_consulta, medicamento, dosis, frecuencia, duracion_dias) VALUES
  ( 1,'Antiparasitario',  '1 tableta','Dosis unica',     1),
  ( 3,'Amoxicilina',      '250 mg',   'Cada 12 horas',   7),
  ( 3,'Meloxicam',        '1.5 mg',   'Cada 24 horas',   5),
  ( 4,'Prednisolona',     '5 mg',     'Cada 24 horas',   5),
  ( 4,'Shampoo medicado', 'Aplicar',  '2 veces/semana', 21),
  ( 5,'Tramadol',         '50 mg',    'Cada 8 horas',    5),
  ( 7,'Dieta hipocalorica','Racion',  'Diaria',         60),
  ( 8,'Cefalexina',       '300 mg',   'Cada 12 horas',  10),
  ( 9,'Tobramicina gotas','1 gota',   'Cada 8 horas',    7),
  (11,'Complejo B',       '1 ml',     'Cada 24 horas',   3),
  (11,'Suero fisiologico','250 ml',   'Una vez',         1),
  (13,'Enalapril',        '5 mg',     'Cada 24 horas',  30),
  (13,'Furosemida',       '10 mg',    'Cada 12 horas',  30),
  ( 6,'Desparasitante',   '1 tableta','Dosis unica',     1);

-- VACUNA (14) | id_mascota 1..15, id_veterinario 1..11
INSERT INTO vacuna (id_mascota, id_veterinario, nombre_vacuna, lote, fecha_aplicacion, fecha_proxima) VALUES
  ( 1, 1,'Antirrabica',        'LOTE-AR-26','2026-05-04','2027-05-04'),
  ( 1, 1,'Polivalente Canina', 'LOTE-PC-26','2026-05-04','2027-05-04'),
  ( 2, 3,'Triple Felina',      'LOTE-TF-26','2026-05-04','2027-05-04'),
  ( 2, 3,'Leucemia Felina',    'LOTE-LF-26','2026-05-04','2027-05-04'),
  ( 3, 2,'Antirrabica',        'LOTE-AR-26','2026-05-05','2027-05-05'),
  ( 4, 3,'Triple Felina',      'LOTE-TF-26','2026-05-06','2027-05-06'),
  ( 5, 7,'Polivalente Canina', 'LOTE-PC-25','2025-12-01','2026-12-01'),
  ( 6, 1,'Antirrabica',        'LOTE-AR-26','2026-05-08','2027-05-08'),
  ( 7, 4,'Polivalente Canina', 'LOTE-PC-26','2026-05-11','2027-05-11'),
  ( 8, 2,'Antirrabica',        'LOTE-AR-26','2026-05-12','2027-05-12'),
  ( 9, 6,'Triple Felina',      'LOTE-TF-26','2026-05-13','2027-05-13'),
  (12, 4,'Mixomatosis',        'LOTE-MX-26','2026-05-18','2027-05-18'),
  (13, 5,'Polivalente Canina', 'LOTE-PC-26','2026-05-19','2027-05-19'),
  (13, 5,'Antirrabica',        'LOTE-AR-26','2026-05-19','2027-05-19');

-- FACTURA (13) | una por cita ATENDIDA, id_cliente = dueno de la mascota
INSERT INTO factura (id_cita, id_cliente, subtotal, descuento, impuesto, total, estado_pago) VALUES
  ( 1, 1, 45000,    0,0, 45000,'PAGADA'),
  ( 2, 1, 80000,    0,0, 80000,'PAGADA'),
  ( 3, 2,290000,29000,0,261000,'PENDIENTE'),
  ( 4, 3, 70000,    0,0, 70000,'PAGADA'),
  ( 5, 4,135000,    0,0,135000,'PAGADA'),
  ( 6, 5, 35000,    0,0, 35000,'PAGADA'),
  ( 7, 6, 45000,    0,0, 45000,'PENDIENTE'),
  ( 8, 7,180000,18000,0,162000,'PAGADA'),
  ( 9, 8,155000,    0,0,155000,'PAGADA'),
  (10, 9, 45000,    0,0, 45000,'PAGADA'),
  (11,10,115000,    0,0,115000,'PENDIENTE'),
  (12,11, 35000,    0,0, 35000,'PAGADA'),
  (13,12,155000,    0,0,155000,'ANULADA');

-- Comprobacion: filas por tabla
SELECT 'especie' AS tabla, count(*) AS filas FROM especie
UNION ALL SELECT 'raza',         count(*) FROM raza
UNION ALL SELECT 'servicio',     count(*) FROM servicio
UNION ALL SELECT 'cliente',      count(*) FROM cliente
UNION ALL SELECT 'veterinario',  count(*) FROM veterinario
UNION ALL SELECT 'mascota',      count(*) FROM mascota
UNION ALL SELECT 'cita',         count(*) FROM cita
UNION ALL SELECT 'cita_servicio',count(*) FROM cita_servicio
UNION ALL SELECT 'consulta',     count(*) FROM consulta
UNION ALL SELECT 'tratamiento',  count(*) FROM tratamiento
UNION ALL SELECT 'vacuna',       count(*) FROM vacuna
UNION ALL SELECT 'factura',      count(*) FROM factura
ORDER BY tabla;
