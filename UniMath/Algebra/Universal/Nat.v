(***** Universal Algebra: the natural number algebras ******)

Require Import UniMath.Foundations.All.
Require Import UniMath.Combinatorics.Vectors.
Require Import UniMath.Combinatorics.FiniteSets.
Require Import UniMath.Algebra.Universal.

Open Scope stn.

Definition nat_signature: signature := make_signature_simple (vcons 0 (vcons 1 vnil)).

Definition nat_zero: names nat_signature := (●0).
Definition nat_succ: names nat_signature := (●1).

Definition nat_ops (nm : names nat_signature): Vector nat (arity nm) → nat.
Proof.
  induction nm as [n proofn].
  induction n.
  { cbn. exact (λ _, 0). }
  induction n.
  { cbn. exact (λ x, S(pr1 x)). }
  { exact (fromempty (nopathsfalsetotrue proofn)). }
Defined.

Definition nat_algebra : algebra nat_signature
  := make_algebra natset nat_ops.

Definition nat2term (n: nat): term nat_signature 
  := nat_rect _ (build_term nat_zero vnil) (λ n termn, build_term nat_succ (vcons termn vnil)) n.