open Core_types
open Chrome_tabs

let send_message ~tab_id msg ?options () =
    wrap_callback (send_message ~tab_id msg ?options)

let execute_script ?tab_id options : Ojs.t list Lwt.t =
    wrap_callback (execute_script ?tab_id options)

let query options : Tab.t list Lwt.t =
    wrap_callback (query options)

let create options : Tab.t Lwt.t =
    wrap_callback (create options)

let remove tabs : unit Lwt.t =
    let%lwt _ = wrap_callback (remove tabs) in
    Lwt.return ()

let detect_language ?tab_id () : string Lwt.t =
    wrap_callback (detect_language ?tab_id)

let update tab_id options : Tab.t Lwt.t =
    wrap_required_callback (update tab_id options)