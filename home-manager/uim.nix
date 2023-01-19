{ config, pkgs, ... }:
{

  i18n.inputMethod = {
    enabled = "uim";
    uim.toolbar = "gtk-systray";
  };

  home.file.".uim.d/customs/custom-anthy-keys2.scm".text = ''
    (define anthy-on-key '("hangul"))
    (define anthy-on-key? (make-key-predicate '("hangul")))
    (define anthy-off-key '("hangul"))
    (define anthy-off-key? (make-key-predicate '("hangul")))
    (define anthy-begin-conv-key '(generic-begin-conv-key))
    (define anthy-begin-conv-key? (make-key-predicate '(generic-begin-conv-key?)))
    (define anthy-commit-key '(generic-commit-key))
    (define anthy-commit-key? (make-key-predicate '(generic-commit-key?)))
    (define anthy-cancel-key '(generic-cancel-key))
    (define anthy-cancel-key? (make-key-predicate '(generic-cancel-key?)))
    (define anthy-next-candidate-key '(generic-next-candidate-key))
    (define anthy-next-candidate-key? (make-key-predicate '(generic-next-candidate-key?)))
    (define anthy-prev-candidate-key '(generic-prev-candidate-key))
    (define anthy-prev-candidate-key? (make-key-predicate '(generic-prev-candidate-key?)))
    (define anthy-next-page-key '(generic-next-page-key))
    (define anthy-next-page-key? (make-key-predicate '(generic-next-page-key?)))
    (define anthy-prev-page-key '(generic-prev-page-key))
    (define anthy-prev-page-key? (make-key-predicate '(generic-prev-page-key?)))
  '';

  home.file.".uim.d/customs/custom-byeoru.scm".text = ''
    (define byeoru-layout 'byeoru-layout-hangul2)
    (define byeoru-jamo-orderedness 'ordered)
    (define byeoru-esc-turns-off? #t)
    (define byeoru-commit-by-word? #f)
    (define byeoru-shifted-romaja-isolates-vowel? #f)
    (define byeoru-nr-candidate-max 10)
    (define byeoru-symbol-cache-size 5)
    (define byeoru-conversion-history-size 1000)
    (define byeoru-conversion-history-path "/home/haemin/.uim.d/byeoru/byeoru-history")
    (define byeoru-personal-dict-path "/home/haemin/.uim.d/byeoru/byeoru-dict")
    (define byeoru-sys-dict-path "/nix/store/5nz54nqh4xwfd950q0jrsrjqb7i37n50-uim-1.8.8/share/uim/byeoru-data/byeoru-dict")
    (define byeoru-refresh-xkb-map-at-switch-on? #f)
    (define byeoru-compatibility-jamos-for-incomplete-syllables? #t)
  '';

  home.file.".uim.d/customs/custom-global.scm".text = ''
    (define custom-activate-default-im-name? #t)
    (define custom-preserved-default-im-name 'byeoru)
    (define default-im-name 'byeoru)
    (define enabled-im-list '(byeoru anthy-utf8 py))
    (define enable-im-switch? #t)
    (define switch-im-key '("<Control>hangul"))
    (define switch-im-key? (make-key-predicate '("<Control>hangul")))
    (define switch-im-skip-direct-im? #t)
    (define enable-im-toggle? #f)
    (define toggle-im-key '("<Meta> "))
    (define toggle-im-key? (make-key-predicate '("<Meta> ")))
    (define toggle-im-alt-im 'direct)
    (define uim-color 'uim-color-uim)
    (define candidate-window-style 'vertical)
    (define candidate-window-position 'caret)
    (define enable-lazy-loading? #t)
    (define bridge-show-input-state? #f)
    (define bridge-show-with? 'time)
    (define bridge-show-input-state-time-length 3)
  '';
}
