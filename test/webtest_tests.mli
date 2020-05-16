type webtest =
  { run : unit -> bool
  ; log : string
  ; passed : bool
  ; finished : bool
  }

val get_webtest : unit -> webtest option
[@@js.get "webtest"]
