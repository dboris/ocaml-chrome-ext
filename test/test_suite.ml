open Webtest.Suite
open Js_of_ocaml

open Chrome_ext

let test_get_url () =
    let actual = Runtime.get_url "test_runner.html" |> Js.string in
    let expected_re = new%js Js.regExp (Js.string "chrome-extension://\\w+/test_runner\\.html") in
    assert_true (expected_re##test actual |> Js.to_bool)

let test_fail () =
    assert_true false

let suite =
    "runtime" >::: [
        "test_get_url" >:: test_get_url;
        (* "test_fail" >:: test_fail; *)
    ]