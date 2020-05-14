(lang dune 2.5)
(name chrome_ext)
(version 0.1.0)

(generate_opam_files true)
(license MIT)
(authors "Boris D.")
(maintainers "borisd@gmx.com")
(source (github dboris/ocaml-chrome-ext))

(package
  (name chrome_ext)
  (synopsis "OCaml bindings to the browser extensions JavaScript API")
  (description "Partial bindings to the browser extensions JavaScript API implemented via gen_js_api.")
  (depends
    (gen_js_api (>= 1.0.6))
    (js_of_ocaml-lwt (> 3.5.0))))