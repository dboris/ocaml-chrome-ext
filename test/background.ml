open Printf
open Js_of_ocaml_lwt
open Chrome_ext

type message_sender =
  | Browser_action_popup
  | Tab_or_frame of string
  | Other

let popup_url = Runtime.get_url "browser_action_popup.html"
let background_url = Runtime.get_url "" ^ "_generated_background_page.html"

let sender_of_message_url =
    Option.fold
        ~none:Other
        ~some:(fun url ->
            if String.equal url popup_url then Browser_action_popup
            else Tab_or_frame url)

let handle_test_suite_message msg =
    let open Message.Test_suite_to_background in
    match t_of_js msg with
    | Increment n ->
        Lwt.return (to_increment_result (n + 1))
    | Init ->
        print_endline "Content script sent Init message.";
        Lwt.return Ojs.null

let handle_message msg Runtime.{url; origin; _} =
    match sender_of_message_url url with
    | Browser_action_popup
    | Tab_or_frame _ ->
        handle_test_suite_message msg
    | _ ->
        let default = "unknown" in
        printf "Unhandled message %s from: %s (%s)\n"
            (JSON.stringify msg)
            (Option.value url ~default)
            (Option.value origin  ~default);
        Lwt.return Ojs.null

let run_tests () =
    Lwt.async (fun () ->
        let%lwt _ = Tabs_lwt.create (Tabs.create_opts ~url:(Runtime.get_url "test_runner.html") ()) in
        Lwt.return ());
    Webtest_js.Runner.run ~with_colors:true Test_suite.background_suite

let setup_context_menus () =
    let open Context_menus in
    let onclick _ _ = run_tests () in
    let%lwt mid =
        Context_menus_lwt.create
            (create_opts
                ~id:"Run_tests"
                ~title:"Run tests"
                ~contexts:[All]
                ~onclick
                ())
    in
    (match mid with
    | `Int n -> printf "Menu item id: %d\n" n
    | `String s -> printf "Menu item id: %s\n" s);
    Lwt.return ()

let on_installed_listener Runtime.{reason; _} =
    match reason with
    | Install | Update ->
        run_tests ();
        Lwt.async setup_context_menus
    | _ -> ()

let cs_port_listener msg port =
    Js_of_ocaml.(Firebug.console##log_2 (Js.string "Received on port") msg)

let on_connect_listener (Runtime.Port.{name; _} as port) =
    match name with
    | "cs" ->
        port.onMessage.add_listener cs_port_listener
    | _ -> ()

let () =
    Runtime_lwt.Message_event.add_listener handle_message;
    Runtime.on_installed.add_listener on_installed_listener;
    Runtime.on_connect.add_listener on_connect_listener;
    print_endline "Running tests...";
    Lwt.async @@ fun () ->
        let%lwt () = Lwt_js.sleep 3.
        and lang = Tabs_lwt.detect_language ()
        in
        printf "Detected language: %s\n" lang;
        Lwt.return ()
