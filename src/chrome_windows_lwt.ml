open Core_types
open Lwt.Infix

let create options : Window.t Lwt.t =
    wrap_callback (Chrome_windows.create options)

let remove tabs : unit Lwt.t =
    wrap_callback (Chrome_windows.remove tabs)
    >|= ignore
