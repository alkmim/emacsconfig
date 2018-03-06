(package-initialize)

(require 'package)

; Setting up package repos
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

; Installing packages
(package-install 'better-defaults)
(package-install 'elpy)
(package-install 'org)
(package-install 'material-theme)
(package-install 'magit)
(package-install 'markdown-mode)
(package-install 'helm)
(package-install 'flycheck)
(package-install 'multi-term)
(package-install 'pcap-mode)
(package-install 'company)
(package-install 'company-jedi)
(package-install 'openwith)
(package-install 'company-quickhelp)
(package-install 'sphinx-doc)
(package-install 'realgud)
(package-install 'edit-server)

; Set up global hacks
(global-set-key (kbd "C-x C-b") 'buffer-menu-other-window)
(setq linum-format "%4d \u2502 ")
(global-linum-mode 1)
(setq column-number-mode t)
(load-theme 'material t)
(set-face-attribute 'default nil :height 90) ; The value is in 1/10pt (90 = 9pt)
(setq-default fill-column 80)
(setq browse-url-generic-program "firefox")
(windmove-default-keybindings) ; Set moving with shift

; Default Applications
; PDFs visited in Org-mode are opened in Evince (and not in the default choice) https://stackoverflow.com/a/8836108/789593
(add-hook 'org-mode-hook
      '(lambda ()
         (delete '("\\.pdf\\'" . default) org-file-apps)
         (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))))


; Helm mode
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)

; Set up edit server. Allows to edit textareas from browsers using emacs
; Requires installation of the extension: https://addons.mozilla.org/en-US/firefox/addon/edit-with-emacs1/
(require 'edit-server)
(edit-server-start)

; Openwith
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.pdf\\'" "evince" (file))))
(setq openwith-associations '(("\\.db\\'" "sqlitebrowser" (file))))

; Recentf mode
(recentf-mode 1) ; keep a list of recently opened files
(global-set-key (kbd "<f7>") 'recentf-open-files)
(run-with-timer 0 (* 60 1) 'recentf-save-list)

; Org-Mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-replace-disputed-keys t)
(eval-after-load "org"
  '(progn
     (define-key org-mode-map "\C-t" 'org-todo)
     (define-key org-mode-map (kbd "<S-left>") nil)
     (define-key org-mode-map (kbd "<S-right>") nil)
     (define-key org-mode-map (kbd "<S-down>") nil)
     (define-key org-mode-map (kbd "<S-up>") nil)))
(add-hook 'org-mode-hook
  (lambda ()
    (define-key org-mode-map "\C-RET" 'org-insert-heading-respect-content)
    (define-key org-mode-map (kbd "<C-t>") 'org-todo)))

(setq org-agenda-files (list "~/Documents/orgmode/"))

; Org-Mode Todo's
(setq org-todo-keywords
      '((sequence "TODO" "BLOCKED" "DOING" "WAITING" "|" "DONE" "CANCELED")))
(setq org-todo-keyword-faces
  '(("DOING" . "yellow")
    ("WAITING" . "yellow")))

; Setup Company
(add-hook 'after-init-hook 'global-company-mode)
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)
(company-quickhelp-mode)

; Company Jedi
(jedi:install-server)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(add-hook 'company-mode-hook
  (lambda ()
    (local-set-key [C-tab] #'company-complete)))

; Enabling elpy
(elpy-enable)
(setq elpy-rpc-backend "jedi")
(setq elpy-rpc-python-command "python3")
(pyvenv-activate "/srv/virtualenv/development")

; Python sphinx autodoc
(add-hook 'python-mode-hook
  (lambda ()
     (require 'sphinx-doc)
     (sphinx-doc-mode t)))

; realgud 
(load-library "realgud")
(setq realgud-safe-mode nil)

;
; Show preview of files in buffer list on other window.
;
(defun show-next (arg)
  "Show next line's buffer in another window."
  (interactive "p")
  (next-line arg)
  (Buffer-menu-switch-other-window))

(defun show-previous (arg)
  "Show previous line's buffer in another window."
  (interactive "p")
  (previous-line arg)
  (Buffer-menu-switch-other-window))

(define-key Buffer-menu-mode-map (kbd "<down>") 'show-next)
(define-key Buffer-menu-mode-map (kbd "<up>") 'show-previous)
