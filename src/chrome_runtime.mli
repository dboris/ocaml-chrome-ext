open Core_types

(* Get url *)

val get_url : string -> string
[@@js.global "chrome.runtime.getURL"]

type message_sender =
  { tab : Tab.t option
  ; frameId : int option
  ; id : string option
  ; url : string option
  ; tlsChannelId : string option
  ; nativeApplication : string option
  ; origin : string option
  }

val message_sender_to_js : message_sender -> Ojs.t
val message_sender_of_js : Ojs.t -> message_sender

module Port : sig
    type message_listener = Ojs.t -> t -> unit

    and message_event = { add_listener : message_listener -> unit }

    and disconnect_event = { add_listener : t -> unit }

    and t =
      { disconnect : unit -> unit
      ; name : string
      ; onDisconnect : disconnect_event
      ; onMessage : message_event
      ; postMessage : Ojs.t -> unit
      ; sender : message_sender option
      }
end

(* Connect *)

type connect_opts

val connect_opts :
  ?name:string ->
  ?includeTlsChannelId:bool ->
  unit ->
  connect_opts
[@@js.builder]

val connect :
    ?extension_id:extension_id ->
    ?options:connect_opts ->
    unit ->
    Port.t
[@@js.global "chrome.runtime.connect"]

(* Send message *)

type send_message_opts

val send_message_opts : ?includeTlsChannelId:bool -> unit -> send_message_opts
[@@js.builder]

val send_message :
    ?extension_id:extension_id ->
    Ojs.t ->
    ?options:send_message_opts ->
    ?callback:(Ojs.t callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.runtime.sendMessage"]

(* Message event *)

type message_listener_response = [`Sync_or_no_response | `Async_response of bool]
[@js.union]

val message_listener_response_to_js : message_listener_response -> Ojs.t

val message_listener_response_of_js : Ojs.t -> message_listener_response
[@@js.custom
    let message_listener_response_of_js v =
        if Ojs.is_null v then
            `Sync_or_no_response
        else
            `Async_response (Ojs.bool_of_js v)
]

type message_listener =
    Ojs.t ->
    message_sender ->
    (Ojs.t -> unit) ->
    message_listener_response

type message_event =
  { add_listener : message_listener -> unit
  ; remove_listener : message_listener -> unit
  ; has_listener : message_listener -> bool
  }

(** Fired when a message is sent from either an extension process
    (by runtime.sendMessage) or a content script (by tabs.sendMessage). *)
val on_message : message_event
[@@js.global "chrome.runtime.onMessage"]

(* Installed event *)

type on_installed_reason =
  | Install [@js "install"]
  | Update [@js "update"]
  | Browser_update [@js "chrome_update"]
  | Shared_module_update [@js "shared_module_update"]
[@@js.enum]

type on_installed_details =
  { id : string option
  ; previousVersion : string option
  ; reason : on_installed_reason
  }

type on_installed_listener = on_installed_details -> unit

(** Fired when the extension is first installed, when the extension is updated
    to a new version, and when the browser is updated to a new version. *)
type on_installed_event =
  { add_listener : on_installed_listener -> unit
  ; remove_listener : on_installed_listener -> unit
  ; has_listener : on_installed_listener -> bool
  }

val on_installed : on_installed_event
[@@js.global "chrome.runtime.onInstalled"]

(* Connect event *)

type connect_listener = Port.t -> unit

type connect_event = { add_listener : connect_listener -> unit }

(** Fired when a connection is made from either an extension process
    or a content script (by runtime.connect). *)
val on_connect : connect_event
[@@js.global "chrome.runtime.onConnect"]
