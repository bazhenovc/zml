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
#include "zml_lexer.hh"

#include <zml.hh>

#include <string>
#include <iostream>
#include <vector>

#ifndef YYERROR_VERBOSE
#define YYERROR_VERBOSE 1
#endif

#define YYSTYPE YYSType
#define YYPARSE_PARAM doc_ptr
#define DOC ((zml::Document*)doc_ptr)

//-----------------------------------------------------------------------------
void yyerror(const char *str)
{
	fprintf(stderr,"error: %s at line %i\n", str, yyget_lineno());
}
 
int yywrap()
{
	return 1;
}

//////
struct yyAny
{
	enum Type
	{
		kNone,
		kField,
		kObject
	};

	Type        type;
	zml::Object object;
	zml::Field  field;
};

struct YYSType
{
	std::string typeString;
	zml::Object typeObject;
	yyAny       typeAny;
};

%}

%token Digit;
%token Equals;
%token Colon;
%token Semicolon;
%token Dot;
%token Comma;
%token LeftCBrace;
%token RightCBrace;
%token LeftBrace;
%token RightBrace;
%token Identifier;
%token StringLiteral;

%type <typeString> Digit;
%type <typeString> Equals;
%type <typeString> Colon;
%type <typeString> Semicolon;
%type <typeString> Dot;
%type <typeString> Comma;
%type <typeString> LeftCBrace;
%type <typeString> RightCBrace;
%type <typeString> LeftBrace;
%type <typeString> RightBrace;
%type <typeString> Identifier;
%type <typeString> StringLiteral;

%type <typeString> numeric_constant;
%type <typeString> name;
%type <typeString> value;

%type <typeAny>    section_item;
%type <typeObject> section_body;

%start translation_unit;

%%

translation_unit
	: toplevel
	| translation_unit toplevel
	;

numeric_constant
	: Digit
	{ $$ = $1; }
	| Digit Dot Digit
	{ $$ = $1 + $2 + $3; }
	;

name
	: Identifier
	{ $$ = $1; }
	;

value
	: Identifier
	{ $$ = $1; }
	| StringLiteral
	{ $$ = $1; }
	| numeric_constant
	{ $$ = $1; }
	;

// object def
section_def
	// <name> { <body> }
	: name LeftCBrace section_body RightCBrace
	{
		$3.SetName($1);
		DOC->GetRootObject().GetChildren().push_back($3);
	}
	;

section_item
	// <name> = <value>
	: name Equals value
	{
		$$.type = yyAny::kField;
		$$.field.SetName($1);
		$$.field.SetValue($3);
	}

	// <name> { <body> }
	| name LeftCBrace section_body RightCBrace
	{
		$$.type = yyAny::kObject;
		$$.object = $3;
		$$.object.SetName($1);
	}
	;

section_body
	: section_item
	{
		switch ($1.type)
		{
		case yyAny::kField:
			$$.GetFields().push_back($1.field);
			break;

		case yyAny::kObject:
			$$.GetChildren().push_back($1.object);
			break;

		case yyAny::kNone:
			break;
		}
	}
	
	| section_body section_item
	{
		switch ($2.type)
		{
		case yyAny::kField:
			$$.GetFields().push_back($2.field);
			break;

		case yyAny::kObject:
			$$.GetChildren().push_back($2.object);
			break;

		case yyAny::kNone:
			break;
		}
	}
	;

// toplevel
toplevel
	: section_def
	;
%%
namespace zml
{

bool Document::Load(const std::string& buffer)
{
	yy_scan_string(buffer.c_str());
	return yyparse(this) == 0;
}

}
