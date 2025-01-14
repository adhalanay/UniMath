(** * Homotopy theory of simplicial sets.

Vladimir Voevodsky

started on Nov. 22, 2014 (with Alexander Vishik)

*)

(* Preamble *)

Require Import UniMath.MoreFoundations.Tactics.

Require Export UniMath.Combinatorics.FiniteSets.
(* Require Export UniMath.Combinatorics.OrderedSets. *)
Require Export UniMath.CategoryTheory.Core.Categories.
Require Export UniMath.CategoryTheory.Core.Functors.
Require Export UniMath.CategoryTheory.FunctorCategory.
Require Export UniMath.CategoryTheory.categories.HSET.Core.
Require Export UniMath.CategoryTheory.categories.HSET.Univalence.
Require Export UniMath.CategoryTheory.opp_precat.

(* To upstream files *)



(* The pre-category data for the category Delta *)

Local Open Scope stn.

Definition monfunstn ( n m : nat ) : UU := ∑ f : ⟦ n ⟧ -> ⟦ m ⟧, ∏ (x y: ⟦n⟧), x ≤ y -> f x ≤ f y.
Definition make_monfunstn { m n : nat } f is := (f,,is) : monfunstn m n.
Definition monfunstnpr1 {n m : nat} : monfunstn n m  -> ⟦ n ⟧ -> ⟦ m ⟧ := pr1.

Lemma monfunstnpr1_isInjective {m n} (f g : monfunstn m n) : monfunstnpr1 f = monfunstnpr1 g -> f = g.
Proof.
  intros e.
  apply subtypePath.
  { intros h. apply impred; intro i. apply impred; intro j. apply impred; intro l.
    apply propproperty. }
  exact e.
Defined.

Coercion monfunstnpr1 : monfunstn >-> Funclass .

Lemma isasetmonfunstn n m : isaset ( monfunstn n m ) .
Proof.
  intros . apply ( isofhleveltotal2 2 ) .
  { apply impred. intro t. apply isasetstn. }
  intro f. apply impred; intro i.  apply impred; intro j. apply impred; intro l.
  apply isasetaprop, propproperty.
Defined.

Definition monfunstnid n : monfunstn n n := make_monfunstn (idfun _) (λ x y is, is).

Definition monfunstncomp { n m k : nat } ( f : monfunstn n m ) ( g : monfunstn m k ) :
  monfunstn n k .
Proof.
  intros . exists ( g ∘ f ) . intros i j l. unfold funcomp.
  apply ( pr2 g ). apply ( pr2 f ) . assumption.
Defined.

Definition precatDelta : precategory .
Proof.
  use tpair.
  { use tpair.
    { exists nat. intros m n. exact (monfunstn (S m) (S n)). }
    { split.
      { intros m. apply monfunstnid. }
      { intros l m n f g. exact (monfunstncomp f g). } } }
  apply is_precategory_one_assoc_to_two.
  simpl. split.
  { simpl. split.
    { intros m n f. now apply monfunstnpr1_isInjective. }
    { intros m n f. now apply monfunstnpr1_isInjective. } }
  { simpl. intros m n o p f g h. now apply monfunstnpr1_isInjective. }
Defined.

Local Open Scope cat.

Definition has_homsets_precatDelta : has_homsets precatDelta.
Proof.
  intros a b.
  cbn.
  apply isasetmonfunstn.
Qed.

Definition catDelta : category := make_category precatDelta has_homsets_precatDelta.

Definition sSet := functor_category catDelta^op category_HSET.
(* V.V. with Sasha Vishik, Nov. 23, 2014 *)


(* End of file *)
