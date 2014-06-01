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

;; TODO macros, named funs, matches, binary matches, guards

(defun erl-parse-test-module-check (str expected-name expected-class attrs)
  (let* ((tags (erl-parse-string str 'module))
         (tag  (car tags)))
    (should (equal (length tags) 1))
    (should (equal (semantic-tag-name tag) expected-name))
    (should (equal (semantic-tag-class tag) expected-class))
    (should (equal (semantic-tag-bounds tag) `(1 ,(1+ (length str)))))
    (loop for (attr . val) in attrs
          do  (message "val %s" val)
          do  (should (equal val (semantic-tag-get-attribute tag attr))))))

(ert-deftest erl-parse-test-module-decl ()
  (let* ((tags (erl-parse-string "-module foo." 'module))
         (tag  (car tags)))
    (should (equal (length tags) 1))
    (should (equal (semantic-tag-name tag) "module"))
    (should (equal (semantic-tag-class tag) 'attribute))
    (should (equal (semantic-tag-bounds tag) '(1 13)))
    (let ((params (semantic-tag-get-attribute tag :parameters)))
      (should (equal (length params) 1))
      (should (equal (semantic-tag-name (car params)) "foo"))))

    (let* ((tags (erl-parse-string "-module(foo)." 'module))
         (tag  (car tags)))
    (should (equal (length tags) 1))
    (should (equal (semantic-tag-name tag) "module"))
    (should (equal (semantic-tag-class tag) 'attribute))
    (should (equal (semantic-tag-bounds tag) '(1 14)))
    (let ((params (semantic-tag-get-attribute tag :parameters)))
      (should (equal (length params) 1))
      (should (equal (semantic-tag-name (car params)) "foo"))))

    (let* ((tags (erl-parse-string "-module(foo, [Foo, Bar])." 'module))
           (tag  (car tags)))
      (should (equal (length tags) 1))
      (should (equal (semantic-tag-name tag) "module"))
      (should (equal (semantic-tag-class tag) 'attribute))
      (should (equal (semantic-tag-bounds tag) '(1 26)))
      (let ((params (semantic-tag-get-attribute tag :parameters)))
        (should (equal (length params) 2))
        (should (equal (semantic-tag-name (car params)) "foo"))
        (should (equal (semantic-tag-name (cadr params)) "[Foo, Bar]")))))

(ert-deftest erl-parse-test-module-record-decl ()
  (let* ((tags (erl-parse-string "-record(foo, {foo=\"\"::string()})." 'module))
         (tag  (car tags)))
    (should (equal (length tags) 1))
    (should (equal (semantic-tag-name tag) "record"))
    (should (equal (semantic-tag-class tag) 'attribute))
    (should (equal (semantic-tag-bounds tag) '(1 34)))
    (let ((params (semantic-tag-get-attribute tag :parameters)))
      (should (equal (length params) 2))
      (should (equal (semantic-tag-name (car params)) "foo"))
      (should (equal (semantic-tag-name (cadr params))
                     "{foo=\"\"::string()}")))))

(ert-deftest erl-parse-test-module-type-decl ()
  (let* ((tags (erl-parse-string "-type foo." 'module))
         (tag  (car tags)))
    (should (equal (length tags) 1))
    (should (equal (semantic-tag-name tag) "type"))
    (should (equal (semantic-tag-class tag) 'attribute))
    (should (equal (semantic-tag-bounds tag) '(1 11)))
    (let ((params (semantic-tag-get-attribute tag :parameters)))
      (should (equal (length params) 1))
      (should (equal (semantic-tag-name (car params)) "foo")))))

(provide 'erl-parse-test-module)
