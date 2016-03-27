
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory r.
;; c-h f:looking for current cursor word 's help

;(package-initialize)
;添加外部packages源
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  )

(require 'cl)

(defvar tracyone/packages '(
                            company
                            monokai-theme
			    hungry-delete
                            ) "Default packages" )

(defun tracyone/packages-installed-p ()
  (loop for pkg in tracyone/packages
        when (not (package-installed-p pkg)) do ( return nil)
        finally (return t )))

(unless (tracyone/packages-installed-p)
  (message "%s" "Refreshing package dadabase ... ")
  (package-refresh-contents)
  (dolist (pkg tracyone/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode t)
(electric-indent-mode t)
(setq inhibit-splash-screen t)

(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "<f2>") 'open-my-init-file)

(global-company-mode t)

;; 细条状的光标
(setq-default cursor-type 'bar)
 (setq make-backup-files nil)


;;支持最近文件
(require 'recentf)
(recentf-mode 1)
;; 用Ctrl-x Ctrl-r打开最近文件
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; 全屏

(setq initial-frame-alist (quote ((fullscreen . maximized))))

;; highlight match

(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

(delete-selection-mode t)

;;高亮显示当前行
(global-hl-line-mode t)
(load-theme 'monokai t)

(require 'hungry-delete)
(global-hungry-delete-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (hungry-delete monokai-theme company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
