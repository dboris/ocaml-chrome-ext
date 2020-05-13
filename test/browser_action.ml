open Printf
open Chrome_ext

let () =
    Lwt.async (fun () ->
        try%lwt
            let%lwt result =
                    Tabs.execute_script (Tabs.execute_script_opts ~file:"content_script.bc.js" ())
            in
            result
            |> List.iter (fun res -> printf "exec script result: %s\n" (JSON.stringify res));
            Lwt.return ()
        with
        | Chrome_runtime_error msg -> eprintf "Runtime error: %s\n" msg;
        let%lwt response =
            Runtime.send_message (Ojs.int_to_js 42) ()
            |> Lwt.map Ojs.int_of_js
        in
        if Int.equal response 84 then print_endline "Response correct";
        Lwt.return ());
    print_endline "BA was run"