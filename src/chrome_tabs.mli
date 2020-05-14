open Core_types

(* Send message *)

type send_message_opts

val send_message_opts : ?frameId:int -> unit -> send_message_opts
[@@js.builder]

val send_message :
    tab_id:Tab.id ->
    Ojs.t ->
    ?options:send_message_opts ->
    ?callback:(callback_arg -> unit) ->
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
    ?callback:(callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tabs.executeScript"]
