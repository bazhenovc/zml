/** Zero-bloated Markup Language
	CC0 License

	This software is provided 'as-is', without any express or implied
	warranty. In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required. 
	2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software. 
	3. This notice may not be removed or altered from any source distributio
**/

%{
#include <iostream>
#include <string>

#define YYSTYPE std::string

#include "zml_parser.hh"
%}

%x COMMENT
%x MULTILINE_COMMENT
%x STRING_LITERAL

digit [0-9]*
identifier [A-Za-z](_|[A-Za-z]|[0-9])*

%%

"\/\/"                   { BEGIN(COMMENT);                }
<COMMENT>.               { yylval = yytext;               }
<COMMENT>\n\r|\r\n|\n|\r { yylineno++; BEGIN(INITIAL);    }

"\/*"                              { BEGIN(MULTILINE_COMMENT);      }
<MULTILINE_COMMENT>\n\r|\r\n|\n|\r { yylineno++;                    }
<MULTILINE_COMMENT>"*\/"           { BEGIN(INITIAL);                }
<MULTILINE_COMMENT>.               { yylval = yytext;               }

"\""                 { yylval.clear(); BEGIN(STRING_LITERAL);  }
<STRING_LITERAL>"\"" { BEGIN(INITIAL); return StringLiteral;   }
<STRING_LITERAL>.    { yylval += yytext;                       }

\n\r|\r\n|\n|\r { yylineno++;                           }
"="             { yylval = yytext; return Equals;       }
":"             { yylval = yytext; return Colon;        }
";"             { yylval = yytext; return Semicolon;    }
"."             { yylval = yytext; return Dot;          }
","             { yylval = yytext; return Comma;        }
"{"             { yylval = yytext; return LeftCBrace;   }
"}"             { yylval = yytext; return RightCBrace;  }
"["             { yylval = yytext; return LeftBrace;    }
"]"             { yylval = yytext; return RightBrace;   }
{digit}         { yylval = yytext; return Digit;        }
{identifier}    { yylval = yytext; return Identifier;   }
[ \t]+          {}
.               { yylval = yytext;                      }
%%