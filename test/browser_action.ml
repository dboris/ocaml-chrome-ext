open Printf
open Chrome_ext

let () =
    Lwt.async (fun () ->
        let%lwt result =
            try%lwt
                Tabs_lwt.execute_script
                    (Tabs.execute_script_opts ~file:"content_script.bc.js" ())
            with
            | Chrome_runtime_error msg ->
                eprintf "Runtime error: %s\n" msg;
                Lwt.return Ojs.null
            | ex ->
                printf "Some exn: %s\n" (Printexc.to_string ex);
                printf "lastError: %s\n" (Runtime.get_last_error () |> Option.fold ~none:"None" ~some:(fun Runtime.{message} -> Option.get message));
                Lwt.return Ojs.null
        in
        printf "exec script result: %s\n" (JSON.stringify result);
        let%lwt response =
            Runtime_lwt.send_message (Ojs.int_to_js 42) ()
            |> Lwt.map Ojs.int_of_js
        in
        if Int.equal response 84 then print_endline "Response correct";
        Lwt.return ());
    print_endline "BA was run"