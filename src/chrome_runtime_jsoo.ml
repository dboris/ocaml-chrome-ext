open Js_of_ocaml
open Core_types

class type messageSender = object
    method url : Js.js_string Js.t Js.Opt.t Js.readonly_prop
end

type message_listener =
    (** message -> messageSender -> sendResponse -> asyncResponse? *)
    (Js.Unsafe.any -> messageSender Js.t -> (Js.Unsafe.any -> unit) -> bool Js.t Js.Opt.t) Js.callback

class type messageEvent = object
    method addListener : message_listener -> unit Js.meth
end

class type runtime = object
    method lastError : Js.js_string Js.t Js.Opt.t Js.readonly_prop
    method sendMessage : Js.Unsafe.any -> (Js.Unsafe.any -> unit) -> unit Js.meth
    method onMessage : messageEvent Js.t Js.readonly_prop
end

let runtime : runtime Js.t = (Js.Unsafe.coerce Dom_html.window)##.chrome##.runtime

let send_message msg =
    let (p, r) = Lwt.wait () in
    let callback resp =
        if Js.Opt.test runtime##.lastError then
            let error_message =
                Js.Opt.case runtime##.lastError
                    (fun () -> "no error message")
                    Js.to_string
            in
            Lwt.wakeup_exn r (Chrome_runtime_error error_message)
        else
            Lwt.wakeup r resp
    in
    runtime##sendMessage msg callback;
    p
;;

let add_message_listener handler =
    let message_listener msg sender send_response =
        let p = handler msg sender in
        match Lwt.is_sleeping p with
        | true ->
            Lwt.async (fun () ->
                Lwt.on_any p send_response raise;
                Lwt.return ());
            Js.Opt.return Js._true
        | false ->
            Lwt.on_any p send_response raise;
            Js.Opt.empty
    in
    runtime##.onMessage##addListener (Js.wrap_callback message_listener)
