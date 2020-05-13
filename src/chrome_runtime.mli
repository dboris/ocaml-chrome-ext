open Core_types

type error = { message : string option }

val last_error : error option
[@@js.global "chrome.runtime.lastError"]

val wrap_callback : (?callback:('a -> unit) -> unit -> unit) -> 'a Lwt.t
[@@js.custom
    let wrap_callback f =
        let (p, r) = Lwt.wait () in
        let callback response =
            if Option.is_some last_error then
                let error_message =
                    last_error
                    |> Option.get
                    |> (fun {message} -> message |> Option.value ~default:"No message")
                in
                Lwt.wakeup_exn r (Chrome_runtime_error error_message)
            else
                Lwt.wakeup r response
        in
        let () = f ?callback:(Some callback) () in
        p
]

type send_message_opts

val send_message_opts : ?includeTlsChannelId:bool -> unit -> send_message_opts
[@@js.builder]

val send_message' :
    ?extension_id:extension_id ->
    Ojs.t ->
    ?options:send_message_opts ->
    ?callback:(Ojs.t -> unit) ->
    unit ->
    unit
[@@js.global "chrome.runtime.sendMessage"]

val send_message :
    ?extension_id:extension_id ->
    Ojs.t ->
    ?options:send_message_opts ->
    unit ->
    Ojs.t Lwt.t
[@@js.custom
    let send_message ?extension_id msg ?options () =
        wrap_callback (send_message' ?extension_id msg ?options)
]

type message_sender =
  { tab : Tab.t option
  ; frameId : int option
  ; id : string option
  ; url : string option
  ; tlsChannelId : string option
  ; nativeApplication : string option
  ; origin : string option
  }

type message_listener_response = [`Sync_or_no_response | `Async_response of bool] [@js.union]

val message_listener_response_of_js : Ojs.t -> message_listener_response
[@@js.custom
    let message_listener_response_of_js v =
        if Ojs.is_null v then `Sync_or_no_response else `Async_response (Ojs.bool_of_js v)
]

val message_listener_response_to_js : message_listener_response -> Ojs.t

type message_listener = Ojs.t -> message_sender -> (Ojs.t -> unit) -> message_listener_response

type message_event =
  { add_listener : message_listener -> unit
  ; remove_listener : message_listener -> unit
  ; has_listener : message_listener -> bool
  }

(** Fired when a message is sent from either an extension process (by runtime.sendMessage)
    or a content script (by tabs.sendMessage). *)
val on_message : message_event
[@@js.global "chrome.runtime.onMessage"]

module Message_event : sig
    val add_listener : (Ojs.t -> message_sender -> Ojs.t Lwt.t) -> unit
    [@@js.custom
        let add_listener handler =
            on_message.add_listener (fun msg sender send_response ->
                let p = handler msg sender in
                let resolve () = Lwt.on_any p send_response raise in
                let send_response_async () = resolve (); Lwt.return () in
                if Lwt.is_sleeping p then
                    (Lwt.async send_response_async; `Async_response true)
                else
                    (resolve (); `Sync_or_no_response))
    ]
end