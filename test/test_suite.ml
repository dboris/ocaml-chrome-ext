open Webtest.Suite
open Js_of_ocaml

open Chrome_ext

let test_get_url () =
    let actual = Runtime.get_url "test_runner.html" |> Js.string in
    let expected_re = new%js Js.regExp (Js.string "chrome-extension://\\w+/test_runner\\.html") in
    assert_true (expected_re##test actual |> Js.to_bool)

let test_fail () =
    assert_true false

let test_send_message_and_message_listener wrapper =
    let n = 5
    and expected = 6 in
    Lwt.async @@ fun () ->
        let%lwt actual = Message.Test_suite_to_background.increment n in
        wrapper (fun () -> assert_equal actual expected);
        Lwt.return ()

let test_create_tab wrapper =
    Lwt.async @@ fun () ->
        let url = "https://developer.mozilla.org/fr/docs/Mozilla/Add-ons/WebExtensions/API" in
        let%lwt tab = Tabs_lwt.create (Tabs.create_opts ~url ()) in
        wrapper (fun () -> assert_true (tab.index > 0));
        Lwt.return ()

let suite =
    "runtime" >::: [
        "test_get_url" >:: test_get_url;
        (* "test_fail" >:: test_fail; *)
        "test_send_message_and_message_listener" >:~ test_send_message_and_message_listener;
    ]

let background_suite =
    "runtime" >::: [
        "test_get_url" >:: test_get_url;
        "test_create_tab" >:~ test_create_tab;
    ]
