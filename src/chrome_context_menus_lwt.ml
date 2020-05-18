open Core_types
open Chrome_context_menus

let create options : menu_item_id Lwt.t =
    let%lwt (_, result) = wrap_callback_with_result (create options) in
    Lwt.return result