open Printf
open Js_of_ocaml_lwt

open Chrome_ext

let handle_message msg (_sender : Runtime.message_sender) (send_response : Ojs.t -> unit) =
    let x = Ojs.int_of_js msg in
    printf "Message received: %d\n" x;
    Lwt.async (fun () ->
        let%lwt () = Lwt_js.sleep 5. in
        print_endline "Sending response after sleep...";
        send_response (Ojs.int_to_js (x * 2));
        Lwt.return ());
    `Async_response true

let handle_message_lwt msg (_sender : Runtime.message_sender) =
    let x = Ojs.int_of_js msg in
    printf "Message received: %d\n" x;
    let%lwt () = Lwt_js.sleep 2. in
    print_endline "Sending lwt response after sleep...";
    Lwt.return (Ojs.int_to_js (x * 2))

let handle_message_reject msg (_sender : Runtime.message_sender) =
    let x = Ojs.int_of_js msg in
    printf "Message received: %d\n" x;
    let%lwt () = Lwt_js.sleep 5. in
    print_endline "Sending lwt response after sleep...";
    Lwt.fail_with "Something went wrong"

let handle_message_sync msg (_sender : Runtime.message_sender) =
    let x = Ojs.int_of_js msg in
    printf "Message received: %d\n" x;
    Lwt.return (Ojs.int_to_js (x * 2))

let () =
    (* Runtime.on_message.add_listener handle_message; *)
    Runtime.Message_event.add_listener handle_message_lwt;
    (* Runtime.Message_event.add_listener handle_message_sync; *)
    print_endline "BG was run"