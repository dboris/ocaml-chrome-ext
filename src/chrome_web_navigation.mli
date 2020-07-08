open Core_types

(* Get frame *)

type get_frame_opts

val get_frame_opts : tabId:Tab.id -> frameId:int -> get_frame_opts
[@@js.builder]

type frame_details =
  { errorOccurred : bool
  ; parentFrameId : int
  ; url : string
  }

val get_frame :
    get_frame_opts ->
    callback:(frame_details callback_arg -> unit) ->
    unit
[@@js.global "chrome.webNavigation.getFrame"]

(* Get all frames *)

type get_all_frames_opts

val get_all_frames_opts : ?tabId:Tab.id -> unit -> get_all_frames_opts
[@@js.builder]

type frame_info =
  { errorOccurred : bool
  ; frameId : int
  ; parentFrameId : int
  ; processId : int
  ; url : string
  }

val get_all_frames :
    get_all_frames_opts ->
    callback:(frame_info list callback_arg -> unit) ->
    unit
[@@js.global "chrome.webNavigation.getAllFrames"]