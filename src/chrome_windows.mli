open Core_types

(* Create window *)

type create_opts

val create_opts :
    ?focused:bool ->
    ?height:int ->
    ?incognito:bool ->
    ?left:int ->
    ?setSelfAsOpener:bool ->
    ?state:Window.state ->
    ?tabId:Tab.id ->
    ?top:int ->
    ?type_:Window.type_ ->
    ?url:string_or_string_array ->
    ?width:int ->
    unit ->
    create_opts
[@@js.builder]

val create :
    ?options:create_opts ->
    ?callback:(Window.t callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.windows.create"]

(* Remove window *)

val remove :
    Window.id ->
    ?callback:(Ojs.t option callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.windows.remove"]

(* Update window *)

type update_opts

val update_opts :
    ?drawAttention:bool ->
    ?focused:bool ->
    ?height:int ->
    ?left:int ->
    ?state:Window.state ->
    ?top:int ->
    ?width:int ->
    unit ->
    update_opts
[@@js.builder]

val update :
    Window.id ->
    update_opts ->
    ?callback:(Window.t callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.windows.update"]

(* Get window *)

type get_opts

val get_opts :
    ?populate:bool ->
    ?windowTypes:Window.type_ list ->
    unit ->
    get_opts
[@@js.builder]

val get :
    Window.id ->
    ?options:get_opts ->
    callback:(Window.t callback_arg -> unit) ->
    unit
[@@js.global "chrome.windows.get"]

(** Gets the current window. The current window is the window
    that contains the code that is currently executing.
    This can be different from the topmost or focused window. *)
val get_current :
    ?options:get_opts ->
    callback:(Window.t callback_arg -> unit) ->
    unit
[@@js.global "chrome.windows.getCurrent"]

(** Gets the window that was most recently focused —
    typically the window 'on top'. *)
val get_last_focused :
    ?options:get_opts ->
    callback:(Window.t callback_arg -> unit) ->
    unit
[@@js.global "chrome.windows.getLastFocused"]

(* Events *)

type on_removed_listener = Window.id -> unit

(** Fired when a window is removed. *)
type on_removed_event =
  { add_listener : on_removed_listener -> unit
  ; remove_listener : on_removed_listener -> unit
  ; has_listener : on_removed_listener -> bool
  }

val on_removed : on_removed_event
[@@js.global "chrome.windows.onRemoved"]