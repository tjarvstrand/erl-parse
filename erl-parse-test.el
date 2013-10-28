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

(ert-deftest erl-parse-test-function-call ()
  (let ((tag (erl-parse-string "foo()" 'function-call)))
    (should (equal (semantic-tag-name tag) "foo/0"))))

(provide 'erl-parse-test)
