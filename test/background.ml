open Chrome_ext

type message_sender =
  | Test_suite_code
  | Browser_action_popup
  | Tab of string
  | Other

let popup_url = Runtime.get_url "browser_action_popup.html"
let background_url = Runtime.get_url "" ^ "_generated_background_page.html"

let message_url_to_sender =
    Option.fold
        ~none:Other
        ~some:(fun url ->
            if String.equal url popup_url then Browser_action_popup
            else if String.equal url background_url then Test_suite_code
            else Tab url)

let handle_test_suite_message msg =
    let open Message.Test_suite_to_background in
    match t_of_js msg with
    | Increment n -> Lwt.return (increment_result (n + 1))

let handle_message msg Runtime.{url; _} =
    match message_url_to_sender url with
    | Test_suite_code -> handle_test_suite_message msg
    | _ -> failwith "TODO"

let run_tests () =
    Webtest_js.Runner.run ~with_colors:true Test_suite.suite

let on_installed_listener Runtime.{reason; _} =
    match reason with
    | Install | Update -> run_tests ()
    | _ -> ()

let () =
    Runtime_lwt.Message_event.add_listener handle_message;
    Runtime.on_installed.add_listener on_installed_listener
