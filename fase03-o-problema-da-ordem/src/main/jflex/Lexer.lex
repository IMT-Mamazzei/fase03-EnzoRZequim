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

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Letter         = [a-zA-Z]
Digit          = [0-9]
Number         = {Digit}+("."{Digit}+)?([Ee][+-]?{Digit}+)?
Identifier     = {Letter}({Letter}|{Digit}|_)*

%%

<YYINITIAL> {

    {WhiteSpace}    { /* ignora */ }

    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }

    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    {Identifier}    {
                        if (yytext().length() > 32) {
                            throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext());
                        }
                        return symbol(sym.ID, yytext());
                    }

    {Number}        { return symbol(sym.NUMBER, yytext()); }

    .               { throw new RuntimeException("Erro Léxico: Caractere ilegal -> " + yytext()); }
}

<<EOF>>             { return symbol(sym.EOF); }
