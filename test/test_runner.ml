open Js_of_ocaml
open Js_of_ocaml_lwt

let render_results passed result log =
    Dom_html.getElementById_coerce "result" Dom_html.CoerceTo.h1
    |> Option.iter (fun el ->
        el##.textContent := Js.Opt.return (Js.string result);
        el##.style##.color := Js.string (if passed then "green" else "red"));

    Dom_html.getElementById_coerce "log" Dom_html.CoerceTo.pre
    |> Option.iter (fun el ->
        el##.textContent := Js.Opt.return (Js.string log))

let run_tests () =
    let open Webtest_tests in
    let%lwt () = Lwt_js.sleep 1. in
    get_webtest ()
    |> Option.iter (fun {run; _} ->
        let rec report () =
            let {log; passed; finished; _} = Option.get (get_webtest ()) in
            if finished then begin
                let result = if passed then "Passed!" else "Failed!" in
                print_endline result;
                print_endline log;
                render_results passed result log
            end
            else
                Lwt.async (fun () ->
                    let%lwt () = Lwt_js.sleep 1. in
                    report ();
                    Lwt.return ())
        in
        run () |> ignore;
        report ());
    Lwt.return ()

let () =
    Webtest_js.Runner.setup Test_suite.suite;
    Lwt.async run_tests
