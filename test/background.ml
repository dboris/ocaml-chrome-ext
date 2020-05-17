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

let handle_message msg Runtime.{url; origin; _} =
    match sender_of_message_url url with
    | Browser_action_popup
    | Tab_or_frame _ ->
        handle_test_suite_message msg
    | _ ->
        Printf.printf "Unhandled message %s from: %s (%s)\n"
            (JSON.stringify msg) (Option.get url) (Option.get origin);
        Lwt.return Ojs.null

let run_tests () =
    Lwt.async (fun () ->
        let%lwt _ = Tabs_lwt.create (Tabs.create_opts ~url:(Runtime.get_url "test_runner.html") ()) in
        Lwt.return ());
    Webtest_js.Runner.run ~with_colors:true Test_suite.background_suite

let on_installed_listener Runtime.{reason; _} =
    match reason with
    | Install | Update -> run_tests ()
    | _ -> ()

let () =
    Runtime_lwt.Message_event.add_listener handle_message;
    Runtime.on_installed.add_listener on_installed_listener;
    print_endline "Running tests...";
    Lwt.async @@ fun () ->
        let%lwt () = Lwt_js.sleep 3.
        and lang = Tabs_lwt.detect_language ()
        in
        Printf.printf "Detected language: %s\n" lang;
        Lwt.return ()
