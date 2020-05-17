open Core_types
open Chrome_storage

module Sync = struct
    let get_key key : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Sync.get_key key)

    let get_keys keys : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Sync.get_keys keys)

    let get_all () : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Sync.get_all)

    let get_with_defaults dict : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Sync.get_with_defaults dict)

    let set keys : unit Lwt.t =
        let%lwt _ = wrap_callback (Sync.set keys) in
        Lwt.return ()

    let remove_key key : unit Lwt.t =
        let%lwt _ = wrap_callback (Sync.remove_key key) in
        Lwt.return ()

    let remove_keys keys : unit Lwt.t =
        let%lwt _ = wrap_callback (Sync.remove_keys keys) in
        Lwt.return ()

    let clear () : unit Lwt.t =
        let%lwt _ = wrap_callback (Sync.clear) in
        Lwt.return ()
end

module Local = struct
    let get_key key : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Local.get_key key)

    let get_keys keys : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Local.get_keys keys)

    let get_all () : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Local.get_all)

    let get_with_defaults dict : Ojs.t Dict.t Lwt.t =
        wrap_callback' (Local.get_with_defaults dict)

    let set keys : unit Lwt.t =
        let%lwt _ = wrap_callback (Local.set keys) in
        Lwt.return ()

    let remove_key key : unit Lwt.t =
        let%lwt _ = wrap_callback (Local.remove_key key) in
        Lwt.return ()

    let remove_keys keys : unit Lwt.t =
        let%lwt _ = wrap_callback (Local.remove_keys keys) in
        Lwt.return ()

    let clear () : unit Lwt.t =
        let%lwt _ = wrap_callback (Local.clear) in
        Lwt.return ()
end