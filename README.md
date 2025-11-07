# Laboratorio 10: Analizador Léxico para Mini-0

## Descripción

Este proyecto implementa un analizador léxico para el lenguaje de programación **Mini-0**. El objetivo es identificar y clasificar los diferentes componentes del código fuente, generando una lista de tokens que representan las palabras reservadas, identificadores, operadores, números y signos de puntuación.

El analizador está diseñado para procesar un archivo de código fuente y generar un informe que muestra los tokens reconocidos, su tipo y su posición en el código.

## Estructura del Proyecto

El proyecto se compone de los siguientes archivos:

```
proyecto/
├── token.h                    # Definiciones de estructuras y constantes
├── token.c                    # Implementación de funciones de tokens
├── lexer.l                    # Reglas de Flex para el análisis léxico
├── DEFINICIONES_REGULARES.md  # Documento con expresiones regulares
├── README.md                  # Este archivo
└── tests/                     # Casos de prueba
    ├── test1.mini0           # Programa básico
    ├── test2.mini0           # Números decimales y hexadecimales
    ├── test3.mini0           # Strings con escapes
    ├── test4.mini0           # Comentarios
    └── test5.mini0           # Operadores y errores
```

## Requisitos

- **WSL Ubuntu** (Windows Subsystem for Linux)
- **Flex** (Fast Lexical Analyzer)
- **GCC** (GNU Compiler Collection)

### Instalación de dependencias

```bash
sudo apt update
sudo apt install -y flex gcc
```

## Compilación y Ejecución

Todo esto se realiza en **WSL Ubuntu** dentro de PowerShell.

### 1. Abrir WSL desde PowerShell

```powershell
wsl
```

### 2. Generar el analizador léxico

```bash
flex lexer.l
```

### 3. Compilar el proyecto

```bash
gcc -o analizador token.c lex.yy.c
```

### 4. Ejecutar con un archivo de prueba

```bash
./analizador tests/test1.mini0
```

## Definiciones Regulares

Expresiones regulares utilizadas para el reconocimiento de tokens:

```
DIGITO      = [0-9]
LETRA       = [a-zA-Z]
ID          = (LETRA|_)(LETRA|DIGITO|_)*
DECIMAL     = DIGITO+
HEX         = 0[xX][0-9A-Fa-f]+
STRING      = "([^"\\]|\\[tnr"\\])*"
ESPACIO     = [ \t\r]
```

### Tokens Reconocidos

| Categoría | Tokens |
|-----------|--------|
| **Palabras Reservadas** | `if`, `else`, `end`, `while`, `loop`, `fun`, `return`, `new`, `string`, `int`, `char`, `bool`, `true`, `false`, `and`, `or`, `not` |
| **Identificadores** | `[a-zA-Z_][a-zA-Z0-9_]*` |
| **Números** | Decimales: `[0-9]+` <br> Hexadecimales: `0[xX][0-9A-Fa-f]+` |
| **Strings** | `"([^"\\]|\\[tnr"\\])*"` |
| **Operadores Relacionales** | `>=`, `<=`, `<>`, `>`, `<`, `=` |
| **Operadores Aritméticos** | `+`, `-`, `*`, `/` |
| **Puntuación** | `(`, `)`, `[`, `]`, `,`, `:` |
| **Comentarios** | Línea: `//.*` <br> Multilínea: `/* ... */` |

## Características Implementadas

- Reconocimiento de todas las palabras reservadas de Mini-0
- Identificación de identificadores, números (decimal y hexadecimal)
- Procesamiento de strings con escapes (`\n`, `\t`, `\\`, `\"`)
- Conversión correcta de hexadecimales (15 = 0x0F)
- Manejo de comentarios de línea (`//`) y multilínea (`/* */`)
- Detección de errores léxicos
- Contador de líneas preciso
- Salida formateada con información detallada de cada token