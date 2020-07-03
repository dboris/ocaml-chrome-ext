open Core_types

type event_type =
  | Cancelled [@js "cancelled"]
  | End [@js "end"]
  | Error [@js "error"]
  | Interrupted [@js "interrupted"]
  | Marker [@js "marker"]
  | Pause [@js "pause"]
  | Resume [@js "resume"]
  | Sentence [@js "sentence"]
  | Start [@js "start"]
  | Word [@js "word"]
[@@js.enum]

type tts_event =
  { charIndex : int option
  ; errorMessage : string option
  ; length : int option
  ; type_ : event_type
  }

type tts_voice =
  { eventTypes : event_type list
  ; extensionId : string option
  ; lang : string option
  ; remote : bool option
  ; voiceName : string option
  }

type tts_opts

val tts_opts :
    ?desiredEventTypes:string list ->
    ?enqueue:bool ->
    ?extensionId:string ->
    ?lang:string ->
    ?onEvent:(tts_event -> unit) ->
    ?pitch:float ->
    ?rate:float ->
    ?requiredEventTypes:string list ->
    ?voiceName:string ->
    ?volume:float ->
    unit ->
    tts_opts
[@@js.builder]

val speak :
    string ->
    ?options:tts_opts ->
    ?callback:(Ojs.t callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tts.speak"]

val stop : unit -> unit
[@@js.global "chrome.tts.stop"]

val pause : unit -> unit
[@@js.global "chrome.tts.pause"]

val resume : unit -> unit
[@@js.global "chrome.tts.resume"]

val is_speaking :
    ?callback:(bool callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tts.isSpeaking"]

val get_voices :
    ?callback:(tts_voice list callback_arg -> unit) ->
    unit ->
    unit
[@@js.global "chrome.tts.getVoices"]