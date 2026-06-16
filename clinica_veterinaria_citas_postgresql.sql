-- =====================================================================
--  Base de datos: CLINICA VETERINARIA - Gestion de Citas
--  Motor: PostgreSQL 12+
--  Convertido desde la version MySQL/MariaDB (clinica_veterinaria_citas.sql)
--  Generado a partir del diagrama ER: clinica_veterinaria_citas.drawio
-- =====================================================================

-- ---------------------------------------------------------------------
-- PASO 1. Crear la base de datos (ejecutar conectado a la BD 'postgres').
--         PostgreSQL ya usa UTF-8 por defecto y NO admite "IF NOT EXISTS"
--         en CREATE DATABASE; debe correrse una sola vez.
-- ---------------------------------------------------------------------
CREATE DATABASE clinica_veterinaria WITH ENCODING 'UTF8';

-- ---------------------------------------------------------------------
-- PASO 2. Conectarse a la base recien creada.
--   * En psql:            \c clinica_veterinaria
--   * En pgAdmin / DBeaver: abre una conexion a "clinica_veterinaria" y
--                           ejecuta de aqui en adelante (ignora la linea \c).
-- ---------------------------------------------------------------------
\c clinica_veterinaria

-- ---------------------------------------------------------------------
-- PASO 3. Tipos ENUM
--   PostgreSQL no tiene ENUM en linea como MySQL: se definen como TIPOS
--   reutilizables. (Alternativa: VARCHAR + CHECK; ver notas al final.)
-- ---------------------------------------------------------------------
CREATE TYPE enum_tamano          AS ENUM ('PEQUENO','MEDIANO','GRANDE');
CREATE TYPE enum_tipo_documento  AS ENUM ('CC','CE','TI','PAS','NIT');
CREATE TYPE enum_sexo            AS ENUM ('M','H');
CREATE TYPE enum_tipo_consulta   AS ENUM ('GENERAL','VACUNACION','CIRUGIA','CONTROL','URGENCIA','ESTETICA');
CREATE TYPE enum_estado_cita     AS ENUM ('PROGRAMADA','CONFIRMADA','EN_CURSO','ATENDIDA','CANCELADA','NO_ASISTIO');
CREATE TYPE enum_estado_pago     AS ENUM ('PENDIENTE','PAGADA','ANULADA');

-- ---------------------------------------------------------------------
-- Catalogos
-- ---------------------------------------------------------------------
CREATE TABLE especie (
  id_especie   SERIAL PRIMARY KEY,
  nombre       VARCHAR(50)  NOT NULL UNIQUE,
  descripcion  VARCHAR(255)
);

CREATE TABLE raza (
  id_raza      SERIAL PRIMARY KEY,
  id_especie   INT NOT NULL,
  nombre       VARCHAR(80) NOT NULL,
  tamano       enum_tamano DEFAULT 'MEDIANO',
  CONSTRAINT fk_raza_especie FOREIGN KEY (id_especie) REFERENCES especie(id_especie)
);

-- ---------------------------------------------------------------------
-- Entidades base
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
  id_cliente     SERIAL PRIMARY KEY,
  tipo_documento enum_tipo_documento NOT NULL DEFAULT 'CC',
  num_documento  VARCHAR(20)  NOT NULL UNIQUE,
  nombre         VARCHAR(80)  NOT NULL,
  apellido       VARCHAR(80)  NOT NULL,
  telefono       VARCHAR(20),
  email          VARCHAR(120),
  direccion      VARCHAR(180),
  fecha_registro TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE veterinario (
  id_veterinario SERIAL PRIMARY KEY,
  nombre         VARCHAR(80)  NOT NULL,
  apellido       VARCHAR(80)  NOT NULL,
  num_documento  VARCHAR(20)  NOT NULL UNIQUE,
  num_licencia   VARCHAR(30)  NOT NULL UNIQUE,
  especialidad   VARCHAR(80),
  telefono       VARCHAR(20),
  email          VARCHAR(120)
);

CREATE TABLE mascota (
  id_mascota       SERIAL PRIMARY KEY,
  id_cliente       INT NOT NULL,
  id_raza          INT,
  nombre           VARCHAR(60) NOT NULL,
  sexo             enum_sexo NOT NULL,
  fecha_nacimiento DATE,
  peso_kg          DECIMAL(5,2),
  color            VARCHAR(40),
  microchip        VARCHAR(40) UNIQUE,
  esterilizado     BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_mascota_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  CONSTRAINT fk_mascota_raza    FOREIGN KEY (id_raza)    REFERENCES raza(id_raza)
);

CREATE TABLE servicio (
  id_servicio   SERIAL PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  descripcion   VARCHAR(255),
  categoria     VARCHAR(60),
  precio        DECIMAL(10,2) NOT NULL DEFAULT 0,
  duracion_min  INT NOT NULL DEFAULT 30
);

