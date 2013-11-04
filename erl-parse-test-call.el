;;; erl-parse.el --- Semantic details for Erlang

;; Copyright (C) 2013 Thomas JÃ¤rvstrand <tjarvstrand@gmail.com>

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
;; Tests for erl-parse

;;; History:
;;

;;; Code:

;; TODO macros

(defun erl-parse-test-call-check (str expected &optional  qualified)
  (let ((tags (erl-parse-string str 'function-call)))
    (should (equal (length tags) 1))
    (should (equal (semantic-tag-name (car tags)) expected))
    (should (equal (semantic-tag-bounds (car tags)) `(1 ,(1+ (length str)))))
    (should (equal (semantic-tag-get-attribute (car tags) :qualified)
                   qualified))))

(ert-deftest erl-parse-test-call ()
  (erl-parse-test-call-check "f_a()"              "f_a/0")
  (erl-parse-test-call-check "f()"                "f/0")
  (erl-parse-test-call-check "f(1)"               "f/1")
  (erl-parse-test-call-check "f(a)"               "f/1")
  (erl-parse-test-call-check "f(a,)"              "f/1")
  (erl-parse-test-call-check "f(a,a)"             "f/2")
  (erl-parse-test-call-check "f(aa,bb,cc)"        "f/3")
  (erl-parse-test-call-check "f(\"a\")"           "f/1")
  (erl-parse-test-call-check "f(1.2)"             "f/1")
  (erl-parse-test-call-check "f(Var)"             "f/1")
  (erl-parse-test-call-check "f(Var,bb,cc)"       "f/3")
  (erl-parse-test-call-check "f([])"              "f/1")
  (erl-parse-test-call-check "f()"                "f/0")
  (erl-parse-test-call-check "f(b())"             "f/1")
  (erl-parse-test-call-check "f(b(), baz, [a])"   "f/3")
  (erl-parse-test-call-check "'f'(b(), baz, [a])" "'f'/3")
  (erl-parse-test-call-check "F(b(), baz, [a])"   "F/3")
  ;; Can't parse this yet.
  ;; (erl-parse-test-call-check "?f()"   "?/0")
  )

(ert-deftest erl-parse-test-qualified-call ()
  (erl-parse-test-call-check "f:b()"     "f:b/0" t)
  (erl-parse-test-call-check "f:B()"     "f:B/0" t)
  (erl-parse-test-call-check "f:(b)()"   "f:?/0" t)

  (erl-parse-test-call-check "F:b()"     "F:b/0" t)
  (erl-parse-test-call-check "F:B()"     "F:B/0" t)
  (erl-parse-test-call-check "F:(b)()"   "F:?/0" t)

  (erl-parse-test-call-check "(f):b()"   "?:b/0" t)
  (erl-parse-test-call-check "(f):B()"   "?:B/0" t)
  (erl-parse-test-call-check "(f):(b)()" "?:?/0" t))

(ert-deftest erl-parse-test-misc-arg-call ()
  (erl-parse-test-call-check "f(#record{a = b}, #record2{c = d})" "f/2"))

(ert-deftest erl-parse-test-bin-arg-call ()
  (erl-parse-test-call-check "f(<<\"foo\">>)" "f/1")
  (erl-parse-test-call-check "f(<<(foo)>>)" "f/1")
  (erl-parse-test-call-check "f(<<Foo>>)" "f/1")
  (erl-parse-test-call-check "f(<<Foo, Bar>>)" "f/1")
  (erl-parse-test-call-check "f(<<Foo:8>>)" "f/1")
  (erl-parse-test-call-check "f(<<Foo/bits>>)" "f/1")
  (erl-parse-test-call-check "f(<<Foo/bits-signed-little>>)" "f/1"))

(ert-deftest erl-parse-test-operation-arg-call ()
  (erl-parse-test-call-check "f(-1)" "f/1")
  (erl-parse-test-call-check "f(+1)" "f/1")
  (erl-parse-test-call-check "f(+F)" "f/1")
  (erl-parse-test-call-check "f(a = b)" "f/1")
  (erl-parse-test-call-check "f(a ! b)" "f/1")
  (erl-parse-test-call-check "f(1 + 1)" "f/1")
  (erl-parse-test-call-check "f(1 + -F)" "f/1")
  (erl-parse-test-call-check "f([a] ++ [b])" "f/1")
  (erl-parse-test-call-check "f([a] =:= [b])" "f/1"))

(ert-deftest erl-parse-test-macro-arg-call ()
  (erl-parse-test-call-check "f(?macro, a)" "f/2")
  (erl-parse-test-call-check "f(?macro(a), a)" "f/2")
  (erl-parse-test-call-check "f(?macro(a)(), a)" "f/2"))

(ert-deftest erl-parse-test-misc-expression-arg-call ()
  (erl-parse-test-call-check "f(catch f(), a)"
                             "f/2")
  (erl-parse-test-call-check "f(begin f, a, b end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(case f of b -> ok end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(case f of b -> ok; b2 -> error end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(if t -> b end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(if t -> b; f -> baz end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(receive t -> f end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(receive t -> f; f -> b end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(receive t -> b after 1 -> ok end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(receive t -> b after 1 -> ok end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(receive t -> b after 1 -> ok; 2 -> ok end, a)"
                             "f/2")
  (erl-parse-test-call-check "f(try f1 catch f2 -> ok1 end)"
                             "f/1")
  (erl-parse-test-call-check "f(try f1 catch f2:b2 -> ok1 end)"
                             "f/1")
  (erl-parse-test-call-check "f(try f1 of b -> ok catch f2:b2 -> ok1 end)"
                             "f/1")
  (erl-parse-test-call-check "f(fun b/1)"
                             "f/1")
  (erl-parse-test-call-check "f(fun(A, B) -> ok end)"
                             "f/1")
  (erl-parse-test-call-check "f(fun(A, B) -> foo(), ok end)"
                             "f/1")
  (erl-parse-test-call-check "f(fun Var(A, B) -> foo(), ok end)"
                             "f/1")
  (erl-parse-test-call-check "f(fun(A, B) when A == B -> ok end)"
                             "f/1")
  (erl-parse-test-call-check "f(fun(A, B) when A == B, A =/= B -> ok end)"
                             "f/1")
  (erl-parse-test-call-check "f(fun(A, B) when A == B; A =/= B -> ok end)"
                             "f/1")
  (erl-parse-test-call-check
   (concat "f(fun(A, B) when A == B;\n"
           "                 A =/= B,\n"
           "                 A =:= B ->\n"
           "  ok\n"
           "end)")
   "f/1"))

(provide 'erl-parse-test-call)
