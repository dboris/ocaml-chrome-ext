open Core_types

type context_type =
  | All [@js "all"]
  | Audio [@js "audio"]
  | Browser_action [@js "browser_action"]
  | Editable [@js "editable"]
  | Frame [@js "frame"]
  | Image [@js "image"]
  | Launcher [@js "launcher"]
  | Link [@js "link"]
  | Page [@js "page"]
  | Page_action [@js "page_action"]
  | Selection [@js "selection"]
  | Video [@js "video"]
[@@js.enum]

type menu_item_type =
  | Normal [@js "normal"]
  | Checkbox [@js "checkbox"]
  | Radio [@js "radio"]
  | Separator [@js "separator"]
[@@js.enum]

type menu_item_id =
  [ `Int of int | `String of string ]
[@js.union]

val menu_item_id_of_js : Ojs.t -> menu_item_id
[@@js.custom
    let menu_item_id_of_js v =
        if Ojs.obj_type v = "[object Number]" then
            `Int (Ojs.int_of_js v)
        else
            `String (Ojs.string_of_js v)
]

type media_type =
  | Audio [@js "audio"]
  | Image [@js "image"]
  | Video [@js "video"]
[@@js.enum]

type onclick_info =
  { checked : bool option
  ; editable : bool
  ; frameId : int option
  ; frameUrl : string option
  ; linkUrl : string option
  ; mediaType : media_type option
  ; menuItemId : menu_item_id
  ; pageUrl : string option
  ; parentMenuItemId : menu_item_id option
  ; selectionText : string option
  ; srcUrl : string option
  ; wasChecked : bool option
  }

type match_pattern = string

type create_opts

val create_opts :
    ?checked:bool ->
    ?contexts:context_type list ->
    ?documentUrlPatterns:match_pattern list ->
    ?enabled:bool ->
    ?id:string ->
    ?onclick:(onclick_info -> Tab.t -> unit) ->
    ?parentId:menu_item_id ->
    ?targetUrlPatterns:match_pattern list ->
    ?title:string ->
    ?type_:menu_item_type ->
    ?visible:bool ->
    unit ->
    create_opts
[@@js.builder]

val create :
    create_opts ->
    ?callback:(Ojs.t option callback_arg -> unit) ->
    unit ->
    menu_item_id
[@@js.global "chrome.contextMenus.create"]