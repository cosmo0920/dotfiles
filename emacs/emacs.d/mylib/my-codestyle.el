(provide 'my-codestyle)
;;(require 'cc-mode)
;;for c
;; タブ長の設定
(make-variable-buffer-local 'tab-width)
;;; C-mode,C++-modeの設定
(defconst my-c-style
  '(
    ;; 基本オフセット量の設定
    (c-basic-offset             . 2)
    ;; tab キーでインデントを実行
    (c-tab-always-indent        . t)
    ;; コメント行のオフセット量の設定
    (c-comment-only-line-offset . 0)
    ;; カッコ前後の自動改行処理の設定
    (c-hanging-braces-alist
     . (
        (class-open after)              ; クラス宣言の'{'の後
        (class-close nil)               ; クラス宣言の'}'の後
        (defun-open before after)       ; 関数宣言の'{'の前後
        (defun-close after)             ; 関数宣言の'}'の後
        (inline-open after)             ; クラス内のインライン
                                        ; 関数宣言の'{'の後
        (inline-close after)            ; クラス内のインライン
                                        ; 関数宣言の'}'の後
        (brace-if-brace after)          ; ifの'{'の後
        (brace-else-brace after)        ; else'{'の後
        (brace-elseif-brace after)      ; else if'{'の後
        (brace-list-close after)        ; 列挙型、配列宣言の'}'の後
        (block-open before)             ; ステートメントの'{'の後
        (block-close before)            ; ステートメントの'}'前後
        (substatement-open after)       ; サブステートメント
                                        ; (if 文等)の'{'の後
        (statement-case-open after)     ; case 文の'{'の後
        (extern-lang-open after)        ; 他言語へのリンケージ宣言の
                                        ; '{'の前後
        (extern-lang-close before)      ; 他言語へのリンケージ宣言の
                                        ; '}'の前
        ))
    ;; コロン前後の自動改行処理の設定
    (c-hanging-colons-alist
     . (
        (case-label after)              ; case ラベルの':'の後
        (label after)                   ; ラベルの':'の後
        (access-label after)            ; アクセスラベル(public等)の':'の後
        (member-init-intro)             ; コンストラクタでのメンバー初期化
                                        ; リストの先頭の':'では改行しない
        (inher-intro before)            ; クラス宣言での継承リストの先頭の
                                        ; ':'では改行しない
        ))
    ;; 挿入された余計な空白文字のキャンセル条件の設定
    ;; 下記の*を削除する
    (c-cleanup-list
     . (
	brace-else-brace                ; else の直前
                                        ; "} * else {"  ->  "} else {"
        brace-elseif-brace              ; else if の直前
                                        ; "} * else if (.*) {"
                                        ; ->  } "else if (.*) {"
        empty-defun-braces              ; 空のクラス・関数定義の'}' の直前
                                        ;；"{ * }"  ->  "{}"
        defun-close-semi                ; クラス・関数定義後の';' の直前
                                        ; "} * ;"  ->  "};"
        list-close-comma                ; 配列初期化時の'},'の直前
                                        ; "} * ,"  ->  "},"
        scope-operator                  ; スコープ演算子'::' の間
                                        ; ": * :"  ->  "::"
        ))
    ;; オフセット量の設定
    ;; 必要部分のみ抜粋(他の設定に付いては info 参照)
    ;; オフセット量は下記で指定
    ;; +  c-basic-offsetの 1倍, ++ c-basic-offsetの 2倍
    ;; -  c-basic-offsetの-1倍, -- c-basic-offsetの-2倍
    (c-offsets-alist
     . (
        (arglist-intro          . ++)   ; 引数リストの開始行
        (arglist-close          . c-lineup-arglist) ; 引数リストの終了行
        (substatement-open      . ++)    ; サブステートメントの開始行
        (statement-cont         . ++)   ; ステートメントの継続行
        (case-label             . 0)    ; case 文のラベル行
        (label                  . 0)    ; ラベル行
        (block-open             . 0)    ; ブロックの開始行
	(member-init-intro      . ++)   ; メンバオブジェクトの初期化リスト
	(defun-block-intro      . +)    ; ブロックで字下げ
        ))
    ;; インデント時に構文解析情報を表示する
    (c-echo-syntactic-information-p . t)
    )
  "My C Programming Style")

(add-hook 'c-mode-common-hook
          '(lambda () (setq indent-tabs-mode nil)))
;; hook 用の関数の定義
(defun my-c-mode-common-hook ()
  ;; my-c-style を登録して有効にする
  (c-add-style "My C Programming Style" my-c-style t)

  ;; 次のスタイルがデフォルトで用意されているので選択してもよい
  ;; (c-set-style "gnu")
  ;; (c-set-style "k&r")
  ;; (c-set-style "bsd")
  ;; (c-set-style "linux")
  ;; (c-set-style "cc-mode")
  ;; (c-set-style "stroustrup")
  ;; (c-set-style "ellemtel")
  ;; (c-set-style "whitesmith")
  ;; (c-set-style "python")

  ;; 既存のスタイルを変更する場合は次のようにする
  ;; (c-set-offset 'member-init-intro '++)

  ;; auto-fill-mode を有効にする
  (auto-fill-mode t)
  (setq tab-width 4)
  ;; タブの代わりにスペースを使う
  (setq indent-tabs-mode nil)
  ;; 自動改行(auto-newline)を有効にする
  (setq c-auto-newline 1)
  ;; 最後に改行を入れる。
  (setq require-final-newline t)
  ;; 連続する空白の一括削除(hungry-delete)を有効にする
  (c-toggle-auto-hungry-state 1)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;参考：http://d.hatena.ne.jp/syohex/20110119/1295450495
  ;; for whitespace-mode
  (require 'whitespace)
  ;; see whitespace.el for more details
  (setq whitespace-style '(face tabs tab-mark spaces space-mark))
  (setq whitespace-display-mappings
    '((space-mark ?\u3000 [?\u25a1])
      ;; WARNING: the mapping below has a problem.
      ;; When a TAB occupies exactly one column, it will display the
      ;; character ?\xBB at that column followed by a TAB which goes to
      ;; the next TAB column.
      ;; If this is a problem for you, please, comment the line below.
      (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-foreground 'whitespace-tab "#20b2aa")
  (set-face-background 'whitespace-tab 'nil)
  (set-face-underline-p  'whitespace-tab t)
  (set-face-foreground 'whitespace-space "#4169e1")
  (set-face-background 'whitespace-space 'nil)
  (set-face-bold-p 'whitespace-space t)
  (global-whitespace-mode 1)
  (global-set-key (kbd "C-x w") 'global-whitespace-mode)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; white space mode setting end
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; セミコロンで自動改行しない
  (setq c-hanging-semi&comma-criteria nil)

  ;; キーバインドの追加
  ;; ------------------
  ;; C-m        改行＋インデント
  ;; C-c c      コンパイルコマンドの起動
  ;; C-h        空白の一括削除
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map "\C-cc" 'compile)
  (define-key c-mode-base-map "\C-h" 'c-electric-backspace)

  ;; コンパイルコマンドの設定
  ;; (setq compile-command "gcc ")
  ;;(setq compile-command "make -k ")
  (setq compile-command "")
  ;; (setq compile-command "gmake -k ")
  (setq compilation-window-height 20)
)

(c-add-style
 "Ruby-GNOME2"
 '("bsd"
   (c-basic-offset . 4)
   (c-offsets-alist
    (case-label . 2)
    (label . 2)
    (statement-case-open . 2)
    (statement-case-intro . 2))))

;;; Ruby用のスタイル
(c-add-style
 "ruby"
 '("bsd"
   (c-basic-offset . 2)
   (knr-argdecl-intro . 2)
   (defun-block-intro . 2)
   ))
;;; Python用のスタイル
(c-add-style
 "python"
 '("python"
   (c-basic-offset . 2)
   (knr-argdecl-intro . 2)
   (defun-block-intro . 2)
   ))
;; モードに入るときに呼び出す hook の設定
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(defun toggle-use-my-code-style-setting ()
  (interactive)
  (cond ((find 'my-c-mode-common-hook c-mode-common-hook)
         (remove-hook 'c-mode-common-hook 'my-c-mode-common-hook))
        (
         (add-hook 'c-mode-common-hook 'my-c-mode-common-hook))))
(defun dont-use-my-code-style-setting ()
  (remove-hook 'c-mode-common-hook 'my-c-mode-common-hook))
;; @ csharp-mode
;;(require 'csharp-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C# mode setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Patterns for finding Microsoft C# compiler error messages:
(require 'compile)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)
;; Patterns for defining blocks to hide/show:
(push '(csharp-mode
  "\\(^\\s *#\\s *region\\b\\)\\|{"
  "\\(^\\s *#\\s *endregion\\b\\)\\|}"
  "/[*/]"
  nil
  hs-c-like-adjust-block-beginning)
  hs-special-modes-alist)
;; C# mode hook
(add-hook 'csharp-mode-hook
          '(lambda()
             (setq comment-column 40)
             (setq c-basic-offset 2)
             (font-lock-add-magic-number)
             ;; オフセットの調整
             (c-set-offset 'substatement-open 0)
             (c-set-offset 'case-label '+)
             (c-set-offset 'arglist-intro '+)
             (c-set-offset 'arglist-close 0)
             (setq indent-tabs-mode t)
             )
          )
;; Java mode hook
(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 4
                                  tab-width 4
                                  indent-tabs-mode t)))
;; js2-mode hook
(add-hook 'js2-mode-hook (lambda ()
                          (setq c-basic-offset 2)
                          (setq js2-basic-offset 2)
                          ;; インデントにスペースを使う
                          (setq indent-tabs-mode nil)))
