(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'doom-themes)
  (package-refresh-contents)
  (package-install 'doom-themes))

(use-package base16-theme
  :ensure t)

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

;;;;;

; Map escape to cancel (like C-g)...
;; (define-key isearch-mode-map [escape] 'isearch-abort)   ;; isearch
;; (define-key isearch-mode-map "\e" 'isearch-abort)   ;; \e seems to work better for terminals
;; (global-set-key [escape] 'keyboard-escape-quit)

;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#c9b4cf" "#8abeb7" "#c5c8c6"])
 '(ansi-term-color-vector
   [unspecified "#212121" "#f07178" "#c3e88d" "#ffcb6b" "#82aaff" "#c792ea" "#82aaff" "#eeffff"] t)
 '(custom-enabled-themes (quote (base16-classic-dark)))
 '(custom-safe-themes
   (quote
    ("7bef2d39bac784626f1635bd83693fae091f04ccac6b362e0405abf16a32230c" "304c39b190267e9b863c0cf9c989da76dcfbb0649cbcb89592e7c5c08348fce9" "0961d780bd14561c505986166d167606239af3e2c3117265c9377e9b8204bf96" "b0c5c6cc59d530d3f6fbcfa67801993669ce062dda1435014f74cafac7d86246" "ed4c48eb91d07c2e447b445e2491ef17e9b326d43a60022297fd56af4749e772" "350dc341799fbbb81e59d1e6fff2b2c8772d7000e352a5c070aa4317127eee94" "1f38fb71e55e5ec5f14a39d03ca7d7a416123d3f0847745c7bade053ca58f043" "60e09d2e58343186a59d9ed52a9b13d822a174b33f20bdc1d4abb86e6b17f45b" "732ccca2e9170bcfd4ee5070159923f0c811e52b019106b1fc5eaa043dff4030" "a61109d38200252de49997a49d84045c726fa8d0f4dd637fce0b8affaa5c8620" "a62f0662e6aa7b05d0b4493a8e245ab31492765561b08192df61c9d1c7e1ddee" "8c1dd3d6fdfb2bee6b8f05d13d167f200befe1712d0abfdc47bb6d3b706c3434" "e1498b2416922aa561076edc5c9b0ad7b34d8ff849f335c13364c8f4276904f0" "b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" "25c06a000382b6239999582dfa2b81cc0649f3897b394a75ad5a670329600b45" "cea3ec09c821b7eaf235882e6555c3ffa2fd23de92459751e18f26ad035d2142" "446cc97923e30dec43f10573ac085e384975d8a0c55159464ea6ef001f4a16ba" "d9dab332207600e49400d798ed05f38372ec32132b3f7d2ba697e59088021555" "6daa09c8c2c68de3ff1b83694115231faa7e650fdbb668bc76275f0f2ce2a437" "fee4e306d9070a55dce4d8e9d92d28bd9efe92625d2ba9d4d654fc9cd8113b7f" "aea30125ef2e48831f46695418677b9d676c3babf43959c8e978c0ad672a7329" "b8929cff63ffc759e436b0f0575d15a8ad7658932f4b2c99415f3dde09b32e97" "760ce657e710a77bcf6df51d97e51aae2ee7db1fba21bbad07aab0fa0f42f834" "78c1c89192e172436dbf892bd90562bc89e2cc3811b5f9506226e735a953a9c6" "3380a2766cf0590d50d6366c5a91e976bdc3c413df963a0ab9952314b4577299" "3a3de615f80a0e8706208f0a71bbcc7cc3816988f971b6d237223b6731f91605" "196df8815910c1a3422b5f7c1f45a72edfa851f6a1d672b7b727d9551bb7c7ba" "4feee83c4fbbe8b827650d0f9af4ba7da903a5d117d849a3ccee88262805f40d" "93268bf5365f22c685550a3cbb8c687a1211e827edc76ce7be3c4bd764054bad" "9be1d34d961a40d94ef94d0d08a364c3d27201f3c98c9d38e36f10588469ea57" "36282815a2eaab9ba67d7653cf23b1a4e230e4907c7f110eebf3cdf1445d8370" "a3fa4abaf08cc169b61dea8f6df1bbe4123ec1d2afeb01c17e11fdc31fc66379" "d2e9c7e31e574bf38f4b0fb927aaff20c1e5f92f72001102758005e53d77b8c9" "1c082c9b84449e54af757bcae23617d11f563fc9f33a832a8a2813c4d7dfb652" "356e5cbe0874b444263f3e1f9fffd4ae4c82c1b07fe085ba26e2a6d332db34dd" "7e78a1030293619094ea6ae80a7579a562068087080e01c2b8b503b27900165c" "93a0885d5f46d2aeac12bf6be1754faa7d5e28b27926b8aa812840fe7d0b7983" "75d3dde259ce79660bac8e9e237b55674b910b470f313cdf4b019230d01a982a" "f0dc4ddca147f3c7b1c7397141b888562a48d9888f1595d69572db73be99a024" "151bde695af0b0e69c3846500f58d9a0ca8cb2d447da68d7fbf4154dcf818ebc" "d1b4990bd599f5e2186c3f75769a2c5334063e9e541e37514942c27975700370" "6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" "8aca557e9a17174d8f847fb02870cb2bb67f3b6e808e46c0e54a44e3e18e1020" default)))
 '(fci-rule-color "#5c5e5e")
 '(jdee-db-active-breakpoint-face-colors (cons "#0d0d0d" "#41728e"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d0d0d" "#b5bd68"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d0d0d" "#5a5b5a"))
 '(package-selected-packages
   (quote
    (icomplete-vertical-mode ido-vertical-mode icomplete-vertical rust-mode xresources-theme markdown-mode+ counsel-projectile expand-region yasnippet-snippets erlang ace-window minimap undo-tree evil-magit evil-org counsel ivy org-bullets nlinum-hl doom-modeline evil-commentary evil-surround evil doom-themes which-key use-package)))
 '(vc-annotate-background "#1d1f21")
 '(vc-annotate-color-map
   (list
    (cons 20 "#b5bd68")
    (cons 40 "#c8c06c")
    (cons 60 "#dcc370")
    (cons 80 "#f0c674")
    (cons 100 "#eab56d")
    (cons 120 "#e3a366")
    (cons 140 "#de935f")
    (cons 160 "#d79e84")
    (cons 180 "#d0a9a9")
    (cons 200 "#c9b4cf")
    (cons 220 "#ca9aac")
    (cons 240 "#cb8089")
    (cons 260 "#cc6666")
    (cons 280 "#af6363")
    (cons 300 "#936060")
    (cons 320 "#765d5d")
    (cons 340 "#5c5e5e")
    (cons 360 "#5c5e5e")))
 '(vc-annotate-very-old-color nil)
 '(visual-line-fringe-indicators (quote (nil nil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "JB  " :family "JetBrains Mono")))))
 

