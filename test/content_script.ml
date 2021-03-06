open Chrome_ext

let message_handler msg Runtime.{url; _} =
    url |> Option.iter (Printf.printf "Received message from %s\n");
    let result =
        Ojs.string_to_js (String.uppercase_ascii (Ojs.string_of_js msg)) in
    Lwt.return result

let () =
    Runtime_lwt.Message_event.add_listener message_handler;
    let msg = Message.Test_suite_to_background.(t_to_js Init) in
    let port =
        Runtime.connect ~options:(Runtime.connect_opts ~name:"cs" ()) () in
    port.postMessage msg;
    Lwt.async (fun () ->
        let%lwt _ = Runtime_lwt.send_message msg () in
        Lwt.return ());
    print_endline "content script was run"