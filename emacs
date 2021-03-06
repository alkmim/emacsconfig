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
(package-install 'tabbar)
(package-install 'exwm)
(package-install 'org-super-agenda)
(package-install 'origami)
(package-install 'use-package)
; Required by origami integration with org-super-agenda. See https://github.com/alphapapa/org-super-agenda/issues/55#issuecomment-476685245
(package-install 'general)


; Adding a menu bar in case exwm fails to load.
; After this file is loaded, we remove the menu bar.
(menu-bar-mode 1)

; EXWM Setup
(require 'exwm)
(require 'exwm-config)
(require 'exwm-randr)

(setq exwm-workspace-number 2)
(setq exwm-randr-workspace-output-plist '(1 "HDMI-0"
					  0 "DP-0"  ))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output HDMI-0 --right-of DP-0")))
(exwm-randr-enable)

(add-hook 'exwm-update-title-hook
	  (lambda ()
	    (exwm-workspace-rename-buffer (concat (substring exwm-class-name 0 5) " - " exwm-title))))

(setq exwm-manage-configurations '((t char-mode t)))

(setq exwm-input-global-keys
      `((,(kbd "s-r") . exwm-reset)
        (,(kbd "s-s") . ibuffer)
        (,(kbd "s-<SPC>") . helm-buffers-list)
        (,(kbd "s-m") . magit-status)
        (,(kbd "s-=") . list-bookmarks)
        (,(kbd "s-+") . (lambda ()
		     (interactive)
		     (bookmark-set)
		     (bookmark-save)))
        (,(kbd "s-f") . helm-find-files)
        (,(kbd "s-o") . other-window)
        (,(kbd "s--") . delete-window)
        (,(kbd "s-<right>") . windmove-right)
        (,(kbd "s-<left>") . windmove-left)
        (,(kbd "s-<up>") . windmove-up)
        (,(kbd "s-<down>") . windmove-down)
        (,(kbd "s-<kp-subtract>") . split-window-vertically)
        (,(kbd "s-<kp-add>") . split-window-horizontally)
        (,(kbd "s-k") . kill-buffer)
        (,(kbd "s-a") . multi-term)
        (,(kbd "s-z") . exwm-input-toggle-keyboard)
        (,(kbd "s-e") . eshell)
        (,(kbd "s-h") . help-for-help)
        (,(kbd "s-q") . (lambda ()
		     (interactive)
		     (switch-to-buffer "*scratch*")))
        (,(kbd "s-x") . (lambda ()
		     (interactive)
		     (setq TouchpadOff (shell-command-to-string "synclient -l | grep TouchpadOff | awk '{ print $3 }'"))
		     (if (string= TouchpadOff "1\n") (shell-command "synclient TouchpadOff=0") (shell-command "synclient TouchpadOff=1"))))
        (,(kbd "s-c") . (lambda (command)
		     (interactive (list (read-shell-command "$ ")))
		     (start-process-shell-command command nil command)))
        (,(kbd "s-l") . (lambda ()
		     (interactive)
		     (start-process-shell-command "xscreensaver" nil "xscreensaver-command -lock")))
        (,(kbd "s-p") . (lambda ()
		     (interactive)
		     (start-process-shell-command "pycharm" nil "~/opt/pycharm/bin/pycharm.sh")))
        (,(kbd "s-w") . (lambda ()
		     (interactive)
		     (start-process-shell-command "firefox" nil "firefox")))	
        (,(kbd "s-0") . exwm-workspace-switch)
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,(- i 1)))))
                  (number-sequence 1 9))))

(exwm-enable)

; Set up global hacks
(tool-bar-mode -1)
(global-set-key (kbd "C-x C-c") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x C-b") 'buffer-menu-other-window)
(setq linum-format "%4d \u2502 ")
(global-linum-mode 1)
(setq column-number-mode t)
(load-theme 'material t)
(set-face-attribute 'default nil :height 90) ; The value is in 1/10pt (90 = 9pt)
(setq-default fill-column 80)
(setq browse-url-generic-program "firefox")
(windmove-default-keybindings) ; Set moving with shift
(setq scroll-preserve-screen-position 1)

; Setup ibuffer
(global-set-key (kbd "C-x b") 'ibuffer)
(setq ibuffer-saved-filter-groups
  (quote (("default"
    ("EXWM" (mode . exwm-mode))
    ("org-mode" (mode . org-mode))
    ("git" (mode . magit-status-mode))
    ("dired" (mode . dired-mode))
    ("emacs" (or
              (name . "^\\*scratch\\*$")
              (name . "^\\*Messages\\*$")
	      (name . "^\\*Bookmark List\\*$")
	      (name . "^\\*GNU Emacs\\*$")))
    ("helm" (mode . helm-major-mode))))))

(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (ibuffer-switch-to-saved-filter-groups "default")))


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
(setq helm-exit-idle-delay 0) ; solve Display not Ready issue - https://github.com/emacs-helm/helm/issues/550
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
(run-with-timer 0 (* 30 60) 'recentf-save-list)

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
    (define-key org-mode-map (kbd "<C-t>") 'org-todo)
    (linum-mode -1)))

(setq org-agenda-files (list "~/Documents/orgmode/"))

; Org-Mode Todo's
(setq org-todo-keywords
      '((sequence "TODO" "BLOCKED" "DOING" "WAITING" "|" "DONE" "CANCELED")))
(setq org-todo-keyword-faces
  '(("DOING" . "yellow")
    ("WAITING" . "yellow")))

(setq org-agenda-time-grid
      (quote
       ((daily today remove-match)
        ()
        "......" "----------------")))

(setq org-agenda-log-mode-items '(closed clock state))
(setq org-deadline-warning-days 60)

(org-super-agenda-mode t)
(require 'use-package)
(require 'general)
(use-package origami
   :general (:keymaps 'org-super-agenda-header-map
                      "TAB" #'origami-toggle-node)
   :config
   :hook ((org-agenda-mode . origami-mode))
)

; See https://github.com/alphapapa/org-super-agenda for documentation
(setq org-super-agenda-groups '(
  (:name "Done"
   :todo "DONE"
   :todo "CANCELLED")
  (:name "Overdue"
   :deadline past)
  (:name "Due today"
   :deadline today)
  (:name "Due soon"
   :deadline future)
  (:auto-group t)
  (:name "Waiting"
   :todo "WAITING")
  (:name "Urgent"
   :priority "A")
  (:name "Important"
   :priority "B")
  (:name "Wanto to do"
   :priority "C")
  (:auto-category t)
))

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

; Multi-term
(require 'multi-term)
(add-to-list 'term-bind-key-alist '("C-<right>" . term-send-forward-word))
(add-to-list 'term-bind-key-alist '("C-<left>" . term-send-backward-word))
(add-to-list 'term-bind-key-alist '("C-c C-j" . term-line-mode)) 
(add-hook 'term-mode-hook
  (lambda ()
    (setq term-buffer-maximum-size 10000000)
    (linum-mode -1)))

; Tabbar
(require 'tabbar)
(global-set-key [M-left] 'tabbar-backward-tab)
(global-set-key [M-right] 'tabbar-forward-tab)

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

; If everything goes fine, remove the menu bar.
(menu-bar-mode -1)
