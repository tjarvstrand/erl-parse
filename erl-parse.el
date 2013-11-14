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
;;

;;; History:
;;

;;; Code:

(require 'semantic/bovine)
(require 'erlang-wy)

(require 'erl-lex)

(when (require 'ert nil t)
  (require 'erl-parse-test-call)
  (require 'erl-parse-test-module))

(defun erl-parse-buffer-init ()
  "Set up a buffer for semantic parsing of the Erlang language."
  (erl-lex-buffer-init)
  (erlang-wy--install-parser))
(add-hook 'erlang-mode-hook 'erl-parse-buffer-init)

(defun erl-parse-buffer (&optional non-terminal allow-errors)
  "Parse the erlang code in current buffer. NON-TERMINAL is the starting
non-terminal if known. If there where parse errors; return the parsing
result if ALLOW-ERRORS is non-nil, otherwise nil."
  (let ((res (semantic-parse-region (point-min) (point-max) non-terminal)))
    (unless (and (> wisent-nerrs 0) (not allow-errors))
      res)))

(defun erl-parse-stream (stream &optional non-terminal allow-errors)
  "Parse the erlang lexical tokens in STREAM. NON-TERMINAL is the starting
non-terminal if known. If there where parse errors; return the parsing
result if ALLOW-ERRORS is non-nil, otherwise nil."
  (let ((res (semantic-parse-stream stream non-terminal)))
    (unless (and (> wisent-nerrs 0) (not allow-errors))
      res)))

(defun erl-parse-string (str &optional non-terminal allow-errors)
  "Parse STR. If NON-TERMINAL is non-nil, start with that rule."
  (with-temp-buffer
    (erl-parse-buffer-init)
    (insert str)
    (erl-parse-buffer non-terminal allow-errors)))

(provide 'erl-parse)

