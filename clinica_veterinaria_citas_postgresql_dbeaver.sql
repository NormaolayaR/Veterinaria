-- =====================================================================
--  CLINICA VETERINARIA - Gestion de Citas   |   PostgreSQL (version DBeaver)
-- ---------------------------------------------------------------------
--  Esta version NO usa CREATE TYPE: los antiguos ENUM se reemplazaron por
--  VARCHAR + CHECK, asi NINGUNA tabla depende de un tipo creado aparte.
--  -> Puedes ejecutar todo de una (Alt+X) o tabla por tabla; ya no falla
--     por el orden de los tipos.
--
--  USO EN DBEAVER: crea la base clinica_veterinaria, abre un SQL Editor
--  sobre ella, y ejecuta. Re-ejecutable (borra lo previo antes de crear).
--  No lleva CREATE DATABASE ni \c (ya estas dentro de la base).
-- =====================================================================

-- 1) LIMPIEZA (por si quedaron objetos de un intento anterior)
DROP TABLE IF EXISTS factura       CASCADE;
DROP TABLE IF EXISTS cita_servicio CASCADE;
DROP TABLE IF EXISTS tratamiento   CASCADE;
DROP TABLE IF EXISTS consulta      CASCADE;
DROP TABLE IF EXISTS vacuna        CASCADE;
DROP TABLE IF EXISTS cita          CASCADE;
DROP TABLE IF EXISTS servicio      CASCADE;
DROP TABLE IF EXISTS mascota       CASCADE;
DROP TABLE IF EXISTS veterinario   CASCADE;
DROP TABLE IF EXISTS cliente       CASCADE;
DROP TABLE IF EXISTS raza          CASCADE;
DROP TABLE IF EXISTS especie       CASCADE;

-- 2) TABLAS  (los ENUM ahora son VARCHAR + CHECK)
CREATE TABLE especie (
  id_especie  SERIAL PRIMARY KEY,
  nombre      VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(255)
);

CREATE TABLE raza (
  id_raza    SERIAL PRIMARY KEY,
  id_especie INT NOT NULL,
  nombre     VARCHAR(80) NOT NULL,
  tamano     VARCHAR(10) DEFAULT 'MEDIANO' CHECK (tamano IN ('PEQUENO','MEDIANO','GRANDE')),
  CONSTRAINT fk_raza_especie FOREIGN KEY (id_especie) REFERENCES especie(id_especie)
);

CREATE TABLE cliente (
  id_cliente     SERIAL PRIMARY KEY,
  tipo_documento VARCHAR(5) NOT NULL DEFAULT 'CC' CHECK (tipo_documento IN ('CC','CE','TI','PAS','NIT')),
  num_documento  VARCHAR(20) NOT NULL UNIQUE,
  nombre         VARCHAR(80) NOT NULL,
  apellido       VARCHAR(80) NOT NULL,
  telefono       VARCHAR(20),
  email          VARCHAR(120),
  direccion      VARCHAR(180),
  fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE veterinario (
  id_veterinario SERIAL PRIMARY KEY,
  nombre         VARCHAR(80) NOT NULL,
  apellido       VARCHAR(80) NOT NULL,
  num_documento  VARCHAR(20) NOT NULL UNIQUE,
  num_licencia   VARCHAR(30) NOT NULL UNIQUE,
  especialidad   VARCHAR(80),
  telefono       VARCHAR(20),
  email          VARCHAR(120)
);

CREATE TABLE mascota (
  id_mascota       SERIAL PRIMARY KEY,
  id_cliente       INT NOT NULL,
  id_raza          INT,
  nombre           VARCHAR(60) NOT NULL,
  sexo             VARCHAR(1) NOT NULL CHECK (sexo IN ('M','H')),
  fecha_nacimiento DATE,
  peso_kg          DECIMAL(5,2),
  color            VARCHAR(40),
  microchip        VARCHAR(40) UNIQUE,
  esterilizado     BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_mascota_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  CONSTRAINT fk_mascota_raza    FOREIGN KEY (id_raza)    REFERENCES raza(id_raza)
);

CREATE TABLE servicio (
  id_servicio  SERIAL PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  descripcion  VARCHAR(255),
  categoria    VARCHAR(60),
  precio       DECIMAL(10,2) NOT NULL DEFAULT 0,
  duracion_min INT NOT NULL DEFAULT 30
);

CREATE TABLE cita (
  id_cita        SERIAL PRIMARY KEY,
  id_mascota     INT NOT NULL,
  id_veterinario INT NOT NULL,
  fecha_hora     TIMESTAMP NOT NULL,
  motivo         VARCHAR(180),
  tipo_consulta  VARCHAR(20) NOT NULL DEFAULT 'GENERAL'
                   CHECK (tipo_consulta IN ('GENERAL','VACUNACION','CIRUGIA','CONTROL','URGENCIA','ESTETICA')),
  estado         VARCHAR(15) NOT NULL DEFAULT 'PROGRAMADA'
                   CHECK (estado IN ('PROGRAMADA','CONFIRMADA','EN_CURSO','ATENDIDA','CANCELADA','NO_ASISTIO')),
  observaciones  VARCHAR(255),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cita_mascota     FOREIGN KEY (id_mascota)     REFERENCES mascota(id_mascota),
  CONSTRAINT fk_cita_veterinario FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario)
);
CREATE INDEX idx_cita_fecha  ON cita(fecha_hora);
CREATE INDEX idx_cita_estado ON cita(estado);

