module Dict : sig
    type 'a t = (string * 'a) list

    val t_to_js: ('a -> Ojs.t) -> 'a t -> Ojs.t

    val t_of_js: (Ojs.t -> 'a) -> Ojs.t -> 'a t
end = struct
    type 'a t = (string * 'a) list

    let t_to_js alpha_to_js l =
        let o = Ojs.empty_obj () in
        List.iter (fun (k, v) -> Ojs.set o k (alpha_to_js v)) l;
        o

    let t_of_js alpha_of_js o =
        let l = ref [] in
        Ojs.iter_properties o
            (fun k -> l := (k, alpha_of_js (Ojs.get o k)) :: !l);
        !l
end