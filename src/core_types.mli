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

val muted_info_of_js : Ojs.t -> muted_info
val muted_info_to_js : muted_info -> Ojs.t
