;;; erlang-wy.el --- Generated parser support file

;; Copyright (C) 2002, 2003 Vladimir G. Sekissov

;; Author: thomas <thomas@brunsnultra>
;; Created: 2013-10-27 16:00:19+0100
;; Keywords: syntax
;; X-RCS: $Id$

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; PLEASE DO NOT MANUALLY EDIT THIS FILE!  It is automatically
;; generated from the grammar file erlang.wy.

;;; History:
;;

;;; Code:

(require 'semantic/lex)
(eval-when-compile (require 'semantic/bovine))

;;; Prologue
;;
(defconst erlang-number-expression
    (concat "\\("
          "\\([0-9]+\\.[0-9]+\\([eE][+-]?[0-9]+\\)?\\)" ;; float
          "\\|"
          "\\(\\([0123]?[0-9]#\\)?[0-9]+\\)" ;; integer
          "\\|"
          "\\(\\$\\(\\\\\\)?.\\)" ;; char
          "\\)")
    "Regexp describing an Erlang number expression")

;;; Declarations
;;
(defconst erlang-wy--keyword-table
  (semantic-lex-make-keyword-table
   '(("after" . AFTER)
     ("and" . AND)
     ("andalso" . ANDALSO)
     ("band" . BAND)
     ("begin" . BEGIN)
     ("bnot" . BNOT)
     ("bor" . BOR)
     ("bsl" . BSL)
     ("bsr" . BSR)
     ("bxor" . BXOR)
     ("case" . CASE)
     ("catch" . CATCH)
     ("div" . DIV)
     ("else" . ELSE)
     ("end" . END)
     ("fun" . FUN)
     ("if" . IF)
     ("not" . NOT)
     ("of" . OF)
     ("or" . OR)
     ("orelse" . ORELSE)
     ("query" . QUERY)
     ("receive" . RECEIVE)
     ("rem" . REM)
     ("try" . TRY)
     ("when" . WHEN)
     ("xor" . XOR))
   'nil)
  "Table of language keywords.")

(defconst erlang-wy--token-table
  (semantic-lex-make-type-table
   '(("string"
      (STRING))
     ("quoted-atom"
      (ATOM))
     ("number"
      (NUMBER . ".*"))
     ("symbol"
      (ATOM . "\\`[a-z].*")
      (VAR . "\\`[A-Z_].*"))
     ("close-paren"
      (RBRACK . "]")
      (RBRACE . "}")
      (RPAREN . ")"))
     ("open-paren"
      (LBRACK . "[")
      (LBRACE . "{")
      (LPAREN . "("))
     ("block"
      (BRACK_BLOCK . "(LBRACK RBRACK)")
      (BRACE_BLOCK . "(LBRACE RBRACE)")
      (PAREN_BLOCK . "(LPAREN RPAREN)"))
     ("punctuation"
      (WHY . "?")
      (VERT_BAR . "|")
      (SUBTRACT . "--")
      (SLASH . "/")
      (SEMICOLON . ";")
      (RBIN . ">>")
      (RARROW . "->")
      (PLUS . "+")
      (PERIOD . ".")
      (NOT_EXACTLY_EQUAL . "=/=")
      (NOT_EQUAL . "/=")
      (MINUS . "-")
      (MATCH . "=")
      (LIST_COMP . "||")
      (LESS_OR_EQUAL . "=<")
      (LESS . "<")
      (LBIN . "<<")
      (HASH . "#")
      (GREATER_OR_EQUAL . ">=")
      (GREATER . ">")
      (EXACTLY_EQUAL . "=:=")
      (EQUAL . "==")
      (CONCATENATE . "++")
      (COMMA . ",")
      (COLON . ":")
      (BANG . "!")
      (ASTERISK . "*")))
   '(("string" :declared t)
     ("quoted-atom" syntax "'.*")
     ("quoted-atom" matchdatatype sexp)
     ("quoted-atom" :declared t)
     ("number" syntax erlang-number-expression)
     ("number" :declared t)
     ("symbol" syntax "[a-zA-Z_][a-zA-Z_@0-9]*\\'")
     ("symbol" :declared t)
     ("keyword" :declared t)
     ("block" :declared t)
     ("punctuation" :declared t)))
  "Table of lexical tokens.")

