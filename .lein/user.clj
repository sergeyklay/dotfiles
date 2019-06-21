;; Include clojure 1.3.0 libraries for GNU Emacs clojure-jack-in
(if (>= (.compareTo (clojure-version) "1.3.0") 0)
  (do (use 'clojure.repl)
      (use 'clojure.java.javadoc)
      (use 'clojure.reflect)))
