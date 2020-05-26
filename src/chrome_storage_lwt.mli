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

module Local : STORAGE_LWT
module Sync : STORAGE_LWT