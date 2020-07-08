open Lwt.Infix
open Core_types

let get_frame ~tab_id ~frame_id : Chrome_web_navigation.frame_details Lwt.t =
    let opts =
      Chrome_web_navigation.get_frame_opts ~tabId:tab_id ~frameId:frame_id in
    wrap_required_callback (Chrome_web_navigation.get_frame opts)

let get_all_frames tab_id : Chrome_web_navigation.frame_info list Lwt.t =
    let opts = Chrome_web_navigation.get_all_frames_opts tab_id in
    wrap_required_callback (Chrome_web_navigation.get_all_frames opts)
