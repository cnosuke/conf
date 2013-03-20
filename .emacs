(setq-default tab-width 4 indent-tabs-mode nil)
(setq c-default-style "linux")
(if window-system (progn

(set-face-foreground 'font-lock-comment-face "MediumSeaGreen")
(set-face-foreground 'font-lock-string-face  "purple")
(set-face-foreground 'font-lock-keyword-face "blue")
(set-face-foreground 'font-lock-function-name-face "blue")
(set-face-bold-p 'font-lock-function-name-face t)
(set-face-foreground 'font-lock-variable-name-face "black")
(set-face-foreground 'font-lock-type-face "LightSeaGreen")
(set-face-foreground 'font-lock-builtin-face "purple")
(set-face-foreground 'font-lock-constant-face "black")
(set-face-foreground 'font-lock-warning-face "blue")
(set-face-bold-p 'font-lock-warning-face nil)

))

(setq load-path
      (append
       (list
        (expand-file-name "~/.elisp/ruby1.8-elisp/")
        )
       load-path))

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda () (inf-ruby-keys)))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; rubydb
(autoload 'rubydb "rubydb3x"
  "run rubydb on program file in buffer *gud-file*.
the directory containing file becomes the initial working directory
and source-file directory for your debugger." t)

;; ruby-block
;;(require 'ruby-block)
;;(ruby-block-mode t)
;;(setq ruby-block-highlight-toggle t)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil)
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