(defconst erlang-wy--parse-table
  (progn
    (eval-when-compile
      (require 'semantic/wisent/comp))
    (wisent-compile-grammar
     '((ASTERISK BANG COLON COMMA CONCATENATE EQUAL EXACTLY_EQUAL GREATER GREATER_OR_EQUAL HASH LBIN LESS LESS_OR_EQUAL LIST_COMP MATCH MINUS NOT_EQUAL NOT_EXACTLY_EQUAL PERIOD PLUS RARROW RBIN SEMICOLON SLASH SUBTRACT VERT_BAR WHY PAREN_BLOCK BRACE_BLOCK BRACK_BLOCK LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK AFTER AND ANDALSO BAND BEGIN BNOT BOR BSL BSR BXOR CASE CATCH DIV ELSE END FUN IF NOT OF OR ORELSE QUERY RECEIVE REM TRY WHEN XOR VAR ATOM NUMBER STRING)
       nil
       (literal
        ((ATOM))))
     '(literal)))
  "Parser table.")

(defun erlang-wy--install-parser ()
  "Setup the Semantic Parser."
  (semantic-install-function-overrides
   '((parse-stream . wisent-parse-stream)))
  (setq semantic-parser-name "LALR"
        semantic--parse-table erlang-wy--parse-table
        semantic-debug-parser-source "erlang.wy"
        semantic-flex-keywords-obarray erlang-wy--keyword-table
        semantic-lex-types-obarray erlang-wy--token-table)
  ;; Collect unmatched syntax lexical tokens
  (semantic-make-local-hook 'wisent-discarding-token-functions)
  (add-hook 'wisent-discarding-token-functions
            'wisent-collect-unmatched-syntax nil t))


;;; Analyzers
;;
(define-lex-string-type-analyzer erlang-wy--<punctuation>-string-analyzer
  "string analyzer for <punctuation> tokens."
  "\\(\\s.\\|\\s$\\|\\s'\\)+"
  '((WHY . "?")
    (VERT_BAR . "|")
    (SUBTRACT . "--")
    (SLASH . "/")
    (SEMICOLON . ";")
    (RBIN . ">>")
    (RARROW . "->")
    (PLUS . "+")
    (PERIOD . ".")
    (NOT_EXACTLY_EQUAL . "=/=")
    (NOT_EQUAL . "/=")
    (MINUS . "-")
    (MATCH . "=")
    (LIST_COMP . "||")
    (LESS_OR_EQUAL . "=<")
    (LESS . "<")
    (LBIN . "<<")
    (HASH . "#")
    (GREATER_OR_EQUAL . ">=")
    (GREATER . ">")
    (EXACTLY_EQUAL . "=:=")
    (EQUAL . "==")
    (CONCATENATE . "++")
    (COMMA . ",")
    (COLON . ":")
    (BANG . "!")
    (ASTERISK . "*"))
  'punctuation)

(define-lex-block-type-analyzer erlang-wy--<block>-block-analyzer
  "block analyzer for <block> tokens."
  "\\s(\\|\\s)"
  '((("(" LPAREN PAREN_BLOCK)
     ("{" LBRACE BRACE_BLOCK)
     ("[" LBRACK BRACK_BLOCK))
    (")" RPAREN)
    ("}" RBRACE)
    ("]" RBRACK))
  )

(define-lex-sexp-type-analyzer erlang-wy--<quoted-atom>-sexp-analyzer
  "sexp analyzer for <quoted-atom> tokens."
  "'.*"
  'ATOM)

(define-lex-regex-type-analyzer erlang-wy--<symbol>-regexp-analyzer
  "regexp analyzer for <symbol> tokens."
  "[a-zA-Z_][a-zA-Z_@0-9]*\\'"
  '((ATOM . "\\`[a-z].*")
    (VAR . "\\`[A-Z_].*"))
  'symbol)

(define-lex-regex-type-analyzer erlang-wy--<number>-regexp-analyzer
  "regexp analyzer for <number> tokens."
  erlang-number-expression
  '((NUMBER . ".*"))
  'number)

(define-lex-sexp-type-analyzer erlang-wy--<string>-sexp-analyzer
  "sexp analyzer for <string> tokens."
  "\\s\""
  'STRING)

(define-lex-keyword-type-analyzer erlang-wy--<keyword>-keyword-analyzer
  "keyword analyzer for <keyword> tokens."
  "\\(\\sw\\|\\s_\\)+")


;;; Epilogue
;;

(provide 'erlang-wy)

;;; erlang-wy.el ends here
