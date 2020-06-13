open Lwt.Infix
open Core_types

let send_message ~tab_id msg ?options () : Ojs.t Lwt.t =
    wrap_callback (Chrome_tabs.send_message ~tab_id msg ?options)

let execute_script ?tab_id options : Ojs.t list Lwt.t =
    wrap_callback (Chrome_tabs.execute_script ?tab_id options)

let insert_css ?tab_id options : unit Lwt.t =
    wrap_callback (Chrome_tabs.insert_css ?tab_id options)
    >|= ignore

let query options : Tab.t list Lwt.t =
    wrap_callback (Chrome_tabs.query options)

let create options : Tab.t Lwt.t =
    wrap_callback (Chrome_tabs.create options)

let remove tabs : unit Lwt.t =
    wrap_callback (Chrome_tabs.remove tabs)
    >|= ignore

let reload ?tab_id ?options () : unit Lwt.t =
    wrap_callback (Chrome_tabs.reload ?tab_id ?options)
    >|= ignore

let detect_language ?tab_id () : string Lwt.t =
    wrap_callback (Chrome_tabs.detect_language ?tab_id)

let update tab_id options : Tab.t Lwt.t =
    wrap_callback (Chrome_tabs.update tab_id options)