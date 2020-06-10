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