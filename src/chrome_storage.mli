open Core_types

type key = string

module Sync : sig
    val get_key : key -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.sync.get"]

    val get_keys : key list -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.sync.get"]

    val get_all : callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.sync.get"]

    (** A dictionary specifying default values. *)
    val get_with_defaults : Ojs.t Dict.t -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.sync.get"]

    (** Void parameter callback. *)
    val set : Ojs.t Dict.t -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.sync.set"]

    (** Void parameter callback. *)
    val remove_key : key -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.sync.remove"]

    (** Void parameter callback. *)
    val remove_keys : key list -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.sync.remove"]

    (** Void parameter callback. *)
    val clear : ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.sync.clear"]
end

module Local : sig
    val get_key : key -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.local.get"]

    val get_keys : key list -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.local.get"]

    val get_all : callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.local.get"]

    (** A dictionary specifying default values. *)
    val get_with_defaults : Ojs.t Dict.t -> callback:(Ojs.t Dict.t callback_arg -> unit) -> unit
    [@@js.global "chrome.storage.local.get"]

    (** Void parameter callback. *)
    val set : Ojs.t Dict.t -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.local.set"]

    (** Void parameter callback. *)
    val remove_key : key -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.local.remove"]

    (** Void parameter callback. *)
    val remove_keys : key list -> ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.local.remove"]

    (** Void parameter callback. *)
    val clear : ?callback:(Ojs.t option callback_arg -> unit) -> unit -> unit
    [@@js.global "chrome.storage.local.clear"]
end

(* Events *)

type area_name =
  | Local [@js "local"]
  | Sync [@js "sync"]
[@@js.enum]

type storage_change =
  { oldValue : Ojs.t option
  ; newValue : Ojs.t option
  }

type on_changed_listener = storage_change Dict.t -> area_name -> unit

(** Fired when one or more items change. *)
type on_changed_event =
  { add_listener : on_changed_listener -> unit
  ; remove_listener : on_changed_listener -> unit
  ; has_listener : on_changed_listener -> bool
  }

val on_changed : on_changed_event
[@@js.global "chrome.storage.onChanged"]
