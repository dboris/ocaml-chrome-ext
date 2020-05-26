open Core_types

module type T = sig
    val get_key : Chrome_storage.key -> Ojs.t option Lwt.t
    val get_keys : Chrome_storage.key list -> Ojs.t Dict.t Lwt.t
    val get_all : unit -> Ojs.t Dict.t Lwt.t
    val get_with_defaults : Ojs.t Dict.t -> Ojs.t Dict.t Lwt.t
    val set_key : string -> Ojs.t -> unit Lwt.t
    val set_keys : Ojs.t Dict.t -> unit Lwt.t
    val remove_key : Chrome_storage.key -> unit Lwt.t
    val remove_keys : Chrome_storage.key list -> unit Lwt.t
    val clear : unit -> unit Lwt.t
end

module Local : T
module Sync : T