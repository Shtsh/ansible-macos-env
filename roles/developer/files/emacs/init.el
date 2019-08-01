;; init.el --- Emacs configuration


;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(ace-jump-mode
    ace-popup-menu
    auto-complete
    better-defaults
    company-tabnine
    elpy
    f
    go-autocomplete
    go-mode
    groovy-mode
    leuven-theme
    move-text
    neotree
    pyenv-mode
    string-inflection
    which-key
    yaml-mode
))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

;; store backup files in /tmp
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backups/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;; line numbers
(setq linum-format "%d ")
(global-linum-mode t) ;; enable line numbers globally

;; misc
(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'leuven t)
(ido-mode t)
(show-paren-mode 1)
(menu-bar-mode -1)

(require 'which-key)
(which-key-mode)

;; whitespace mode
(require 'whitespace)
(whitespace-mode t)

(global-set-key (kbd "\e <up>") 'move-text-up)
(global-set-key (kbd "\e <down>") 'move-text-down)
(global-set-key (kbd "<f8>") 'neotree-toggle) 



;; tabnine
(add-hook 'after-init-hook 'global-company-mode)
(require 'company-tabnine)
(add-to-list 'company-backends #'company-tabnine)
;; Trigger completion immediately.
(setq company-idle-delay 0)
;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-numbers t)

;; Use the tab-and-go frontend.
;; Allows TAB to select and complete at the same time.
(company-tng-configure-default)
(setq company-frontends
      '(company-tng-frontend
        company-pseudo-tooltip-frontend
        company-echo-metadata-frontend))

;;(setq exec-path-from-shell-check-startup-files nil)

;; python
(elpy-enable)

(require 's)
(require 'f)
(require 'pyenv-mode)

(defun pyenv-mode-auto-hook ()
  "Automatically activates pyenv version if .python-version file exists."
  (f-traverse-upwards
   (lambda (path)
     (let ((pyenv-version-path (f-expand ".python-version" path)))
       (if (f-exists? pyenv-version-path)
           (progn
	     (let ((pyenv-full-virtualenv-name (car (s-lines (s-trim (f-read-text pyenv-version-path 'utf-8))))))
	       (pyenv-mode-set pyenv-full-virtualenv-name)
	       ;; workaround for daemon-mode
	       ;; manual activation of virtualenv for elpy as it does't work by default
	       (pyvenv-activate (pyenv-mode-full-path pyenv-full-virtualenv-name)))
             t))))))

(add-hook 'find-file-hook 'pyenv-mode-auto-hook)

(defun python-install-dependencies ()
  "Install python requirements to the current virtualenv."
  (interactive)
  (unless pyvenv-virtual-env
    (error "Error: no virtualenv is active"))
  (let ((dest "*elpy-install-requirements-output*")
        (install-cmd (format "%s/bin/pip install -U '%%s'" pyvenv-virtual-env))
        (deps '("pip" "elpy" "jedi" "pyflakes" "autopep8" "flake8" "importmagic" "yapf" "black" "rope"))
	(subprocess-id "install-python-requirements"))
    (generate-new-buffer dest)
    (mapcar
     #'(lambda (pkg)
	 (let ((python-requirements-install-cmd (format install-cmd pkg)))
	   (message python-requirements-install-cmd)
	   (start-process-shell-command subprocess-id dest python-requirements-install-cmd))) deps)
    (f-traverse-upwards
     (lambda (path)
       (let ((python-requirements-file-path (f-expand "requirements.txt" path)))
	 (let ((python-requirements-install-cmd (format "%s/bin/pip install -U -r %s" pyvenv-virtual-env python-requirements-file-path)))
	   (if (f-exists? python-requirements-file-path)
	       (progn
		 (message python-requirements-install-cmd)
		 (start-process-shell-command subprocess-id dest python-requirements-install-cmd)
		 t))))))
  (switch-to-buffer dest))
  (elpy-rpc-restart))



(add-hook 'python-mode-hook (lambda ()
			      (setq company-backends (remove 'company-tabnine company-backends))
			      (add-to-list 'company-backends #'company-tabnine)
			      (local-set-key (kbd "C-c u") 'string-inflection-python-style-cycle)
			      (local-set-key (kbd "C-c d") 'python-install-dependencies)
			      ))


;; go
(when (fboundp 'go-mode)

  (add-hook 'go-mode-hook (lambda ()
    (local-set-key (kbd "C-c C-c") 'gofmt)
    (local-set-key (kbd "\e .") 'godef-jump)

    (require 'exec-path-from-shell)
    (setq exec-path-from-shell-variables '("PATH" "GOPATH"))
    (exec-path-from-shell-initialize)
    
    (setq company-backends (remove 'company-tabnine company-backends))
    (add-to-list 'company-backends #'company-go)
    (add-to-list 'company-backends #'company-tabnine)
  ))

  (add-hook 'before-save-hook 'gofmt-before-save)
  )

;; move between windows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; yaml
(require 'yaml-mode)
    (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))

;; string-inflection
(require 'string-inflection)
(setq string-inflection-skip-backward-when-done t)
(global-set-key (kbd "C-c u") 'string-inflection-all-cycle)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ace-popup-menu-mode t)
 '(custom-safe-themes (quote (default)))
 '(package-selected-packages
   (quote
    (groovy-mode company-go company-tabnine go-mode exec-path-from-shell go-autocomplete yaml-mode undo-tree string-inflection move-text ace-jump-mode neotree ace-popup-menu auto-complete which-key)))
 '(which-key-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((t (:foreground "lightgray")))))
