[@@@js.stop]
    exception Chrome_runtime_error of string
[@@@js.start]
[@@@js.implem
    exception Chrome_runtime_error of string
]

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

type tab_status =
  | Loading [@js "loading"]
  | Complete [@js "complete"]
[@@js.enum]

val tab_status_of_js : Ojs.t -> tab_status
val tab_status_to_js : tab_status -> Ojs.t

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

module JSON : sig
    val parse : string -> Ojs.t [@@js.global "JSON.parse"]
    val stringify : Ojs.t -> string [@@js.global "JSON.stringify"]
end