CREATE TABLE cita_servicio (
  id_cita_servicio SERIAL PRIMARY KEY,
  id_cita          INT NOT NULL,
  id_servicio      INT NOT NULL,
  cantidad         INT NOT NULL DEFAULT 1,
  precio_unitario  DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_cs_cita     FOREIGN KEY (id_cita)     REFERENCES cita(id_cita),
  CONSTRAINT fk_cs_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio),
  CONSTRAINT uq_cita_servicio UNIQUE (id_cita, id_servicio)
);

CREATE TABLE consulta (
  id_consulta     SERIAL PRIMARY KEY,
  id_cita         INT NOT NULL UNIQUE,
  motivo_consulta VARCHAR(180),
  sintomas        TEXT,
  diagnostico     TEXT,
  temperatura     DECIMAL(4,1),
  peso_actual     DECIMAL(5,2),
  observaciones   TEXT,
  CONSTRAINT fk_consulta_cita FOREIGN KEY (id_cita) REFERENCES cita(id_cita)
);

CREATE TABLE tratamiento (
  id_tratamiento SERIAL PRIMARY KEY,
  id_consulta    INT NOT NULL,
  medicamento    VARCHAR(120) NOT NULL,
  dosis          VARCHAR(60),
  frecuencia     VARCHAR(60),
  duracion_dias  INT,
  CONSTRAINT fk_tratamiento_consulta FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta)
);

CREATE TABLE vacuna (
  id_vacuna        SERIAL PRIMARY KEY,
  id_mascota       INT NOT NULL,
  id_veterinario   INT,
  nombre_vacuna    VARCHAR(100) NOT NULL,
  lote             VARCHAR(40),
  fecha_aplicacion DATE NOT NULL,
  fecha_proxima    DATE,
  CONSTRAINT fk_vacuna_mascota     FOREIGN KEY (id_mascota)     REFERENCES mascota(id_mascota),
  CONSTRAINT fk_vacuna_veterinario FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario)
);

CREATE TABLE factura (
  id_factura    SERIAL PRIMARY KEY,
  id_cita       INT NOT NULL UNIQUE,
  id_cliente    INT NOT NULL,
  fecha_emision TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  subtotal      DECIMAL(12,2) NOT NULL DEFAULT 0,
  descuento     DECIMAL(12,2) NOT NULL DEFAULT 0,
  impuesto      DECIMAL(12,2) NOT NULL DEFAULT 0,
  total         DECIMAL(12,2) NOT NULL DEFAULT 0,
  estado_pago   VARCHAR(10) NOT NULL DEFAULT 'PENDIENTE'
                   CHECK (estado_pago IN ('PENDIENTE','PAGADA','ANULADA')),
  CONSTRAINT fk_factura_cita    FOREIGN KEY (id_cita)    REFERENCES cita(id_cita),
  CONSTRAINT fk_factura_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- 3) DATOS DE EJEMPLO
INSERT INTO especie (nombre) VALUES ('Canino'),('Felino'),('Ave'),('Roedor');
INSERT INTO raza (id_especie, nombre, tamano) VALUES
  (1,'Labrador','GRANDE'),(1,'Chihuahua','PEQUENO'),(2,'Siames','MEDIANO');
INSERT INTO servicio (nombre, categoria, precio, duracion_min) VALUES
  ('Consulta general','CONSULTA',45000,30),
  ('Vacunacion','PREVENCION',35000,20),
  ('Esterilizacion','CIRUGIA',220000,90),
  ('Bano y peluqueria','ESTETICA',50000,60);

-- 4) COMPROBACION
SELECT 'OK: ' || count(*) || ' tablas creadas' AS resultado
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
SELECT * FROM servicio;
