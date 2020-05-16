open Chrome_ext

type message_sender =
  | Browser_action_popup
  | Tab_or_frame of string
  | Other

let popup_url = Runtime.get_url "browser_action_popup.html"
let background_url = Runtime.get_url "" ^ "_generated_background_page.html"

let message_url_to_sender =
    Option.fold
        ~none:Other
        ~some:(fun url ->
            if String.equal url popup_url then Browser_action_popup
            else Tab_or_frame url)

let handle_test_suite_message msg =
    let open Message.Test_suite_to_background in
    match t_of_js msg with
    | Increment n -> Lwt.return (increment_result (n + 1))

let handle_message msg Runtime.{url; origin; _} =
    match message_url_to_sender url with
    | Browser_action_popup | Tab_or_frame _ -> handle_test_suite_message msg
    | _ ->
        Printf.printf "Unhandled message %s from: %s (%s)\n"
            (JSON.stringify msg) (Option.get url) (Option.get origin);
        Lwt.return Ojs.null

let run_tests () =
    Webtest_js.Runner.run ~with_colors:true Test_suite.background_suite

let on_installed_listener Runtime.{reason; _} =
    match reason with
    | Install | Update -> run_tests ()
    | _ -> ()

let () =
    Runtime_lwt.Message_event.add_listener handle_message;
    Runtime.on_installed.add_listener on_installed_listener;
    print_endline "Running tests..."
