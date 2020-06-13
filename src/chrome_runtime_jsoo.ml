open Js_of_ocaml
open Core_types

class type runtime = object
    method lastError : Js.js_string Js.t Js.Opt.t Js.readonly_prop
    method sendMessage : Js.Unsafe.any -> (Js.Unsafe.any -> unit) -> unit Js.meth
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