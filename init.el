

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
  (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
  )

(require 'cl)

(defvar tracyone/packages '(
                            company
                            monokai-theme
			    hungry-delete
			    smex
			    swiper
			    counsel
			    popwin
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
(setq-default cursor-type 'box)
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

;;Plugin setting
(require 'hungry-delete)
(global-hungry-delete-mode)


(require 'smex)
;;(global-set-key (kbd "M-x") 'smex)

;;smex simlar to ctrlp
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
;;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-minimum-prefix-length 4)
 '(package-selected-packages (quote (smex hungry-delete monokai-theme company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
