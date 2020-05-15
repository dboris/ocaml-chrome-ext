type error = { message : string option }

val get_last_error : unit -> error option
[@@js.get "chrome.runtime.lastError"]

[@@@js.stop]
    exception Chrome_runtime_error of string

    type 'a callback_arg

    val callback_arg_of_js : (Ojs.t -> 'a) -> Ojs.t -> 'a callback_arg

    val wrap_callback :
        (?callback:('a callback_arg -> unit) -> unit -> unit) ->
        'a Lwt.t
[@@@js.start]

[@@@js.implem
    exception Chrome_runtime_error of string

    type 'a callback_arg = (Ojs.t -> 'a) * Ojs.t

    let callback_arg_of_js alpha_of_js v = (alpha_of_js, v)

    let wrap_callback f =
        let (p, r) = Lwt.wait () in
        let callback (alpha_of_js, ojs) =
            let last_error = get_last_error () in
            if Option.is_some last_error then
                let error_message =
                    last_error
                    |> Option.get
                    |> (fun {message} ->
                        Option.value message ~default:"No message was provided")
                in
                Lwt.wakeup_exn r (Chrome_runtime_error error_message)
            else
                Lwt.wakeup r (alpha_of_js ojs)
        in
        let () = f ?callback:(Some callback) () in
        p
]

type string_or_string_array =
  [ `Str of string | `Array of string array ]
[@js.union]

val string_or_string_array_to_js : string_or_string_array -> Ojs.t

module Window : sig
    type id = int

    val id_of_js : Ojs.t -> id
    val id_to_js : id -> Ojs.t

    type type_ =
      | Normal [@js "normal"]
      | Popup [@js "popup"]
      | Panel [@js "panel"]
      | Devtools [@js "devtools"]
    [@@js.enum]

    val type__of_js : Ojs.t -> type_
    val type__to_js : type_ -> Ojs.t
end

type extension_id = string

val extension_id_to_js : extension_id -> Ojs.t

module Tab : sig
    type id = int

    val id_of_js : Ojs.t -> id
    val id_to_js : id -> Ojs.t

    type status =
      | Loading [@js "loading"]
      | Complete [@js "complete"]
    [@@js.enum]

    val status_of_js : Ojs.t -> status
    val status_to_js : status -> Ojs.t

    type muted_info_reason =
      | Capture [@js "capture"]
      | Extension [@js "extension"]
      | User [@js "user"]
    [@@js.enum]

    type muted_info =
      { extensionId : string option
      ; muted : bool
      ; reason : muted_info_reason option
      }

    val muted_info_of_js : Ojs.t -> muted_info
    val muted_info_to_js : muted_info -> Ojs.t

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
      ; status : status option
      ; title : string option
      ; url : string option
      ; width : int option
      ; windowId : Window.id
      }

    val t_of_js : Ojs.t -> t
    val t_to_js : t -> Ojs.t
end

module JSON : sig
    val parse : string -> Ojs.t [@@js.global "JSON.parse"]
    val stringify : Ojs.t -> string [@@js.global "JSON.stringify"]
end
