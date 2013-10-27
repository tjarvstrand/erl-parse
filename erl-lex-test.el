;;; erl-lex.el --- Semantic details for Erlang

;; Copyright (C) 2013 Thomas Järvstrand <tjarvstrand@gmail.com>

;; Author: Thomas Järvstrand <tjarvstrand@gmail.com>

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; Tests for erl-lex

;;; History:
;;

;;; Code:

(defun erl-lex-test (str expected-tokens &optional depth)
  (should (equal (erl-lex-analyze-string str depth) expected-tokens)))

(ert-deftest erl-lex-test-symbol ()
  (erl-lex-test "a"    '((ATOM 1 . 2)))
  (erl-lex-test "and"  '((AND  1 . 4)))
  (erl-lex-test "fand" '((ATOM 1 . 5)))
  (erl-lex-test "Foo"  '((VAR  1 . 4)))
  (erl-lex-test "_Foo" '((VAR  1 . 5)))
  (should-error (erl-lex-test "1foo")))

(ert-deftest erl-lex-test-string ()
  (erl-lex-test "'a'"  '((ATOM 1 . 4)))
  (erl-lex-test "\"a\""'((STRING   1 . 4))))

(ert-deftest erl-lex-test-number ()
  ;; Errors such as $aa $@a $\"a etc have to be caught by the grammar
  (erl-lex-test "16"     '((NUMBER 1 . 3)))
  (erl-lex-test "16#12"  '((NUMBER 1 . 6)))
  (erl-lex-test "16.12"  '((NUMBER 1 . 6)))
  (erl-lex-test "1.2e4"  '((NUMBER 1 . 6)))
  (erl-lex-test "1.2 e4" '((NUMBER 1 . 4) (ATOM 5 . 7)))
  (should-error (erl-lex-analyze-string "1.2e 3"))
  (erl-lex-test "$a"    '((NUMBER 1 . 3)))
  (erl-lex-test "$\\a"    '((NUMBER 1 . 4)))
  (erl-lex-test "$\\\"" '((NUMBER 1 . 4)))
  (erl-lex-test "$\"" '((NUMBER 1 . 3)))
  (should-error (erl-lex-analyze-string "$")))

(ert-deftest erl-lex-test-punctuation ()
  (erl-lex-test "->"  '((RARROW            1 . 3)))
  (erl-lex-test "!"   '((BANG              1 . 2)))
  (erl-lex-test ":"   '((COLON             1 . 2)))
  (erl-lex-test ","   '((COMMA             1 . 2)))
  (erl-lex-test "--"  '((SUBTRACT          1 . 3)))
  (erl-lex-test "/"   '((SLASH             1 . 2)))
  (erl-lex-test "=="  '((EQUAL             1 . 3)))
  (erl-lex-test "=:=" '((EXACTLY_EQUAL     1 . 4)))
  (erl-lex-test "=/=" '((NOT_EXACTLY_EQUAL 1 . 4)))
  (erl-lex-test "="   '((MATCH             1 . 2)))
  (erl-lex-test "/="  '((NOT_EQUAL         1 . 3)))
  (erl-lex-test ">="  '((GREATER_OR_EQUAL  1 . 3)))
  (erl-lex-test ">>"  '((RBIN              1 . 3)))
  (erl-lex-test ">"   '((GREATER           1 . 2)))
  (erl-lex-test "#"   '((HASH              1 . 2)))
  (erl-lex-test "++"  '((CONCATENATE       1 . 3)))
  (erl-lex-test "=<"  '((LESS_OR_EQUAL     1 . 3)))
  (erl-lex-test "<<"  '((LBIN              1 . 3)))
  (erl-lex-test "<"   '((LESS              1 . 2)))
  (erl-lex-test "-"   '((MINUS             1 . 2)))
  (erl-lex-test "."   '((PERIOD            1 . 2)))
  (erl-lex-test "+"   '((PLUS              1 . 2)))
  (erl-lex-test ";"   '((SEMICOLON         1 . 2)))
  (erl-lex-test "*"   '((ASTERISK          1 . 2)))
  (erl-lex-test "||"  '((LIST_COMP         1 . 3)))
  (erl-lex-test "|"   '((VERT_BAR          1 . 2)))
  (erl-lex-test "?"   '((WHY               1 . 2))))

(ert-deftest erl-lex-test-paren ()
  (erl-lex-test "("     '((LPAREN      1 . 2)) 1)
  (erl-lex-test ")"     '((RPAREN      1 . 2)) 1)
  (erl-lex-test "("     '((PAREN_BLOCK 1 . 2)))
  (erl-lex-test ")"     '((RPAREN      1 . 2)))
  (erl-lex-test "()"    '((LPAREN      1 . 2) (RPAREN 2 . 3)) 1)
  (erl-lex-test "()"    '((PAREN_BLOCK 1 . 3)))
  (erl-lex-test "( a )" '((PAREN_BLOCK 1 . 6)))
  (erl-lex-test "{"     '((LBRACE      1 . 2)) 1)
  (erl-lex-test "}"     '((RBRACE      1 . 2)) 1)
  (erl-lex-test "{"     '((BRACE_BLOCK 1 . 2)))
  (erl-lex-test "}"     '((RBRACE      1 . 2)))
  (erl-lex-test "{}"    '((LBRACE      1 . 2) (RBRACE 2 . 3)) 1)
  (erl-lex-test "{}"    '((BRACE_BLOCK 1 . 3)))
  (erl-lex-test "{ a }" '((BRACE_BLOCK 1 . 6)))
  (erl-lex-test "["     '((LBRACK      1 . 2)) 1)
  (erl-lex-test "]"     '((RBRACK      1 . 2)) 1)
  (erl-lex-test "["     '((BRACK_BLOCK 1 . 2)))
  (erl-lex-test "]"     '((RBRACK      1 . 2)))
  (erl-lex-test "[]"    '((LBRACK      1 . 2) (RBRACK 2 . 3)) 1)
  (erl-lex-test "[]"    '((LBRACK      1 . 2) (RBRACK 2 . 3)) 1)
  (erl-lex-test "[ a ]" '((BRACK_BLOCK 1 . 6))))


(ert-deftest erl-lex-test-expression ()
  (erl-lex-test "16 + 16"       '((NUMBER 1 . 3) (PLUS 4 . 5) (NUMBER 6 . 8)))
  (erl-lex-test "16+16"         '((NUMBER 1 . 3) (PLUS 3 . 4) (NUMBER 4 . 6)))
  (erl-lex-test "16 and 16"     '((NUMBER 1 . 3) (AND  4 . 7) (NUMBER 8 . 10)))
  (should-error (erl-lex-string "16and16")))

(provide 'erl-lex-test)
