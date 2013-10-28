;;; erl-parse.el --- Semantic details for Erlang

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
;; Tests for erl-parse

;;; History:
;;

;;; Code:

(defun erl-parse-macros-CALL-TAG (module function arity)
  `(if ,module
       (semantic-tag (format "%s:%s/%s" ,module ,function ,arity)
                     'function-call :qualified t)
     (semantic-tag (format "%s/%s" ,function ,arity)
                   'function-call :qualified nil)))

(provide 'erl-parse-macros)
