/*
 * token.c
 * Implementación de las funciones para manejar tokens
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "token.h"

// Crea un nuevo token y lo inicializa
Token* crear_token(TipoToken tipo, const char* lexema, int linea) {
    // Reservar memoria para el token
    Token* token = (Token*)malloc(sizeof(Token));
    if (!token) {
        fprintf(stderr, "Error: no se pudo asignar memoria para el token\n");
        exit(1);
    }
    
    // Inicializar campos
    token->tipo = tipo;
    token->linea = linea;
    token->valor_entero = 0;
    token->valor_string = NULL;
    
    // Copiar el lexema (texto original)
    token->lexema = (char*)malloc(strlen(lexema) + 1);
    if (!token->lexema) {
        fprintf(stderr, "Error: no se pudo asignar memoria para el lexema\n");
        exit(1);
    }
    strcpy(token->lexema, lexema);
    
    return token;
}

// Libera la memoria ocupada por un token
void destruir_token(Token* token) {
    if (token) {
        if (token->lexema) free(token->lexema);
        if (token->valor_string) free(token->valor_string);
        free(token);
    }
}

// Retorna el nombre legible de un tipo de token
// Útil para debugging e impresión de resultados
const char* nombre_token(TipoToken tipo) {
    switch(tipo) {
        case TOKEN_IF: return "IF";
        case TOKEN_ELSE: return "ELSE";
        case TOKEN_END: return "END";
        case TOKEN_WHILE: return "WHILE";
        case TOKEN_LOOP: return "LOOP";
        case TOKEN_FUN: return "FUN";
        case TOKEN_RETURN: return "RETURN";
        case TOKEN_NEW: return "NEW";
        case TOKEN_STRING: return "STRING";
        case TOKEN_INT: return "INT";
        case TOKEN_CHAR: return "CHAR";
        case TOKEN_BOOL: return "BOOL";
        case TOKEN_TRUE: return "TRUE";
        case TOKEN_FALSE: return "FALSE";
        case TOKEN_AND: return "AND";
        case TOKEN_OR: return "OR";
        case TOKEN_NOT: return "NOT";
        case TOKEN_ID: return "IDENTIFICADOR";
        case TOKEN_NUMERAL: return "NUMERAL";
        case TOKEN_LITSTRING: return "STRING_LITERAL";
        case TOKEN_GT: return "MAYOR_QUE";
        case TOKEN_LT: return "MENOR_QUE";
        case TOKEN_GTE: return "MAYOR_IGUAL";
        case TOKEN_LTE: return "MENOR_IGUAL";
        case TOKEN_EQ: return "IGUAL";
        case TOKEN_NEQ: return "DIFERENTE";
        case TOKEN_PLUS: return "SUMA";
        case TOKEN_MINUS: return "RESTA";
        case TOKEN_MULT: return "MULTIPLICACION";
        case TOKEN_DIV: return "DIVISION";
        case TOKEN_LPAREN: return "PAREN_IZQ";
        case TOKEN_RPAREN: return "PAREN_DER";
        case TOKEN_LBRACKET: return "CORCHETE_IZQ";
        case TOKEN_RBRACKET: return "CORCHETE_DER";
        case TOKEN_COMMA: return "COMA";
        case TOKEN_COLON: return "DOS_PUNTOS";
        case TOKEN_NL: return "SALTO_LINEA";
        case TOKEN_ERROR: return "ERROR";
        case TOKEN_EOF: return "FIN_ARCHIVO";
        default: return "DESCONOCIDO";
    }
}