open Core_types

(* Send message *)

type send_message_opts

val send_message_opts : ?frameId:int -> unit -> send_message_opts
[@@js.builder]

val send_message :
    tab_id:Tab.id ->
    Ojs.t ->
    ?options:send_message_opts ->
    ?callback:(Ojs.t callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tabs.sendMessage"]

(* Execute script *)

type run_at =
  | Document_idle [@js "document_idle"]  (* default *)
  | Document_start [@js "document_start"]
  | Document_end [@js "document_end"]
[@@js.enum]

type css_origin =
  | Author [@js "author"]  (* default *)
  | User [@js "user"]
[@@js.enum]

type execute_script_opts

val execute_script_opts :
    ?allFrames:bool ->
    ?code:string ->
    ?cssOrigin:css_origin ->
    ?file:string ->
    ?frameId:int ->
    ?matchAboutBlank:bool ->
    ?runAt:run_at ->
    unit ->
    execute_script_opts
[@@js.builder]

val execute_script :
    ?tab_id:Tab.id ->
    execute_script_opts ->
    ?callback:(Ojs.t list callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tabs.executeScript"]

(* Query tabs *)

type query_opts

val query_opts :
    ?active:bool ->
    ?audible:bool ->
    ?autoDiscardable:bool ->
    ?currentWindow:bool ->
    ?discarded:bool ->
    ?highlighted:bool ->
    ?index:int ->
    ?muted:bool ->
    ?lastFocusedWindow:bool ->
    ?pinned:bool ->
    ?status:Tab.status ->
    ?title:string ->
    ?url:string_or_string_array ->
    ?windowId:Window.id ->
    ?windowType:Window.type_ ->
    unit ->
    query_opts
[@@js.builder]

val query :
    query_opts ->
    ?callback:(Tab.t list callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tabs.query"]

(* Create tab *)

type create_opts

val create_opts :
    ?active:bool ->
    ?index:int ->
    ?openerTabId:Tab.id ->
    ?pinned:bool ->
    ?selected:bool ->
    ?url:string ->
    ?windowId:Window.id ->
    unit ->
    create_opts
[@@js.builder]

val create :
    create_opts ->
    ?callback:(Tab.t callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tabs.create"]

(* Detect language *)

val detect_language :
    ?tab_id:Tab.id ->
    ?callback:(string callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tabs.detectLanguage"]

(* Events *)

type change_info =
  { audible : bool option
  ; discarded : bool option
  ; favIconUrl : string option
  ; autoDiscardable : bool option
  ; mutedInfo : Tab.muted_info option
  ; pinned : bool option
  ; status : Tab.status option
  ; title : string option
  ; url : string option
  }

type on_updated_listener = Tab.id -> change_info -> Tab.t -> unit

(** Fired when a tab is updated. *)
type on_updated_event =
  { add_listener : on_updated_listener -> unit
  ; remove_listener : on_updated_listener -> unit
  ; has_listener : on_updated_listener -> bool
  }

val on_updated : on_updated_event
[@@js.global "chrome.tabs.onUpdated"]