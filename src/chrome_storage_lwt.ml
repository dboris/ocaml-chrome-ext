open Core_types

module type STORAGE_LWT = sig
    val get_key : string -> Ojs.t option Lwt.t
    val get_keys : string list -> Ojs.t Dict.t Lwt.t
    val get_all : unit -> Ojs.t Dict.t Lwt.t
    val get_with_defaults : Ojs.t Dict.t -> Ojs.t Dict.t Lwt.t
    val set_key : string -> Ojs.t -> unit Lwt.t
    val set_keys : Ojs.t Dict.t -> unit Lwt.t
    val remove_key : string -> unit Lwt.t
    val remove_keys : string list -> unit Lwt.t
    val clear : unit -> unit Lwt.t
end

module type STORAGE = sig
    val get_key : string -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    val get_keys : string list -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    val get_all : callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    val get_with_defaults : Ojs.t Dict.t -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    val set : Ojs.t Dict.t -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    val remove_key : string -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    val remove_keys : string list -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    val clear : ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
end

module Make_lwt_storage (S : STORAGE) : STORAGE_LWT = struct
    let get_key key : Ojs.t option Lwt.t =
        let%lwt result = wrap_required_callback (S.get_key key) in
        Lwt.return (
            if Int.equal (List.length result) 0 then None
            else Some (snd (List.hd result)))

    let get_keys keys : Ojs.t Dict.t Lwt.t =
        wrap_required_callback (S.get_keys keys)

    let get_all () : Ojs.t Dict.t Lwt.t =
        wrap_required_callback (S.get_all)

    let get_with_defaults dict : Ojs.t Dict.t Lwt.t =
        wrap_required_callback (S.get_with_defaults dict)

    let set_key key value : unit Lwt.t =
        let%lwt _ = wrap_callback (S.set [key, value]) in
        Lwt.return ()

    let set_keys keys : unit Lwt.t =
        let%lwt _ = wrap_callback (S.set keys) in
        Lwt.return ()

    let remove_key key : unit Lwt.t =
        let%lwt _ = wrap_callback (S.remove_key key) in
        Lwt.return ()

    let remove_keys keys : unit Lwt.t =
        let%lwt _ = wrap_callback (S.remove_keys keys) in
        Lwt.return ()

    let clear () : unit Lwt.t =
        let%lwt _ = wrap_callback (S.clear) in
        Lwt.return ()
end

module Sync = Make_lwt_storage (Chrome_storage.Sync)
module Local = Make_lwt_storage (Chrome_storage.Local)
