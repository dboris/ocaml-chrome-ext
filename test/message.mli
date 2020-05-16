open Chrome_ext

module Test_suite_to_background : sig
    type t =
      | Increment of int  (* -> int *)
    [@@js.sum]

    val t_to_js : t -> Ojs.t
    val t_of_js : Ojs.t -> t

    val increment : int -> int Lwt.t
    [@@js.custom
        let increment n =
            Runtime_lwt.send_message (t_to_js (Increment n)) ()
            |> Lwt.map Ojs.int_of_js
    ]

    val increment_result : int -> Ojs.t
    [@@js.custom let increment_result = Ojs.int_to_js ]
end