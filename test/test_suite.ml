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

let test_storage_clear wrapper =
    Lwt.async @@ fun () ->
        let item = ["x", Ojs.int_to_js 42]
        and expected = [] in
        let%lwt () = Storage_lwt.Local.set item
        and () = Storage_lwt.Local.clear ()
        and actual = Storage_lwt.Local.get_all ()
        in
        wrapper (fun () -> assert_equal actual expected);
        Lwt.return ()

let test_storage_set_and_get wrapper =
    Lwt.async @@ fun () ->
        let expected = ["x", Ojs.int_to_js 42] in
        let%lwt () = Storage_lwt.Local.set expected
        and actual = Storage_lwt.Local.get_key "x"
        in
        wrapper (fun () -> assert_equal actual expected);
        Lwt.return ()

let test_storage_get_with_defaults wrapper =
    Lwt.async @@ fun () ->
        let%lwt () = Storage_lwt.Local.clear ()
        and () = Storage_lwt.Local.set ["x", Ojs.int_to_js 42]
        and actual =
            Storage_lwt.Local.get_with_defaults
                [ "x", Ojs.int_to_js 1
                ; "y", Ojs.int_to_js 2
                ]
        in
        let expected = ["x", Ojs.int_to_js 42; "y", Ojs.int_to_js 2]
        and actual_sorted =
            actual
            |> List.sort (fun i1 i2 -> String.compare (fst i1) (fst i2))
        in
        wrapper (fun () -> assert_equal actual_sorted expected);
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
        "test_storage_clear" >:~ test_storage_clear;
        "test_storage_set_and_get" >:~ test_storage_set_and_get;
        "test_storage_get_with_defaults" >:~ test_storage_get_with_defaults;
    ]
