(lang dune 2.5)
(name chrome_ext)
(version 0.1.0)

(generate_opam_files true)
(authors "Boris D.")
(maintainers "borisd@gmx.com")
(source (github dboris/ocaml-chrome-ext))
(license MIT)

(package
  (name chrome_ext)
  (synopsis "Chrome browser extensions API bindings")
  (description "Partial bindings to the Chrome browser extensions JavaScript API implemented via gen_js_api.")
  (depends
    (js_of_ocaml (> 3.4.0))
    (js_of_ocaml-lwt (> 3.4.0))
    (js_of_ocaml-ppx (> 3.4.0))
    (gen_js_api (>= 1.0.6))
    (webtest (>= 2.0.0))
    (webtest-js (>= 2.0.0))))