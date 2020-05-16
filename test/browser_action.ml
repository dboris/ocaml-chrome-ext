open Chrome_ext

class int_to_int_message n =
    object
        method to_js = Ojs.int_to_js n
        method of_js = Ojs.int_of_js
    end

let () =
    Lwt.async @@ fun () ->
        let%lwt _ =
            Tabs_lwt.create (Tabs.create_opts ~url:(Runtime.get_url "test_runner.html") ())
        in
        (* and result =
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
            Runtime_lwt.send_message' (new int_to_int_message 42) ()
        in
        if Int.equal response 84 then print_endline "Response correct";
        let%lwt tabs =
            Tabs_lwt.query (Tabs.query_opts ~currentWindow:true ~active:true ()) in
        printf "Tabs count: %d\n" (List.length tabs);
        let tab = List.hd tabs in
        tab.url |> Option.iter (printf "Tab url: %s\n"); *)
        Lwt.return ()