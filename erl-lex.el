;;; erl-lex.el --- Lexical analysis for Erlang

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
;;

;;; History:
;;

;;; Code:
(require 'semantic/lex)
(require 'erlang)

(when (require 'ert nil t)
  (require 'erl-lex-test))

(define-lex erl-lex
  "Lexical Analyzer for Erlang code."
  semantic-lex-ignore-whitespace
  semantic-lex-ignore-newline
  semantic-lex-ignore-comments
  erlang-wy--<keyword>-keyword-analyzer
  erlang-wy--<int>-regexp-analyzer
  erlang-wy--<float>-regexp-analyzer
  erlang-wy--<symbol>-regexp-analyzer
  erlang-wy--<quoted-atom>-sexp-analyzer
  erlang-wy--<string>-sexp-analyzer
  erlang-wy--<block>-block-analyzer
  erlang-wy--<punctuation>-string-analyzer
  semantic-lex-default-action)

(defun erl-lex-buffer-init ()
  "Set up a buffer for semantic parsing of the Erlang language."
  (erlang-syntax-table-init)
  (set-syntax-table erlang-mode-syntax-table)
  (setq
   case-fold-search nil
   semantic-lex-syntax-table      erlang-mode-syntax-table
   semantic-lex-analyzer          'erl-lex
   semantic-flex-keywords-obarray erlang-wy--keyword-table)
  (semantic-lex-init))

(defun erl-lex-region (start end &optional depth length)
  "Lexically analyze text in the current buffer between START and END.
Optional argument DEPTH indicates at what level to scan over entire
lists.  The last argument, LENGTH specifies that `erl-lex' should only
 return LENGTH tokens.  The return value is a token stream, see
`semantic-lex'."
  (let ((case-fold-search nil))
    (semantic-lex start end depth length)))

(defun erl-lex-buffer (&optional depth)
  (let ((case-fold-search nil))
    (semantic-lex-buffer depth)))

(defun erl-lex-analyze-string (str &optional depth)
  (with-temp-buffer
        (erl-lex-buffer-init)
        (insert str)
        (erl-lex-buffer depth)))

(provide 'erl-lex)
