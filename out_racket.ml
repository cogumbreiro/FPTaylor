open List
open Lib
open Expr

let gen_racket_function fmt (name, total2, exp, e) =
  let nl = Format.pp_print_newline fmt in
  let p str = Format.pp_print_string fmt str; nl() in 
  let p' = Format.pp_print_string fmt in
  let var_names = vars_in_expr e in
  let vars = map (fun v -> v ^ "-var") var_names in
  p (Format.sprintf "(define eps (make-interval (bfexp2 (bf %d))))\n" exp);
  p (Format.sprintf "(define total2 (make-interval %e))\n" total2);
  p' (Format.sprintf "(define (%s " name);
  print_list p' (fun () -> p' " ") vars;
  p' ")\n\t";
  print_expr_in_env racket_interval_print_env fmt e;
  p' ")"

let create_racket_file fname name total2 exp expr =
  let tmp = Lib.get_dir "tmp" in
  let out_name = Filename.concat tmp (fname ^ ".rkt") in
  let _ = write_to_file out_name gen_racket_function (name, total2, exp, expr) in
  ()