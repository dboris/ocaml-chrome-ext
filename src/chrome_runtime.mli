open Core_types

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

type message_sender =
  { tab : Tab.t option
  ; frameId : int option
  ; id : string option
  ; url : string option
  ; tlsChannelId : string option
  ; nativeApplication : string option
  ; origin : string option
  }

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

(* Get url *)

val get_url : string -> string
[@@js.global "chrome.runtime.getURL"]