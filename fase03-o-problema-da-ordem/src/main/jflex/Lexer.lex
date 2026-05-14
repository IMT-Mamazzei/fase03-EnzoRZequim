package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */

LineTerminator     = \r|\n|\r\n
WhiteSpace         = {LineTerminator} | [ \t\f]

Letter             = [a-zA-Z]
Digit              = [0-9]

/* Aceita: 7, 3.14, 6.02E23, 6.62e-34 */
Number             = {Digit}+("."{Digit}+)?([Ee][+-]?{Digit}+)?

/* Identificador válido: 1 a 32 caracteres */
Identifier         = {Letter}({Letter}|{Digit}|_){0,31}

/* Identificador inválido: mais de 32 caracteres */
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {

    /* Espaços em branco */
    {WhiteSpace}            { /* ignora */ }

    /* Palavras reservadas */
    "if"                    { return symbol(sym.IF); }
    "then"                  { return symbol(sym.THEN); }
    "else"                  { return symbol(sym.ELSE); }
    "while"                 { return symbol(sym.WHILE); }

    /* Pontuação */
    "("                     { return symbol(sym.LPAREN); }
    ")"                     { return symbol(sym.RPAREN); }
    "{"                     { return symbol(sym.LBRACE); }
    "}"                     { return symbol(sym.RBRACE); }
    ";"                     { return symbol(sym.SEMI); }

    /* Operadores relacionais e de atribuição
       operadores duplos antes dos simples */
    "=="                    { return symbol(sym.REL_OP, yytext()); }
    "!="                    { return symbol(sym.REL_OP, yytext()); }
    "<="                    { return symbol(sym.REL_OP, yytext()); }
    ">="                    { return symbol(sym.REL_OP, yytext()); }
    "<"                     { return symbol(sym.REL_OP, yytext()); }
    ">"                     { return symbol(sym.REL_OP, yytext()); }
    "="                     { return symbol(sym.ASSIGN); }

    /* Operadores matemáticos */
    "+" | "-"               { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%"         { return symbol(sym.MUL_OP, yytext()); }

    /* Identificadores e números */
    {Identifier}            { return symbol(sym.ID, yytext()); }
    {Number}                { return symbol(sym.NUMBER, yytext()); }

    /* Erro para identificador grande demais */
    {OversizedIdentifier}   {
                                throw new RuntimeException(
                                    "Erro Léxico: Identificador gigante -> " + yytext()
                                );
                            }

    /* Caractere inválido */
    .                       {
                                throw new RuntimeException(
                                    "Erro Léxico: Caractere ilegal -> " + yytext()
                                );
                            }
}

/* Final do arquivo */
<<EOF>>                     { return symbol(sym.EOF); }
