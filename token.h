/*
 * token.h
 * Definición de la estructura de datos para representar tokens
 * del lenguaje Mini-0
 */

#ifndef TOKEN_H
#define TOKEN_H

// Enumeración con todos los tipos de tokens del lenguaje Mini-0
typedef enum {
    // Palabras reservadas
    TOKEN_IF,           // if
    TOKEN_ELSE,         // else
    TOKEN_END,          // end
    TOKEN_WHILE,        // while
    TOKEN_LOOP,         // loop
    TOKEN_FUN,          // fun
    TOKEN_RETURN,       // return
    TOKEN_NEW,          // new
    TOKEN_STRING,       // string
    TOKEN_INT,          // int
    TOKEN_CHAR,         // char
    TOKEN_BOOL,         // bool
    TOKEN_TRUE,         // true
    TOKEN_FALSE,        // false
    TOKEN_AND,          // and
    TOKEN_OR,           // or
    TOKEN_NOT,          // not
    
    // Identificadores y literales
    TOKEN_ID,           // Identificadores (nombres de variables, funciones)
    TOKEN_NUMERAL,      // Números (decimales y hexadecimales)
    TOKEN_LITSTRING,    // Cadenas literales entre comillas
    
    // Operadores relacionales
    TOKEN_GT,           // >
    TOKEN_LT,           // <
    TOKEN_GTE,          // >=
    TOKEN_LTE,          // <=
    TOKEN_EQ,           // =
    TOKEN_NEQ,          // <>
    
    // Operadores aritméticos
    TOKEN_PLUS,         // +
    TOKEN_MINUS,        // -
    TOKEN_MULT,         // *
    TOKEN_DIV,          // /
    
    // Signos de puntuación
    TOKEN_LPAREN,       // (
    TOKEN_RPAREN,       // )
    TOKEN_LBRACKET,     // [
    TOKEN_RBRACKET,     // ]
    TOKEN_COMMA,        // ,
    TOKEN_COLON,        // :
    
    // Otros
    TOKEN_NL,           // Salto de línea (relevante para la gramática)
    TOKEN_ERROR,        // Token de error para valores no reconocidos
    TOKEN_EOF           // Fin de archivo
} TipoToken;

// Estructura que representa un token completo
typedef struct {
    TipoToken tipo;         // Tipo de token (del enum anterior)
    char* lexema;           // El texto original del token
    int valor_entero;       // Para tokens numéricos (almacena el valor)
    char* valor_string;     // Para strings e identificadores (sin comillas, con escapes procesados)
    int linea;              // Número de línea donde aparece el token (primera línea = 1)
} Token;

// Función para crear un nuevo token
// Parámetros:
//   - tipo: el tipo de token
//   - lexema: el texto original del código fuente
//   - linea: número de línea donde aparece
// Retorna: puntero a un nuevo Token creado dinámicamente
Token* crear_token(TipoToken tipo, const char* lexema, int linea);

// Función para liberar la memoria de un token
void destruir_token(Token* token);

// Función para obtener el nombre legible de un tipo de token
// Útil para imprimir los resultados
const char* nombre_token(TipoToken tipo);

#endif // TOKEN_H