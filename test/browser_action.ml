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
                Lwt.return []
            | ex ->
                printf "Some exn: %s\n" (Printexc.to_string ex);
                Lwt.return []
        and lang =
            Tabs_lwt.detect_language ()
        in
        printf "Tab language: %s\n" lang;
        result
        |> List.iter (fun o -> printf "exec script result: %s\n" (JSON.stringify(o)));
        let%lwt response =
            Runtime_lwt.send_message (Ojs.int_to_js 42) ()
            |> Lwt.map Ojs.int_of_js
        in
        if Int.equal response 84 then print_endline "Response correct";
        let%lwt tabs =
            Tabs_lwt.query (Tabs.query_opts ~currentWindow:true ~active:true ()) in
        printf "Tabs count: %d\n" (List.length tabs);
        let tab = List.hd tabs in
        tab.url |> Option.iter (printf "Tab url: %s\n");
        Lwt.return ());
    print_endline "BA was run"