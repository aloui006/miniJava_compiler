open Type
open AST
open Exceptions

(* Definitions of used Data structures in environement
   Class will have a list of string of its defined methods, the implementation of these methods
   will be contained in the global_methodes attribute
*)

type class_data = {def_attributes:(string,string) Hashtbl.t;def_methods:string list ;parent:string}
type method_data = astmethod

(*Definition of the class environement *)
class environement =
  object (self)

  val global_methodes = Hashtbl.create 0 ;
  val classes = (let c = Hashtbl.create 0 in

(*Definition of particular classes *)
  let object_class = {def_attributes = Hashtbl.create 0; def_methods =  []; parent=""} in
  Hashtbl.add c "Object" object_class;
  let string_class = {def_attributes = Hashtbl.create 0; def_methods =  []; parent="Object"} in
  Hashtbl.add c "String" string_class;
  let int_class = {def_attributes = Hashtbl.create 0; def_methods =  []; parent="Object"} in
  Hashtbl.add c "Int" int_class;
  let boolean_class = {def_attributes = Hashtbl.create 0; def_methods =  []; parent="Object"} in
  Hashtbl.add c "Boolean" boolean_class;
  c;)

(*avoid having interface instance +++todo+++ *)
(*  Compiling Class.. adding class to the enviroment
    Check if Parent is defined and no other class is defined having the same name
    Building the table of methods
 *)

  method add_class (cl : asttype ) =     match cl.info with
  |Class classe ->
    if ( not (Hashtbl.mem classes classe.cparent.tid)) then
    raise (CompilingError ("The parent Class of " ^ cl.id ^ " is not known"));
    if (Hashtbl.mem classes cl.id) then
    raise (CompilingError ("Class " ^ cl.id ^ " is already defined"));
    let class_data = {parent = classe.cparent.tid; def_attributes = Hashtbl.create 0;def_methods = [] } in

      (*print_endline ("nom parent " ^ classe.cparent.tid) ;
      print_endline ("nom classe " ^ cl.id );
      print_endline "class added successfully ";
      print_endline "" ;
      print_int (Hashtbl.length classes) ;
      print_endline "" ;*)

    (*Adding methods of class to global_methodes
      and verify if parent class methods are not defined and add them
      to the list of this class methods definition
    *)
    let parent_class = Hashtbl.find classes classe.cparent.tid in
    List.map (fun x -> (cl.id^"_"^x.mname)::class_data.def_methods) classe.cmethods ;
    List.map (fun x -> Hashtbl.add global_methodes (cl.id^"_"^x.mname) x ) classe.cmethods ;
    let method_list = classe.cmethods in
    List.map (fun x -> classe.cparent.tid^"_"^x.mname) method_list ;
    let verify_methods x = function
      | string  -> (if not (List.mem method_list x) then x::class_data.def_methods)
      | _ -> []
    in
    List.map verify_methods parent_class.def_methods;




    Hashtbl.add classes cl.id class_data;


  |_ -> print_endline "this is not a class" ;







  end
