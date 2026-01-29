# 🎓 Sistema de Gestión de Academia (RDBMS Design)

![SQL](https://img.shields.io/badge/SQL-PostgreSQL%20%2F%20MySQL-blue)
![Database Architecture](https://img.shields.io/badge/Architecture-Relational-green)

## 📋 Descripción del Proyecto
Este proyecto consiste en el diseño integral e implementación de una base de datos relacional orientada a la gestión operativa de un centro de formación. El objetivo principal es centralizar y estructurar la información de alumnos, docentes y oferta académica, garantizando la **integridad referencial** y la **consistencia del dato** en todo su ciclo de vida.

## 🏗️ Arquitectura de Datos
El sistema se ha diseñado siguiendo principios de normalización para asegurar una arquitectura escalable y eficiente, evitando redundancias.

### Entidades y Relaciones Clave:
* **Gestión de Usuarios**: Tablas normalizadas para el control de perfiles de Alumnos y Profesores.
* **Oferta Formativa**: Estructura jerárquica de Cursos y niveles académicos.
* **Operativa de Negocio**: Sistema de Matriculaciones que orquesta la relación entre el alumnado y la oferta docente, gestionando estados y fechas.

## 🚀 Funcionalidades Técnicas
* **Diseño de Esquema (DDL)**: Definición precisa de tipos de datos, claves primarias (PK) y claves foráneas (FK) para mantener la integridad de la base de datos.
* **Manipulación y Consulta (DML/DQL)**: Desarrollo de scripts SQL para la inserción masiva de datos y consultas complejas mediante el uso de `JOINs`, subconsultas y funciones de agregación.
* **Garantía de Calidad**: Implementación de restricciones (constraints) para asegurar que los datos operativos sean fiables y consistentes, alineado con estándares de calidad técnica.

## 🛠️ Stack Tecnológico
* **Lenguajes**: SQL (PostgreSQL / MySQL).
* **Entorno**: Herramientas de gestión de bases de datos relacionales y diseño de diagramas E-R.
* **Documentación**: Markdown para la especificación técnica de los procesos.

## 📈 Valor Estratégico
Este diseño no solo organiza la información, sino que permite:
1.  **Automatizar la ingesta de datos** de matriculaciones.
2.  **Facilitar la toma de decisiones** mediante reportes de ocupación y rendimiento académico.
3.  **Asegurar la trazabilidad** de la información, un requisito indispensable en entornos de gestión pública o grandes corporaciones.

## 👤 Autora
**Rocío Ortiz Gutiérrez** 
* **LinkedIn**: [https://www.linkedin.com/in/rocioortizg/](https://www.linkedin.com/in/rocioortizg/) 
* **GitHub**: [https://github.com/rocio2125](https://github.com/rocio2125)
