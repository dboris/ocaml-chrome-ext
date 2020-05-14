open Core_types
open Chrome_runtime

let wrap_callback f =
    let (p, r) = Lwt.wait () in
    let callback response =
        let last_error = get_last_error () in
        if Option.is_some last_error then
            let error_message =
                last_error
                |> Option.get
                |> (fun {message} -> message |> Option.value ~default:"No message was provided")
            in
            Lwt.wakeup_exn r (Chrome_runtime_error error_message)
        else
            match response with
            | `Arg v -> Lwt.wakeup r v
            | `No_arg_or_error -> Lwt.wakeup r Ojs.null
    in
    let () = f ?callback:(Some callback) () in
    p

let send_message ?extension_id msg ?options () =
    wrap_callback (send_message ?extension_id msg ?options)

module Message_event = struct
    let add_listener handler =
        on_message.add_listener (fun msg sender send_response ->
            let p = handler msg sender in
            let resolve () = Lwt.on_any p send_response raise in
            let send_response_async () = resolve (); Lwt.return () in
            if Lwt.is_sleeping p then begin
                Lwt.async send_response_async;
                `Async_response true
            end
            else begin
                resolve ();
                `Sync_or_no_response
            end)
end
