# Laboratorio 10: Analizador Léxico para Mini-0

## Descripción

Este proyecto implementa un analizador léxico para el lenguaje de programación **Mini-0**. El objetivo es identificar y clasificar los diferentes componentes del código fuente, generando una lista de tokens que representan las palabras reservadas, identificadores, operadores, números y signos de puntuación.

El analizador está diseñado para procesar un archivo de código fuente y generar un informe que muestra los tokens reconocidos, su tipo y su posición en el código.

## Estructura del Proyecto

El proyecto se compone de los siguientes archivos:

- `lexer.l`: Código fuente del analizador léxico, donde se definen las reglas para el reconocimiento de tokens.
- `token.h`: Definiciones de estructuras y constantes utilizadas por el analizador.
- `token.c`: Implementación de funciones relacionadas con la gestión de tokens.
- `tests`: Carpeta que cotiene ejemplos bien macizos para poner a prueba en clase.

## Codificación
Todo esto se realiza en WSL ubuntu dentro de Powershell.

```bash
flex lexer.l


gcc -o analizador token.c lex.yy.c


./analizador tests/test1.mini0