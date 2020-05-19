open Chrome_ext

let message_handler msg Runtime.{url; _} =
    url |> Option.iter (Printf.printf "Received message from %s\n");
    Lwt.return
        (msg |> Option.map
            (fun msg -> Ojs.string_to_js (String.uppercase_ascii (Ojs.string_of_js msg))))

let () =
    Runtime_lwt.Message_event.add_listener message_handler;
    Lwt.async (fun () ->
        let msg = Message.Test_suite_to_background.(t_to_js Init) in
        let%lwt _ = Runtime_lwt.send_message msg () in
        Lwt.return ());
    print_endline "content script was run"