open Lwt.Infix
open Core_types

let create ?options () : Window.t Lwt.t =
    wrap_callback (Chrome_windows.create ?options)

let remove id : unit Lwt.t =
    wrap_callback (Chrome_windows.remove id)
    >|= ignore

let update id options : Window.t Lwt.t =
    wrap_callback (Chrome_windows.update id options)

let get id ?options () : Window.t Lwt.t =
    wrap_callback (Chrome_windows.get id ?options)
