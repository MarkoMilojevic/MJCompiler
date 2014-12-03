package rs.ac.bg.etf.pp1;

import java_cup.runtime.Symbol;

%%

%cup
%line
%column

%{
	StringBuffer string = new StringBuffer();
	
	// ukljucivanje informacije o poziciji tokena
	private Symbol new_symbol(int type) {
		return new Symbol(type, yyline+1, yycolumn);
	}
	
	// ukljucivanje informacije o poziciji tokena
	private Symbol new_symbol(int type, Object value) {
		return new Symbol(type, yyline+1, yycolumn, value);
	}

%}

/* main character classes */
LineTerminator = \r|\n|\r\n

/* integer literals */
DecIntegerLiteral = 0 | [1-9][0-9]*
OctDigit          = [0-7]

/* string and character literals */
StringCharacter = [^\r\n\"\\]
SingleCharacter = [^\r\n\'\\]

%xstate COMMENT, STRING, CHAR

%eofval{
	return new_symbol(sym.EOF);
%eofval}

%%

<YYINITIAL> {
	" " 	{ }
	"\b" 	{ }
	"\t" 	{ }
	"\r\n" 	{ }
	"\f" 	{ }
	
	/* keywords */
	"program"	{ return new_symbol(sym.PROGRAM, yytext()); }
	"break"		{ return new_symbol(sym.BREAK, yytext()); }
	"class"		{ return new_symbol(sym.CLASS, yytext()); }
	"else"		{ return new_symbol(sym.ELSE, yytext()); }
	"const"		{ return new_symbol(sym.CONST, yytext()); }
	"if"		{ return new_symbol(sym.IF, yytext()); }
	"new"		{ return new_symbol(sym.NEW, yytext()); }
	"print"		{ return new_symbol(sym.PRINT, yytext()); }
	"read"		{ return new_symbol(sym.READ, yytext()); }
	"return" 	{ return new_symbol(sym.RETURN, yytext()); }
	"void" 		{ return new_symbol(sym.VOID, yytext()); }
	"while" 	{ return new_symbol(sym.WHILE, yytext()); }
	"extends"	{ return new_symbol(sym.EXTENDS, yytext()); }
	
	/* boolean literals */
	"true" 		{ return new_symbol(sym.BOOL, new Boolean(true)); }
	"false" 	{ return new_symbol(sym.BOOL, new Boolean(false)); }
	
	/* operators */
	"=" 		{ return new_symbol(sym.EQ, yytext()); }
	"+" 		{ return new_symbol(sym.PLUS, yytext()); }
	"-" 		{ return new_symbol(sym.MINUS, yytext()); }
	"*" 		{ return new_symbol(sym.MULT, yytext()); }
	"/" 		{ return new_symbol(sym.DIV, yytext()); }
	"%" 		{ return new_symbol(sym.MOD, yytext()); }
	"==" 		{ return new_symbol(sym.EQEQ, yytext()); }
	"!=" 		{ return new_symbol(sym.NOTEQ, yytext()); }
	">" 		{ return new_symbol(sym.GT, yytext()); }
	">=" 		{ return new_symbol(sym.GTEQ, yytext()); }
	"<" 		{ return new_symbol(sym.LT, yytext()); }
	"<=" 		{ return new_symbol(sym.LTEQ, yytext()); }
	"&&" 		{ return new_symbol(sym.ANDAND, yytext()); }
	"||" 		{ return new_symbol(sym.OROR, yytext()); }	
	"++" 		{ return new_symbol(sym.PLUSPLUS, yytext()); }
	"--" 		{ return new_symbol(sym.MINUSMINUS, yytext()); }
	
	/* separators */
	";" 		{ return new_symbol(sym.SEMICOLON, yytext()); }
	"," 		{ return new_symbol(sym.COMMA, yytext()); }
	"." 		{ return new_symbol(sym.DOT, yytext()); }
	"(" 		{ return new_symbol(sym.LPAREN, yytext()); }
	")" 		{ return new_symbol(sym.RPAREN, yytext()); }
	"[" 		{ return new_symbol(sym.LBRACK, yytext()); }
	"]" 		{ return new_symbol(sym.RBRACK, yytext()); }
	"{" 		{ return new_symbol(sym.LBRACE, yytext()); }
	"}"			{ return new_symbol(sym.RBRACE, yytext()); }
	
	/* number literals */
	{DecIntegerLiteral}  { return new_symbol(sym.NUMBER, new Integer(yytext())); }
	
	/* identifier literals */
	([a-z]|[A-Z])[a-z|A-Z|0-9|_]* 	{return new_symbol (sym.IDENT, yytext()); }	
	
	/* string literal */
  	\"		{ yybegin(STRING); string.setLength(0); }

 	/* character literal */
  	\'		{ yybegin(CHAR); }
  	
  	/* comments */
	"//"	{ yybegin(COMMENT); }
  	
	/* errors */
	. 		{ System.err.println("Lexical error - ("+yytext()+") in line "+(yyline+1) + ", in column " + (yycolumn + 1)); }
}

<STRING> {
  \"                    { yybegin(YYINITIAL); return new_symbol(sym.STRING, string.toString()); }
  {StringCharacter}+	{ string.append( yytext() ); }
  
  /* escape sequences */
  "\\b"                          { string.append( '\b' ); }
  "\\t"                          { string.append( '\t' ); }
  "\\n"                          { string.append( '\n' ); }
  "\\f"                          { string.append( '\f' ); }
  "\\r"                          { string.append( '\r' ); }
  "\\\""                         { string.append( '\"' ); }
  "\\'"                          { string.append( '\'' ); }
  "\\\\"                         { string.append( '\\' ); }
  \\[0-3]?{OctDigit}?{OctDigit}  { char val = (char) Integer.parseInt(yytext().substring(1),8); string.append( val ); }
  
  /* error cases */
  \\.				{ System.err.println("Illegal escape sequence - ("+yytext()+") in line "+(yyline+1) + ", in column " + (yycolumn + 1)); yybegin(YYINITIAL); }
  {LineTerminator}  { System.err.println("Unterminated string at end of line - ("+yytext()+") in line "+(yyline+1) + ", in column " + (yycolumn + 1)); yybegin(YYINITIAL); }
}

<CHAR> {
  {SingleCharacter}\'	{ yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character(yytext().charAt(0))); }
  
  /* escape sequences */
  "\\b"\'                        { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\b'));}
  "\\t"\'                        { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\t'));}
  "\\n"\'                        { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\n'));}
  "\\f"\'                        { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\f'));}
  "\\r"\'                        { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\r'));}
  "\\\""\'                       { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\"'));}
  "\\'"\'                        { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\''));}
  "\\\\"\'                       { yybegin(YYINITIAL); return new_symbol(sym.CHAR, new Character('\\')); }
  \\[0-3]?{OctDigit}?{OctDigit}  { char val = (char) Integer.parseInt(yytext().substring(1),8); string.append( val ); }
  
  /* error cases */
  \\.				{ System.err.println("Illegal escape sequence - ("+yytext()+") in line "+(yyline+1) + ", in column " + (yycolumn + 1)); yybegin(YYINITIAL); }
  {LineTerminator}  { System.err.println("Unterminated character literal at end of line - ("+yytext()+") in line "+(yyline+1) + ", in column " + (yycolumn + 1)); yybegin(YYINITIAL); }
}

<COMMENT> {
	.      { yybegin(COMMENT); }
	"\r\n" { yybegin(YYINITIAL); }
}
