open Webtest.Suite
open Js_of_ocaml
open Chrome_ext

let test_get_url () =
    let url = Runtime.get_url "test_runner.html" in
    let expected_re = new%js Js.regExp (Js.string "chrome-extension://\\w+/test_runner.html") in
    assert_true (expected_re##test (Js.string url) |> Js.to_bool)

let suite =
    "runtime" >::: [
        "test_get_url" >:: test_get_url;
    ]

let () = Webtest_js.Runner.setup suite