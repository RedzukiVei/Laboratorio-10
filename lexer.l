/*
 * lexer.l
 * Analizador léxico para el lenguaje Mini-0 usando Flex
 * Este archivo define las reglas para reconocer todos los tokens del lenguaje
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "token.h"

// Variable global para llevar el conteo de líneas
// La primera línea del programa es la línea 1
int linea_actual = 1;

// Lista para almacenar todos los tokens reconocidos
typedef struct NodoToken {
    Token* token;
    struct NodoToken* siguiente;
} NodoToken;

NodoToken* lista_tokens = NULL;
NodoToken* ultimo_token = NULL;

// Declaración de funciones auxiliares
void agregar_token(Token* token);
char* procesar_string(const char* str);
int hex_a_decimal(const char* hex);
void imprimir_tokens();
void liberar_tokens();
%}

/* Opciones de Flex */
%option noyywrap

/* Definiciones de patrones regulares */
DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          ({LETRA}|_)({LETRA}|{DIGITO}|_)*
DECIMAL     {DIGITO}+
HEX         0[xX][0-9A-Fa-f]+
ESPACIO     [ \t\r]

/* Estados exclusivos para comentarios multilínea */
%x COMENTARIO

%%

    /* ===== COMENTARIOS ===== */
    /* Comentario de una línea: desde // hasta el fin de línea */
"//".*          { /* Se ignora completamente */ }

    /* Comentario multilínea */
"/*"            { BEGIN(COMENTARIO); }
<COMENTARIO>"*/" { BEGIN(INITIAL); }
<COMENTARIO>\n  { linea_actual++; }
<COMENTARIO>.   { /* Ignorar cualquier otro carácter dentro del comentario */ }

    /* ===== PALABRAS RESERVADAS ===== */
    /* Deben ir antes de la regla de identificadores para tener prioridad */
"if"        { Token* t = crear_token(TOKEN_IF, yytext, linea_actual); agregar_token(t); }
"else"      { Token* t = crear_token(TOKEN_ELSE, yytext, linea_actual); agregar_token(t); }
"end"       { Token* t = crear_token(TOKEN_END, yytext, linea_actual); agregar_token(t); }
"while"     { Token* t = crear_token(TOKEN_WHILE, yytext, linea_actual); agregar_token(t); }
"loop"      { Token* t = crear_token(TOKEN_LOOP, yytext, linea_actual); agregar_token(t); }
"fun"       { Token* t = crear_token(TOKEN_FUN, yytext, linea_actual); agregar_token(t); }
"return"    { Token* t = crear_token(TOKEN_RETURN, yytext, linea_actual); agregar_token(t); }
"new"       { Token* t = crear_token(TOKEN_NEW, yytext, linea_actual); agregar_token(t); }
"string"    { Token* t = crear_token(TOKEN_STRING, yytext, linea_actual); agregar_token(t); }
"int"       { Token* t = crear_token(TOKEN_INT, yytext, linea_actual); agregar_token(t); }
"char"      { Token* t = crear_token(TOKEN_CHAR, yytext, linea_actual); agregar_token(t); }
"bool"      { Token* t = crear_token(TOKEN_BOOL, yytext, linea_actual); agregar_token(t); }
"true"      { Token* t = crear_token(TOKEN_TRUE, yytext, linea_actual); agregar_token(t); }
"false"     { Token* t = crear_token(TOKEN_FALSE, yytext, linea_actual); agregar_token(t); }
"and"       { Token* t = crear_token(TOKEN_AND, yytext, linea_actual); agregar_token(t); }
"or"        { Token* t = crear_token(TOKEN_OR, yytext, linea_actual); agregar_token(t); }
"not"       { Token* t = crear_token(TOKEN_NOT, yytext, linea_actual); agregar_token(t); }

    /* ===== IDENTIFICADORES ===== */
    /* Letra o underscore, seguido de letras, dígitos o underscores */
{ID}        { 
                Token* t = crear_token(TOKEN_ID, yytext, linea_actual);
                // Guardar el identificador en valor_string
                t->valor_string = (char*)malloc(strlen(yytext) + 1);
                strcpy(t->valor_string, yytext);
                agregar_token(t);
            }

    /* ===== NÚMEROS ===== */
    /* Números decimales */
{DECIMAL}   { 
                Token* t = crear_token(TOKEN_NUMERAL, yytext, linea_actual);
                // Convertir a entero y guardar el valor
                t->valor_entero = atoi(yytext);
                agregar_token(t);
            }

    /* Números hexadecimales (0x o 0X seguido de dígitos hex) */
{HEX}       { 
                Token* t = crear_token(TOKEN_NUMERAL, yytext, linea_actual);
                // Convertir hexadecimal a decimal
                // Nota: 0x0F y 15 deben tener el mismo valor_entero
                t->valor_entero = hex_a_decimal(yytext);
                agregar_token(t);
            }

    /* ===== STRINGS ===== */
    /* Cadenas entre comillas dobles, pueden contener escapes: \\, \n, \t, \" */
