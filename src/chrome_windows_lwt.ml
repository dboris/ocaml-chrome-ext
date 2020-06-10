open Lwt.Infix
open Core_types

let create ?options () : Window.t Lwt.t =
    wrap_callback (Chrome_windows.create ?options)

let remove id : unit Lwt.t =
    wrap_callback (Chrome_windows.remove id)
    >|= ignore
