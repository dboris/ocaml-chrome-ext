open Lwt.Infix
open Core_types

let get_frame opts : Chrome_web_navigation.frame_details Lwt.t =
    wrap_required_callback (Chrome_web_navigation.get_frame opts)

let get_all_frames opts : Chrome_web_navigation.frame_info list Lwt.t =
    wrap_required_callback (Chrome_web_navigation.get_all_frames opts)
