open Chrome_tabs

let send_message ~tab_id msg ?options () =
    Chrome_runtime_lwt.wrap_callback (send_message ~tab_id msg ?options)

let execute_script ?tab_id options =
    Chrome_runtime_lwt.wrap_callback (execute_script ?tab_id options)