-- ---------------------------------------------------------------------
-- Nucleo: CITA
-- ---------------------------------------------------------------------
CREATE TABLE cita (
  id_cita        SERIAL PRIMARY KEY,
  id_mascota     INT NOT NULL,
  id_veterinario INT NOT NULL,
  fecha_hora     TIMESTAMP NOT NULL,
  motivo         VARCHAR(180),
  tipo_consulta  enum_tipo_consulta NOT NULL DEFAULT 'GENERAL',
  estado         enum_estado_cita   NOT NULL DEFAULT 'PROGRAMADA',
  observaciones  VARCHAR(255),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cita_mascota     FOREIGN KEY (id_mascota)     REFERENCES mascota(id_mascota),
  CONSTRAINT fk_cita_veterinario FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario)
);
CREATE INDEX idx_cita_fecha  ON cita(fecha_hora);
CREATE INDEX idx_cita_estado ON cita(estado);

-- Detalle de servicios facturados/realizados en la cita (relacion N:M)
CREATE TABLE cita_servicio (
  id_cita_servicio SERIAL PRIMARY KEY,
  id_cita          INT NOT NULL,
  id_servicio      INT NOT NULL,
  cantidad         INT NOT NULL DEFAULT 1,
  precio_unitario  DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_cs_cita      FOREIGN KEY (id_cita)     REFERENCES cita(id_cita),
  CONSTRAINT fk_cs_servicio  FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio),
  CONSTRAINT uq_cita_servicio UNIQUE (id_cita, id_servicio)
);

-- ---------------------------------------------------------------------
-- Registro clinico
-- ---------------------------------------------------------------------
CREATE TABLE consulta (
  id_consulta     SERIAL PRIMARY KEY,
  id_cita         INT NOT NULL UNIQUE,           -- 1:1 con la cita
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

-- ---------------------------------------------------------------------
-- Facturacion
-- ---------------------------------------------------------------------
CREATE TABLE factura (
  id_factura    SERIAL PRIMARY KEY,
  id_cita       INT NOT NULL UNIQUE,             -- 1:1 con la cita
  id_cliente    INT NOT NULL,
  fecha_emision TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  subtotal      DECIMAL(12,2) NOT NULL DEFAULT 0,
  descuento     DECIMAL(12,2) NOT NULL DEFAULT 0,
  impuesto      DECIMAL(12,2) NOT NULL DEFAULT 0,
  total         DECIMAL(12,2) NOT NULL DEFAULT 0,
  estado_pago   enum_estado_pago NOT NULL DEFAULT 'PENDIENTE',
  CONSTRAINT fk_factura_cita    FOREIGN KEY (id_cita)    REFERENCES cita(id_cita),
  CONSTRAINT fk_factura_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- =====================================================================
--  Datos de ejemplo (opcional)
-- =====================================================================
INSERT INTO especie (nombre) VALUES ('Canino'), ('Felino'), ('Ave'), ('Roedor');
INSERT INTO raza (id_especie, nombre, tamano) VALUES
  (1,'Labrador','GRANDE'), (1,'Chihuahua','PEQUENO'), (2,'Siames','MEDIANO');
INSERT INTO servicio (nombre, categoria, precio, duracion_min) VALUES
  ('Consulta general','CONSULTA', 45000, 30),
  ('Vacunacion','PREVENCION', 35000, 20),
  ('Esterilizacion','CIRUGIA', 220000, 90),
  ('Bano y peluqueria','ESTETICA', 50000, 60);

-- =====================================================================
--  NOTAS de conversion  MySQL/MariaDB -> PostgreSQL
-- =====================================================================
-- 1. INT AUTO_INCREMENT  ->  SERIAL (crea una secuencia automatica).
--    Alternativa moderna:  id INT GENERATED ALWAYS AS IDENTITY.
-- 2. ENUM(...) en linea   ->  CREATE TYPE ... AS ENUM (tipos reutilizables).
--    Alternativa simple:   columna VARCHAR + CHECK (col IN ('A','B',...)).
-- 3. DATETIME             ->  TIMESTAMP  (o TIMESTAMPTZ si necesitas zona horaria).
-- 4. No existe "USE bd;"  ->  \c en psql, o conecta el cliente a la base.
-- 5. CREATE DATABASE no admite IF NOT EXISTS ni CHARACTER SET/COLLATE estilo
--    MySQL; PostgreSQL ya es UTF-8 por defecto.
-- 6. BOOLEAN / DECIMAL / VARCHAR / DATE / PRIMARY KEY / FOREIGN KEY / UNIQUE /
--    CREATE INDEX  ->  iguales en ambos motores.
-- 7. Para re-ejecutar desde cero:  DROP DATABASE clinica_veterinaria;
--    (o DROP TABLE ... CASCADE y DROP TYPE enum_*  antes de recrear).
