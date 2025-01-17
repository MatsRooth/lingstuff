
Require Import String. Import StringSyntax.           
 
(* Is this relevant? *)   

Add LoadPath  "/local/res/josh/coq" as Ling.

(* First compile BS.v as follows.
 /Applications/CoqIDE_8.13.1.app/Contents/Resources/bin/coqc -Q . Ling -vos BSm2.v

Josh has put in changes from BSm.v.
*)


From Ling Require Import BSm2. 
Import Ling.

(* muddy, copulatives *)

Definition muddy : AP := et "muddy".
Definition is : (DP \ S) / AP := fun x y => x y.
 

(* Generalized bind *)
Definition gbind {a b c : Cat} (x : a || b -- c) : a || (c >> b) -- c :=
  fun k => x (fun y => k y y).

(* 
 This is the type of a structured antecedent. S[DP\S] encodes a propositional and
 a predicate antecedent.
*)

Notation "x [ y ]" := (Struct y x) (at level 30, format "x [ y ]").


(* The recursive focus stuff is cut. 

   
The category of the structured binder is

S || S[DP \ S] >> S
--
S

indicating power to bind a S[DP \ S] pronoun. The category of [BEN did ---] should be

S[DP \ S] >> S || S
--
S
  
*)

(* Copied from focus.v renaming focus to foc. *)

Parameter (alt : Prop -> ((interp DP) -> Prop) -> (interp DP) -> Prop).

Definition foc (x : DP) : ((S >> S) || S -- S)|| S -- DP :=
  fun k => (fun f => (fun p => (f (alt p k x)) /\ k x)).


(* Example with focus anaphora. This should be modified to parasitic focus-vp anaphora. *)

Check lower ((gbind (lift (ari <: (is :> muddy)))) <| 
      ((lift and) |> (lower ((foc ben)  <| (lift (is :> muddy)))))).


Eval compute in lower ((gbind (lift (ari <: (is :> muddy)))) <| 
      ((lift and) |> (lower ((foc ben)  <| (lift (is :> muddy)))))).

  
 

(*
 
Guess the semantics of BEN_F_did.

  BEN_F_did equires a structured antecedent, providing a propositional and a VP
  antecedent.
*)

Definition BEN_F_did : ((S[DP \ S] >> S) || S -- S) :=
      fun (f : Prop -> Prop)   
      (x : (E -> Prop) * ((E -> Prop) -> Prop))  
    => f
         (alt ((snd x) (fst x)) (fun y : E => (fst x) y)
            ben) /\
       (fst x) ben.


(*
(S[DP \ S] >> S) || S
--
S
*) 

Definition ALICE_F_did : ((S[DP \ S] >> S) || S -- S) :=
      fun (f : Prop -> Prop)   
      (x : (E -> Prop) * ((E -> Prop) -> Prop))  
    => f
         (alt ((snd x) (fst x)) (fun y : E => (fst x) y)
            alice) /\
       (fst x) alice.

Check ALICE_F_did.


(* 
Define an operator that applies to VP to create the structured antecedent.
This has the two towers strategy, where the result for the lower tower
is a tower.
*)
 
Definition ant (f : DP \ S) : (S || (S[DP \ S] >> S) -- S)|| S -- (DP \ S) :=
    fun c => (fun k =>
       k (c f)
         (f, fun a : E -> Prop => (c a))).

Eval compute in lower ((lift john) <| (ant (kissed ben))).
(*
fun k : Prop ->
             (E -> Prop) * ((E -> Prop) -> Prop) -> Prop
       =>
       k (eet "kiss" (e "john") (e "ben"))
         (fun x : E => eet "kiss" x (e "ben"),
         fun a : E -> Prop => a (e "john"))
     : 
S || S[DP \ S] >> S
--
S

*)


Eval compute in lower ((lower ((lift john) <| (ant (kissed ben)))) <| ((lift and) |> ALICE_F_did)). 
(*
     = (eet "kiss" (e "john") (e "ben") /\
        alt (eet "kiss" (e "john") (e "ben"))
          (fun y : E => eet "kiss" y (e "ben"))
          (e "alice")) /\
       eet "kiss" (e "alice") (e "ben")
     : S


In the above, ALICE_F_did is a primitive, rather than being derived compositionally. Fixing this is
the next step.

It should be done in a way that 'did' contributes a simple VP antecedent, or one with one or more pronouns.

*) 
 

Check (foc alice) <| (lift (kissed :> ben)). 
(*
(
 (S >> S) || S
 --
 S) || S
--
S

*)
Check lower ((foc alice) <| (lift (kissed :> ben))).
(*
(S >> S) || S
--
S
*)
Check (foc alice).
(*
(
 (S >> S) || S
 --
 S) || S
--
DP

*)

Eval compute in (foc (alice : DP)) <: (lift (kissed :> ben)).

 
 

