#!/bin/bash

lex -o zml_lexer.cc --header-file=zml_lexer.hh grammar/zml_lexer.l
yacc -d grammar/zml_parser.y -o zml_parser.cc