\"([^\"\\]|\\[tnr\"\\])*\"  { 
                Token* t = crear_token(TOKEN_LITSTRING, yytext, linea_actual);
                // Procesar los escapes y quitar las comillas
                t->valor_string = procesar_string(yytext);
                agregar_token(t);
            }

    /* ===== OPERADORES RELACIONALES ===== */
    /* Los operadores de dos caracteres deben ir primero */
">="        { Token* t = crear_token(TOKEN_GTE, yytext, linea_actual); agregar_token(t); }
"<="        { Token* t = crear_token(TOKEN_LTE, yytext, linea_actual); agregar_token(t); }
"<>"        { Token* t = crear_token(TOKEN_NEQ, yytext, linea_actual); agregar_token(t); }
">"         { Token* t = crear_token(TOKEN_GT, yytext, linea_actual); agregar_token(t); }
"<"         { Token* t = crear_token(TOKEN_LT, yytext, linea_actual); agregar_token(t); }
"="         { Token* t = crear_token(TOKEN_EQ, yytext, linea_actual); agregar_token(t); }

    /* ===== OPERADORES ARITMÉTICOS ===== */
"+"         { Token* t = crear_token(TOKEN_PLUS, yytext, linea_actual); agregar_token(t); }
"-"         { Token* t = crear_token(TOKEN_MINUS, yytext, linea_actual); agregar_token(t); }
"*"         { Token* t = crear_token(TOKEN_MULT, yytext, linea_actual); agregar_token(t); }
"/"         { Token* t = crear_token(TOKEN_DIV, yytext, linea_actual); agregar_token(t); }

    /* ===== SIGNOS DE PUNTUACIÓN ===== */
"("         { Token* t = crear_token(TOKEN_LPAREN, yytext, linea_actual); agregar_token(t); }
")"         { Token* t = crear_token(TOKEN_RPAREN, yytext, linea_actual); agregar_token(t); }
"["         { Token* t = crear_token(TOKEN_LBRACKET, yytext, linea_actual); agregar_token(t); }
"]"         { Token* t = crear_token(TOKEN_RBRACKET, yytext, linea_actual); agregar_token(t); }
","         { Token* t = crear_token(TOKEN_COMMA, yytext, linea_actual); agregar_token(t); }
":"         { Token* t = crear_token(TOKEN_COLON, yytext, linea_actual); agregar_token(t); }

    /* ===== SALTOS DE LÍNEA ===== */
    /* Importante: los saltos de línea son relevantes para la gramática de Mini-0 */
\n          { 
                Token* t = crear_token(TOKEN_NL, "\\n", linea_actual);
                agregar_token(t);
                linea_actual++;  // Incrementar contador de líneas
            }

    /* ===== ESPACIOS EN BLANCO ===== */
    /* Espacios, tabulaciones y retornos de carro se ignoran */
{ESPACIO}+  { /* Ignorar */ }

    /* ===== CARACTERES NO RECONOCIDOS (ERRORES) ===== */
    /* Cualquier otro carácter es un error */
.           { 
                Token* t = crear_token(TOKEN_ERROR, yytext, linea_actual);
                agregar_token(t);
                fprintf(stderr, "Error léxico en línea %d: carácter no reconocido '%s'\n", 
                        linea_actual, yytext);
            }

%%

/* ===== FUNCIONES AUXILIARES ===== */

// Agrega un token a la lista enlazada de tokens
void agregar_token(Token* token) {
    NodoToken* nodo = (NodoToken*)malloc(sizeof(NodoToken));
    nodo->token = token;
    nodo->siguiente = NULL;
    
    if (lista_tokens == NULL) {
        lista_tokens = nodo;
        ultimo_token = nodo;
    } else {
        ultimo_token->siguiente = nodo;
        ultimo_token = nodo;
    }
}

