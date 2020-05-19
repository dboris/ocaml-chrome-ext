open Js_of_ocaml
open Js_of_ocaml_lwt
open Webtest.Suite

open Chrome_ext

let active_tab_id () =
    let%lwt tabs =
        Tabs_lwt.query (Tabs.query_opts ~active:true ~currentWindow:true ()) in
    if not (Int.equal (List.length tabs) 1) then
        raise (Chrome_runtime_error "Active tab in current window could not be determined");
    let tab_id_of_tab Tab.{id; _} =
        if Option.is_some id then
            Option.get id
        else
            raise (Chrome_runtime_error "ID of active tab in current window could not be determined")
    in
    Lwt.return (tab_id_of_tab (List.hd tabs))

let test_runtime_get_url () =
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

let test_tabs_create wrapper =
    Lwt.async @@ fun () ->
        let url = "https://developer.mozilla.org/fr/docs/Mozilla/Add-ons/WebExtensions/API" in
        let%lwt tab = Tabs_lwt.create (Tabs.create_opts ~url ()) in
        wrapper (fun () -> assert_true (tab.index > 0));
        Lwt.return ()

let test_storage_clear_and_get_all wrapper =
    Lwt.async @@ fun () ->
        let open Storage_lwt.Local in
        let item = ["x", Ojs.int_to_js 42]
        and expected = []
        in
        let%lwt () = set item
        and () = clear ()
        and actual = get_all ()
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
        let x = Ojs.int_to_js 42
        and y = Ojs.string_to_js "hi"
        and compare_keys i1 i2 =
            String.compare (fst i1) (fst i2)
        in
        let%lwt () = Storage_lwt.Local.clear ()
        and () = Storage_lwt.Local.set ["x", x]
        and actual =
            Storage_lwt.Local.get_with_defaults ["x", Ojs.int_to_js 1; "y", y]
        in
        let expected = ["x", x; "y", y]
        and actual_sorted = List.sort compare_keys actual
        in
        wrapper (fun () -> assert_equal actual_sorted expected);
        Lwt.return ()

let test_storage_remove wrapper =
    Lwt.async @@ fun () ->
        let open Storage_lwt.Local in
        let item = ["x", Ojs.int_to_js 42]
        and expected = []
        in
        let%lwt () = clear ()
        and () = set item
        and () = remove_key "x"
        and actual = get_all ()
        in
        wrapper (fun () -> assert_equal actual expected);
        Lwt.return ()

let test_tabs_update wrapper =
    Lwt.async @@ fun () ->
        let%lwt tab_id = active_tab_id () in
        let update_listener tab_id' Tabs.{mutedInfo; _} _tab =
            if Int.equal tab_id' tab_id && Option.is_some mutedInfo then
                let Tab.{muted; _} = Option.get mutedInfo in
                wrapper (fun () -> assert_true muted)
        in
        Tabs.on_updated.add_listener update_listener;
        let%lwt _ = Tabs_lwt.update tab_id (Tabs.update_opts ~muted:true ()) in
        Lwt.return ()

let test_tabs_insert_css wrapper =
    Lwt.async @@ fun () ->
        let code = "h1 {border: 1px solid red !important}" in
        let%lwt () = Tabs_lwt.insert_css (Tabs.insert_css_opts ~code ()) in
        wrapper Async.noop;
        Lwt.return ()

let test_tabs_send_message wrapper =
    Lwt.async @@ fun () ->
        let%lwt tab_id = active_tab_id () in
        let file = "content_script.bc.js"
        and expected = "HOLA" in
        let%lwt _ =
            Tabs_lwt.execute_script
                ~tab_id
                (Tabs.execute_script_opts ~file ~runAt:Tabs.Document_start ())
        in
        let%lwt actual =
            Tabs_lwt.send_message ~tab_id (Ojs.string_to_js "hola") ()
        in
        actual
        |> Option.iter (fun actual ->
            wrapper (fun () -> assert_equal (Ojs.string_of_js actual) expected));
        Lwt.return ()

let suite =
    "content_script" >::: [
        "test_runtime_get_url" >:: test_runtime_get_url;
        (* "test_fail" >:: test_fail; *)
        "test_send_message_and_message_listener" >:~ test_send_message_and_message_listener;
        "test_storage_clear_and_get_all" >:~ test_storage_clear_and_get_all;
        "test_storage_set_and_get" >:~ test_storage_set_and_get;
        "test_storage_get_with_defaults" >:~ test_storage_get_with_defaults;
        "test_storage_remove" >:~ test_storage_remove;
    ]

let background_suite =
    "background" >::: [
        "test_runtime_get_url" >:: test_runtime_get_url;
        "test_tabs_create" >:~ test_tabs_create;
        "test_tabs_update" >:~ test_tabs_update;
        "test_tabs_insert_css" >:~ test_tabs_insert_css;
        "test_tabs_send_message" >:~ test_tabs_send_message;
        "test_storage_clear_and_get_all" >:~ test_storage_clear_and_get_all;
        "test_storage_set_and_get" >:~ test_storage_set_and_get;
        "test_storage_get_with_defaults" >:~ test_storage_get_with_defaults;
        "test_storage_remove" >:~ test_storage_remove;
    ]
