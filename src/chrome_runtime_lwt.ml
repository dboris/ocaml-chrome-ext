open Core_types
open Chrome_runtime

let send_message ?extension_id msg ?options () =
    wrap_callback (send_message ?extension_id msg ?options)

let send_message' ?extension_id (msg : < of_js : Ojs.t -> 'a; to_js : Ojs.t >) ?options () : 'a Lwt.t =
    send_message ?extension_id msg#to_js ?options ()
    |> Lwt.map msg#of_js

module Message_event = struct
    let add_listener handler =
        on_message.add_listener @@ fun msg sender send_response ->
            let p = handler msg sender in
            let resolve () =
                Lwt.on_any p send_response raise in
            let send_response_async () =
                resolve ();
                Lwt.return () in
            if Lwt.is_sleeping p then begin
                Lwt.async send_response_async;
                `Async_response true
            end
            else begin
                resolve ();
                `Sync_or_no_response
            end
end