// Convierte un número hexadecimal (como string) a decimal
// Ejemplo: "0x0F" -> 15
int hex_a_decimal(const char* hex) {
    return (int)strtol(hex, NULL, 16);
}

// Procesa los escapes en un string y quita las comillas
// Convierte: \"Hola\\n\" -> Hola\n (con salto de línea real)
char* procesar_string(const char* str) {
    int len = strlen(str);
    // Reservar memoria (en el peor caso, mismo tamaño)
    char* resultado = (char*)malloc(len);
    int j = 0;
    
    // Iterar desde después de la primera comilla hasta antes de la última
    for (int i = 1; i < len - 1; i++) {
        if (str[i] == '\\' && i + 1 < len - 1) {
            // Procesar secuencia de escape
            switch(str[i + 1]) {
                case 'n':  resultado[j++] = '\n'; i++; break;  // Salto de línea
                case 't':  resultado[j++] = '\t'; i++; break;  // Tabulación
                case '\\': resultado[j++] = '\\'; i++; break;  // Backslash
                case '"':  resultado[j++] = '"';  i++; break;  // Comilla doble
                default:   resultado[j++] = str[i];            // Si no es escape válido, copiar
            }
        } else {
            // Carácter normal, copiar
            resultado[j++] = str[i];
        }
    }
    
    resultado[j] = '\0';  // Terminar string
    return resultado;
}

// Cuenta el número total de tokens
int contar_tokens() {
    int count = 0;
    NodoToken* actual = lista_tokens;
    while (actual != NULL) {
        count++;
        actual = actual->siguiente;
    }
    return count;
}

// Imprime todos los tokens reconocidos
void imprimir_tokens() {
    printf("\n=== TOKENS RECONOCIDOS ===\n");
    printf("%-6s %-20s %-15s %-30s\n", "LÍNEA", "TIPO", "LEXEMA", "VALOR");
    printf("-----------------------------------------------------------------------------------\n");
    
    NodoToken* actual = lista_tokens;
    while (actual != NULL) {
        Token* t = actual->token;
        printf("%-6d %-20s %-15s", t->linea, nombre_token(t->tipo), t->lexema);
        
        // Mostrar valor según el tipo de token
        if (t->tipo == TOKEN_NUMERAL) {
            printf("(valor: %d)", t->valor_entero);
        } else if (t->tipo == TOKEN_LITSTRING || t->tipo == TOKEN_ID) {
            if (t->valor_string) {
                // Imprimir string de forma visible (mostrando escapes)
                printf("\"");
                for (int i = 0; t->valor_string[i] != '\0'; i++) {
                    switch(t->valor_string[i]) {
                        case '\n': printf("\\n"); break;
                        case '\t': printf("\\t"); break;
                        case '\\': printf("\\\\"); break;
                        case '"':  printf("\\\""); break;
                        default:   printf("%c", t->valor_string[i]);
                    }
                }
                printf("\"");
            }
        }
        
        printf("\n");
        actual = actual->siguiente;
    }
    
    printf("-----------------------------------------------------------------------------------\n");
    printf("Total de tokens: %d\n", contar_tokens());
}

// Cuenta el número total de tokens


// Libera toda la memoria usada por los tokens
void liberar_tokens() {
    NodoToken* actual = lista_tokens;
    while (actual != NULL) {
        NodoToken* siguiente = actual->siguiente;
        destruir_token(actual->token);
        free(actual);
        actual = siguiente;
    }
}

// Función principal del analizador léxico
int main(int argc, char** argv) {
    // Verificar que se proporcionó un archivo como argumento
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo.mini0>\n", argv[0]);
        fprintf(stderr, "Ejemplo: %s programa.mini0\n", argv[0]);
        return 1;
    }
    
    // Abrir el archivo de entrada
    FILE* archivo = fopen(argv[1], "r");
    if (!archivo) {
        fprintf(stderr, "Error: no se pudo abrir el archivo '%s'\n", argv[1]);
        perror("Detalles");
        return 1;
    }
    
    printf("Analizando archivo: %s\n", argv[1]);
    
    // Configurar yyin (variable de Flex) para leer del archivo
    yyin = archivo;
    
    // Ejecutar el análisis léxico
    // yylex() retorna 0 cuando llega al final del archivo
    yylex();
    
    // Cerrar el archivo
    fclose(archivo);
    
    // Imprimir todos los tokens encontrados
    imprimir_tokens();
    
    // Liberar memoria
    liberar_tokens();
    
    printf("\nAnálisis léxico completado.\n");
    return 0;
}