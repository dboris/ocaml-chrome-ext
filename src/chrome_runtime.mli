open Core_types

[@@@js.implem
    exception Chrome_runtime_error of string
]

type error = { message : string option }

val last_error : error option
[@@js.global "chrome.runtime.lastError"]

type send_message_options

val send_message_options :
    ?includeTlsChannelId:bool ->
    unit ->
    send_message_options
[@@js.builder]

type extension_id = string

val send_message' :
    ?extension_id:extension_id ->
    Ojs.t ->
    options:send_message_options option ->
    callback:(Ojs.t -> unit) option ->
    unit
[@@js.global "chrome.runtime.sendMessage"]

val send_message :
    ?extension_id:extension_id ->
    Ojs.t ->
    Ojs.t Lwt.t
[@@js.custom
    let send_message ?extension_id msg =
        let (r, w) = Lwt.task () in
        let callback response =
            if Ojs.is_null response then
                if Option.is_some last_error then
                    let message =
                        Option.get last_error
                        |> (fun err ->
                            Option.fold ~none:"No message" ~some:(fun m -> m) err.message)
                    in
                    Lwt.wakeup_exn w (Chrome_runtime_error message)
                else
                    Lwt.wakeup w Ojs.null
            else
                Lwt.wakeup w response
        in
        send_message' ?extension_id msg ~options:None ~callback:(Some callback);
        r
]

module Tab : sig
    type id = int

    val id_to_js : id -> Ojs.t

    type t =
      { active : bool
      ; audible : bool option
      ; autoDiscardable : bool
      ; discarded : bool
      ; favIconUrl : string option
      ; height : int option
      ; highlighted : bool
      ; id : id option
      ; incognito : bool
      ; index : int
      ; mutedInfo : muted_info option
      ; openerTabId : int option
      ; pendingUrl : string option
      ; pinned : bool
      ; sessionId : string option
      ; status : tab_status option
      ; title : string option
      ; url : string option
      ; width : int option
      ; windowId : Window.id
      }

    val t_of_js : Ojs.t -> t
    val t_to_js : t -> Ojs.t
end

type message_sender =
  { tab : Tab.t option
  ; frameId : int option
  ; id : string option
  ; url : string option
  ; tlsChannelId : string option
  ; nativeApplication : string option
  ; origin : string option
  }

type message_listener = Ojs.t -> message_sender -> ?send_response:(Ojs.t -> unit) -> unit -> unit

type message_event =
  { add_listener : message_listener -> unit
  ; remove_listener : message_listener -> unit
  ; has_listener : message_listener -> bool
  }

val on_message : message_event
[@@js.global "chrome.runtime.onMessage"]