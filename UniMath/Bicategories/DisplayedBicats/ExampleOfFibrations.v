Require Import UniMath.Foundations.All.
Require Import UniMath.MoreFoundations.All.
Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.CategoryTheory.Core.Functors.
Require Import UniMath.CategoryTheory.Core.NaturalTransformations.
Require Import UniMath.CategoryTheory.Core.Isos.
Require Import UniMath.CategoryTheory.Core.Univalence.
Require Import UniMath.CategoryTheory.whiskering.
Require Import UniMath.Bicategories.Core.Bicat.
Import Bicat.Notations.
Require Import UniMath.Bicategories.Core.Invertible_2cells.
Require Import UniMath.Bicategories.Core.Univalence.
Require Import UniMath.Bicategories.Core.BicategoryLaws.
Require Import UniMath.Bicategories.Core.EquivToAdjequiv.
Require Import UniMath.Bicategories.Core.Examples.BicatOfCats.
Require Import UniMath.Bicategories.Core.Examples.OneTypes.
Require Import UniMath.CategoryTheory.DisplayedCats.Core.
Require Import UniMath.CategoryTheory.DisplayedCats.Fibrations.
Require Import UniMath.Bicategories.DisplayedBicats.DispBicat.
Import DispBicat.Notations.
Require Import UniMath.Bicategories.DisplayedBicats.DispInvertibles.
Require Import UniMath.Bicategories.DisplayedBicats.DispUnivalence.
Require Import UniMath.Bicategories.DisplayedBicats.FibrationOfBicat.
Require Import UniMath.Bicategories.DisplayedBicats.Examples.Trivial.
Require Import UniMath.Bicategories.DisplayedBicats.Examples.Domain.
Require Import UniMath.Bicategories.DisplayedBicats.Examples.Codomain.
Require Import UniMath.Bicategories.DisplayedBicats.Examples.DispBicatOfDispCats.
Require Import UniMath.Bicategories.Colimits.Pullback.

Local Open Scope cat.

Definition TODO {A : UU} : A.
Admitted.

(**
The trivial bicategory is a fibration
 *)
Section ConstantFibration.
  Variable (B₁ B₂ : bicat).

  Definition trivial_invertible_is_cartesian_2cell
             {x₁ x₂ : B₁}
             {y₁ : trivial_displayed_bicat B₁ B₂ x₁}
             {y₂ : trivial_displayed_bicat B₁ B₂ x₂}
             {f₁ f₂ : x₁ --> x₂}
             {g₁ : y₁ -->[ f₁ ] y₂}
             {g₂ : y₁ -->[ f₂ ] y₂}
             (α : f₁ ==> f₂)
             (β : g₁ ==>[ α ] g₂)
             (Hβ : is_invertible_2cell β)
    : is_cartesian_2cell (trivial_displayed_bicat B₁ B₂) β.
  Proof.
    intros h h' γ ββ ; cbn in *.
    use iscontraprop1.
    - abstract
        (use invproofirrelevance ;
         intros τ₁ τ₂ ;
         use subtypePath ; [ intro ; apply cellset_property | ] ;
         use (vcomp_rcancel _ Hβ) ;
         exact (pr2 τ₁ @ !(pr2 τ₂))).
    - refine (ββ • Hβ^-1 ,, _).
      abstract
        (rewrite !vassocl ;
         rewrite vcomp_linv ;
         apply id2_right).
  Defined.

  Definition trivial_cartesian_2cell_is_invertible
             {x₁ x₂ : B₁}
             {y₁ : trivial_displayed_bicat B₁ B₂ x₁}
             {y₂ : trivial_displayed_bicat B₁ B₂ x₂}
             {f₁ f₂ : x₁ --> x₂}
             {g₁ : y₁ -->[ f₁ ] y₂}
             {g₂ : y₁ -->[ f₂ ] y₂}
             (α : f₁ ==> f₂)
             (β : g₁ ==>[ α ] g₂)
             (Hβ : is_cartesian_2cell (trivial_displayed_bicat B₁ B₂) β)
    : is_invertible_2cell β.
  Proof.
    cbn in *.
    unfold is_cartesian_2cell in Hβ.
    pose (Hβ f₁ g₂ (id2 _) (id2 _)) as lift.
    pose (inv := iscontrpr1 lift).
    cbn in lift, inv.
    use make_is_invertible_2cell.
    - exact (pr1 inv).
    - abstract
        (pose (Hβ f₁ g₁ (id2 _) β) as m ;
         cbn in m ;
         pose (proofirrelevance _ (isapropifcontr m)) as i ;
         simple refine (maponpaths pr1 (i (β • pr1 inv ,, _) (id₂ g₁ ,, _))) ; cbn ;
         [ cbn ;
           rewrite vassocl ;
           rewrite (pr2 inv) ;
           apply id2_right
         | apply id2_left ]).
    - abstract
        (exact (pr2 inv)).
  Defined.

  Definition trivial_local_cleaving
    : local_cleaving (trivial_displayed_bicat B₁ B₂).
  Proof.
    intros x₁ x₂ y₁ y₂ f₁ f₂ f α.
    simple refine (f ,, id2 _ ,, _) ; cbn.
    apply trivial_invertible_is_cartesian_2cell.
    is_iso.
  Defined.

  Section TrivialCartesianOneCell.
    Context {x₁ x₂ : B₁}
            {y₁ : trivial_displayed_bicat B₁ B₂ x₁}
            {y₂ : trivial_displayed_bicat B₁ B₂ x₂}
            (f : x₁ --> x₂)
            (g : y₁ -->[ f ] y₂)
            (Hg : left_adjoint_equivalence g).

    Definition trivial_lift_1cell
               {x₃ : B₁}
               {y₃ : trivial_displayed_bicat B₁ B₂ x₃}
               (h : x₃ --> x₁)
               (k : y₃ -->[ h · f] y₂)
      : lift_1cell (trivial_displayed_bicat B₁ B₂) g k.
    Proof.
      simple refine (_ ,, _) ; cbn in *.
      - exact (k · left_adjoint_right_adjoint Hg).
      - simple refine (_ ,, _) ; cbn.
        + refine (rassociator _ _ _ • (k ◃ _) • runitor _).
          exact (left_adjoint_counit Hg).
        + cbn.
          use trivial_is_invertible_2cell_to_is_disp_invertible.
          is_iso.
          apply (left_equivalence_counit_iso Hg).
    Defined.

    Definition trivial_cartesian_1cell
      : cartesian_1cell (trivial_displayed_bicat B₁ B₂) g.
    Proof.
      simple refine (_ ,, _).
      - exact @trivial_lift_1cell.
      - cbn.
        intros w z h h' k k' γ δ.
        use iscontraprop1.
        + use invproofirrelevance.
          intros φ₁ φ₂.
          use subtypePath ; [ intro ; apply trivial_displayed_bicat | ].
          cbn in *.
          pose (pr2 φ₁) as p₁.
          pose (pr2 φ₂) as p₂.
          cbn in p₁, p₂.
          rewrite transportf_const in p₁.
          rewrite transportf_const in p₂.
          cbn in p₁, p₂.
          pose (p₁ @ !p₂) as r.
          rewrite !vassocr in r.
          pose (vcomp_rcancel _ (is_invertible_2cell_runitor _) r) as r'.
          assert (is_invertible_2cell (k' ◃ left_adjoint_counit (pr1 Hg))).
          {
            is_iso.
            apply Hg.
          }
          pose (vcomp_rcancel _ X r') as r''.
          pose (vcomp_rcancel _ (is_invertible_2cell_rassociator _ _ _) r'') as r'''.
          admit.
        + simple refine (_ ,, _) ; cbn.
          * exact (δ ▹ _).
          * abstract
              (rewrite transportf_const ;
               cbn ;
               rewrite !vassocr ;
               rewrite rwhisker_rwhisker_alt ;
               rewrite !vassocl ;
               apply maponpaths ;
               rewrite !vassocr ;
               rewrite vcomp_whisker ;
               rewrite !vassocl ;
               apply maponpaths ;
               rewrite vcomp_runitor ;
               apply idpath).
    Admitted.
  End TrivialCartesianOneCell.

  Definition trivial_cartesian_1cell_is_adj_equiv
             {x₁ x₂ : B₁}
             {y₁ : trivial_displayed_bicat B₁ B₂ x₁}
             {y₂ : trivial_displayed_bicat B₁ B₂ x₂}
             (f : x₁ --> x₂)
             (g : y₁ -->[ f ] y₂)
             (Hg : cartesian_1cell (trivial_displayed_bicat B₁ B₂) g)
    : left_adjoint_equivalence g.
  Proof.
    (*
    use equiv_to_adjequiv.
    cbn in *.
    pose (pr1 Hg x₁ y₂ (id₁ x₁) (id₁ y₂)) as inv_help.
    pose (inv := pr1 inv_help).
    pose (trivial_disp_invertible_to_invertible_2cell (pr2 inv_help)) as counit.


    pose (pr2 Hg x₁ y₁ (id₁ _) (id₁ _) g (g · inv · g) (id2 _) (rinvunitor g • (g ◃ counit^-1) • lassociator _ _ _)) as unit.
    cbn in unit.
    pose (disp_cell_lift_2cell _ _ unit).
    cbn in d.
    unfold disp_mor_lift_1cell in d.
    cbn in counit.
    pose .
    unfold inv in unit.
    specialize (unit p).
    cbn in p.

    disp_cell_lift_2cell
      eq_lift_2cell
      isaprop_lift_of_lift_2cell
    fdsafadfda
    (*
    unfold lift_1cell in inv.
    unfold lift_2cell in unit.
    unfold lift_2cell_type in unit.
    cbn in unit.
     *)
    simple refine ((_ ,, (_ ,, _)) ,, (_ ,, _)).
    - exact inv.
    - admit.
    - exact counit.
    - admit.
    - cbn.
      apply counit.
     *)
    admit.
  Admitted.

  Definition trivial_global_cleaving
    : global_cleaving (trivial_displayed_bicat B₁ B₂).
  Proof.
    intros x₁ x₂ y₁ y₂.
    simple refine (y₁ ,, id₁ _ ,, _) ; cbn.
    apply trivial_cartesian_1cell.
    apply (internal_adjoint_equivalence_identity y₁).
    (*
    use tpair.
    - unfold lift_1cell ; cbn.
      intros c cc h gg.
      simple refine (gg ,, _) ; cbn.
      simple refine (runitor _ ,, _).
      use trivial_is_invertible_2cell_to_is_disp_invertible.
      is_iso.
    - cbn ; unfold lift_2cell, lift_2cell_type ; cbn -[iscontr].
      intros.
      rewrite transportf_const.
      unfold idfun.
      use iscontraprop1.
      + use invproofirrelevance.
        intros φ₁ φ₂.
        use subtypePath ; [ intro ; apply cellset_property | ].
        pose (pr2 φ₁) as p₁.
        pose (pr2 φ₂) as p₂.
        cbn in p₁, p₂.
        rewrite vcomp_runitor in p₁, p₂.
        pose (p₁ @ !p₂) as r.
        use (vcomp_lcancel _ _ r).
        is_iso.
      + simple refine (σσ ,, _).
        cbn.
        rewrite vcomp_runitor.
        apply idpath.
        *)
  Defined.

  Definition trivial_lwhisker_cartesian
    : lwhisker_cartesian (trivial_displayed_bicat B₁ B₂).
  Proof.
    intros ? ? ? ? ? ? ? ? ? ? ? ? ? ? Hαα.
    apply trivial_invertible_is_cartesian_2cell.
    cbn.
    is_iso.
    apply trivial_cartesian_2cell_is_invertible.
    apply Hαα.
  Qed.

  Definition trivial_rwhisker_cartesian
    : rwhisker_cartesian (trivial_displayed_bicat B₁ B₂).
  Proof.
    intros ? ? ? ? ? ? ? ? ? ? ? ? ? ? Hαα.
    apply trivial_invertible_is_cartesian_2cell.
    cbn.
    is_iso.
    apply trivial_cartesian_2cell_is_invertible.
    apply Hαα.
  Qed.

  Definition trivial_fibration_of_bicats
    : fibration_of_bicats (trivial_displayed_bicat B₁ B₂).
  Proof.
    repeat split.
    - exact trivial_local_cleaving.
    - exact trivial_global_cleaving.
    - exact trivial_lwhisker_cartesian.
    - exact trivial_rwhisker_cartesian.
  Defined.
End ConstantFibration.

(**
The domain displayed bicategory is a fibration
 *)
Section DomainFibration.
  Context {B : bicat}
          (a : B).

  Definition dom_is_cartesian_2cell
             {c₁ c₂ : B}
             {s₁ s₂ : c₁ --> c₂}
             {α : s₁ ==> s₂}
             {t₁ : dom_disp_bicat B a c₁}
             {t₂ : dom_disp_bicat B a c₂}
             {ss₁ : t₁ -->[ s₁ ] t₂}
             {ss₂ : t₁ -->[ s₂ ] t₂}
             (αα : ss₁ ==>[ α ] ss₂)
    : is_cartesian_2cell (dom_disp_bicat B a) αα.
  Proof.
    intros s₃ ss₃ γ γα.
    use iscontraprop1.
    - use isaproptotal2.
      + intro ; apply (dom_disp_bicat B a).
      + intros.
        apply cellset_property.
    - simple refine (_ ,, _).
      + cbn in *.
        rewrite γα, αα.
        rewrite !vassocr.
        apply maponpaths_2.
        rewrite rwhisker_vcomp.
        apply idpath.
      + apply cellset_property.
  Qed.

  Definition dom_local_cleaving
    : local_cleaving (dom_disp_bicat B a).
  Proof.
    intros c₁ c₂ t₁ t₂ s₁ s₂ α β ; cbn in *.
    simple refine (_ ,, _) ; cbn.
    - exact ((β ▹ t₂) • α).
    - simple refine (idpath _ ,, _).
      apply dom_is_cartesian_2cell.
  Defined.

  Definition dom_invertible_2cell_is_cartesian_1cell
             {c₁ c₂ : B}
             {s : c₁ --> c₂}
             {t₁ : dom_disp_bicat B a c₁}
             {t₂ : dom_disp_bicat B a c₂}
             (ss : t₁ -->[ s ] t₂)
             (Hss : is_invertible_2cell ss)
    : cartesian_1cell (dom_disp_bicat B a) ss.
  Proof.
    simple refine (_ ,, _).
    - intros c₃ t₃ s' ss'.
      simple refine (_ ,, _).
      + exact ((s' ◃ Hss^-1) • lassociator _ _ _ • ss').
      + simple refine (_ ,, _).
        * abstract
            (cbn ;
             rewrite !vassocr ;
             apply maponpaths_2 ;
             rewrite id2_rwhisker ;
             etrans ;
               [ apply maponpaths_2 ;
                 rewrite !vassocl ;
                 rewrite lwhisker_vcomp ;
                 rewrite vcomp_rinv ;
                 rewrite lwhisker_id2 ;
                 apply id2_right
               | ] ;
             apply rassociator_lassociator).
        * apply dom_disp_locally_groupoid.
    - cbn.
      intros c₃ t₃ s₁ s₂ α αα β ββ ; cbn in *.
      use iscontraprop1.
      + abstract
          (use invproofirrelevance ;
           intros φ₁ φ₂ ;
           use subtypePath ; [ intro ; apply (dom_disp_bicat B a) | ] ;
           apply cellset_property).
      + cbn.
        simple  refine (_ ,, _).
        * abstract
            (rewrite ββ ;
             rewrite !vassocr ;
             apply maponpaths_2 ;
             rewrite vcomp_whisker ;
             rewrite !vassocl ;
             apply maponpaths ;
             rewrite rwhisker_rwhisker ;
             apply idpath).
        * apply cellset_property.
  Defined.

  Definition dom_cartesian_1cell_is_invertible_2cell
             {c₁ c₂ : B}
             {s : c₁ --> c₂}
             {t₁ : dom_disp_bicat B a c₁}
             {t₂ : dom_disp_bicat B a c₂}
             (ss : t₁ -->[ s ] t₂)
             (Hss : cartesian_1cell (dom_disp_bicat B a) ss)
    : is_invertible_2cell ss.
  Proof.
    cbn in *.
    pose (pr1 Hss c₁ (s · t₂) (id₁ _) (rassociator _ _ _ • lunitor _)) as p.
    unfold lift_1cell in p.
    cbn in p.
    pose (maponpaths (λ z, lassociator _ _ _ • z) (pr12 p)) as d.
    cbn in d.
    rewrite id2_rwhisker in d.
    rewrite id2_left in d.
    rewrite !vassocr in d.
    rewrite !lassociator_rassociator in d.
    rewrite !id2_left in d.
    use make_is_invertible_2cell.
    - exact (linvunitor _ • pr1 p).
    - rewrite !vassocr.
      rewrite linvunitor_natural.
      rewrite <- lwhisker_hcomp.
      rewrite !vassocl.
      rewrite d.
      rewrite linvunitor_lunitor.
      apply idpath.
    - pose (pr2 Hss).
      unfold lift_2cell in l.
      cbn in l.
      apply TODO.
  Qed.

  Definition dom_global_cleaving
    : global_cleaving (dom_disp_bicat B a).
  Proof.
    intros c₁ c₂ t₁ s.
    simple refine (s · t₁ ,, id₂ _ ,, _) ; cbn.
    apply dom_invertible_2cell_is_cartesian_1cell.
    is_iso.
  Defined.

  Definition dom_fibration_of_bicats
    : fibration_of_bicats (dom_disp_bicat B a).
  Proof.
    repeat split.
    - exact dom_local_cleaving.
    - exact dom_global_cleaving.
    - intro ; intros.
      apply dom_is_cartesian_2cell.
    - intro ; intros.
      apply dom_is_cartesian_2cell.
  Defined.
End DomainFibration.

(**
The codomain displayed bicategory is a fibration
Here we assume that every 2-cell is invertible
 *)
Section CodomainFibration.
  Context (B : bicat).

  Definition cod_invertible_is_cartesian_2cell
             {c₁ c₂ : B}
             {s₁ s₂ : c₁ --> c₂}
             {α : s₁ ==> s₂}
             {t₁ : cod_disp_bicat B c₁}
             {t₂ : cod_disp_bicat B c₂}
             {ss₁ : t₁ -->[ s₁ ] t₂}
             {ss₂ : t₁ -->[ s₂ ] t₂}
             (αα : ss₁ ==>[ α ] ss₂)
             (Hαα : is_invertible_2cell (pr1 αα))
    : is_cartesian_2cell (cod_disp_bicat B) αα.
  Proof.
    intros h hh γ γα.
    cbn in *.
    use iscontraprop1.
    - abstract
        (use invproofirrelevance ;
         intros φ₁ φ₂ ;
         use subtypePath ; [ intro ; apply (cod_disp_bicat B) | ] ;
         use subtypePath ; [ intro ; apply cellset_property | ] ;
         pose (maponpaths pr1 (pr2 φ₁)) as p₁ ;
         cbn in p₁ ;
         pose (maponpaths pr1 (pr2 φ₂)) as p₂ ;
         cbn in p₂ ;
         pose (r := p₁ @ !p₂) ;
         use (vcomp_rcancel _ Hαα) ;
         exact r).
    - simple refine ((_ ,, _) ,, _).
      + exact (pr1 γα • Hαα^-1).
      + abstract
          (cbn ;
           rewrite <- !rwhisker_vcomp ;
           rewrite !vassocr ;
           rewrite (pr2 γα) ;
           rewrite <- lwhisker_vcomp ;
           rewrite !vassocl ;
           apply maponpaths ;
           rewrite !vassocr ;
           rewrite <- (pr2 αα) ;
           rewrite !vassocl ;
           rewrite rwhisker_vcomp ;
           rewrite vcomp_rinv ;
           rewrite id2_rwhisker ;
           apply id2_right).
      + abstract
          (use subtypePath ; [ intro ; apply cellset_property | ] ;
           cbn ;
           rewrite !vassocl ;
           rewrite vcomp_linv ;
           apply id2_right).
  Defined.

  Context (inv_B : locally_groupoid B)
          (pb_B : has_pb B).

  Definition cod_local_cleaving
    : local_cleaving (cod_disp_bicat B).
  Proof.
    intros x y hx hy f g hf hg.
    simple refine (_ ,, _).
    - simple refine (pr1 hf ,, pr2 hx ◃ hg • pr12 hf ,, _).
      cbn.
      is_iso.
      + apply inv_B.
      + apply (pr22 hf).
    - simple refine (_ ,, _).
      + simple refine (id2 _ ,, _).
        abstract
          (cbn ;
           rewrite id2_rwhisker ;
           rewrite id2_right ;
           apply idpath).
      + simpl.
        apply cod_invertible_is_cartesian_2cell ; cbn.
        is_iso.
  Defined.

  Section PullbackToCartesian.
    Context {x y : B}
            {f : x --> y}
            {hx : cod_disp_bicat B x}
            {hy : cod_disp_bicat B y}
            (π : pr1 hx --> pr1 hy)
            (p : invertible_2cell (pr2 hx · f) (π · pr2 hy))
            (pb := make_pb_cone (pr1 hx) (pr2 hx) π p)
            (pb_sqr : has_pb_ump pb).

    (* split definition in parts *)
    Definition is_pb_to_cartesian_lift_1cell
               {z : B}
               {hz : cod_disp_bicat B z}
               {g : B ⟦ z, x ⟧}
               (hg : hz -->[ g · f] hy)
      : lift_1cell (cod_disp_bicat B) (π,, p) hg.
    Proof.
      (*
      pose (make_pb_cone
              (pr1 hz)
              (pr2 hz · g) (pr1 hg)
              (comp_of_invertible_2cell
                 (rassociator_invertible_2cell _ _ _)
                 (pr2 hg)))
        as r.
      pose (has_pb_ump_1 pb pb_sqr r) as mor.
       *)
      simple refine (_ ,, _).
      - cbn.
        simple refine (_ ,, _) ; cbn.
        + use (pb_ump_1_1cell pb pb_sqr) ; cbn.
          * exact (pr2 hz · g).
          * exact (pr1 hg).
          * exact (comp_of_invertible_2cell
                     (rassociator_invertible_2cell _ _ _)
                     (pr2 hg)).
        + use inv_of_invertible_2cell.
          apply (pb_ump_1_1cell_pr1 pb pb_sqr).
      - simple refine (_ ,, _).
        + simpl.
          simple refine (_ ,, _).
          * apply (pb_ump_1_1cell_pr2 pb pb_sqr).
          * (*cbn ;
               rewrite lwhisker_id2 ;
               rewrite id2_left ;
               rewrite !vassocl ;
               use vcomp_move_R_pM ; [ is_iso | ] ;
               use vcomp_move_R_pM ; [ is_iso | ] ;
               cbn.
               refine (maponpaths (λ z, _ • (z • _)) _ @ _).
               rewrite !vassocr ;
               rewrite rassociator_lassociator ;
               rewrite id2_left ;
               rewrite !vassocl ;
               apply maponpaths ;
               etrans ;
               [ do 2 apply maponpaths ;
                 rewrite !vassocr ;
                 rewrite rassociator_lassociator ;
                 apply id2_left
               | ] ;
               rewrite rwhisker_vcomp ;
               rewrite vcomp_linv ;
               rewrite id2_rwhisker ;
               rewrite id2_right ;
               apply idpath).*)
            apply TODO.
        + use is_disp_invertible_2cell_cod.
          apply (pb_ump_1_1cell_pr2 pb).
    Defined.

    Definition is_pb_to_cartesian_1cell
      : cartesian_1cell (cod_disp_bicat B) (π ,, p).
    Proof.
      simple refine (_ ,, _).
      - exact @is_pb_to_cartesian_lift_1cell.
      - intros z hz g₁ g₂ hg₁ hg₂ α αα.
        use iscontraprop1.
        + apply TODO.
        + simple refine (_ ,, _).
          * simple refine (_ ,, _).
            ** use (pb_ump_2_cell pb pb_sqr) ; cbn in *.
               *** exact (pr2 hz · g₁).
               *** exact (pr1 hg₁).
               *** exact (comp_of_invertible_2cell
                            (rassociator_invertible_2cell _ _ _)
                            (pr2 hg₁)).
               *** apply (pb_ump_1_1cell_pr1 pb pb_sqr).
               *** apply (pb_ump_1_1cell_pr2 pb pb_sqr).
               *** refine (comp_of_invertible_2cell
                             (pb_ump_1_1cell_pr1 pb pb_sqr _ _ _ _)
                             (lwhisker_of_invertible_2cell _ _)).
                   use inv_of_invertible_2cell.
                   use make_invertible_2cell.
                   **** exact α.
                   **** apply inv_B.
               *** refine (comp_of_invertible_2cell
                             (pb_ump_1_1cell_pr2 pb pb_sqr _ _ _ _)
                             _).
                   use inv_of_invertible_2cell.
                   use make_invertible_2cell.
                   **** exact (pr1 αα).
                   **** apply inv_B.
               *** apply TODO.
               *** apply TODO.
            ** apply TODO.
          * cbn.
            apply TODO.
               (*
               use (has_pb_ump_2
                      pb pb_sqr
                      (make_pb_cone
                         (pr1 hz) (pr2 hz · g₁) (pr1 hg₁)
                         (comp_of_invertible_2cell
                            (rassociator_invertible_2cell (pr2 hz) g₁ f)
                            (pr2 hg₁)))
                      (make_pb_1cell _ _ _ _)
                      (make_pb_1cell _ _ _ _)).
               *** refine (comp_of_invertible_2cell
                             (pb_1cell_pr1
                                (has_pb_ump_1
                                   pb pb_sqr
                                   (make_pb_cone
                                      (pr1 hz) (pr2 hz · g₂) (pr1 hg₂)
                                      (comp_of_invertible_2cell
                                         (rassociator_invertible_2cell (pr2 hz) g₂ f)
                                         (pr2 hg₂)))))
                             _) ; cbn.
                   use lwhisker_of_invertible_2cell.
                   exact (inv_of_invertible_2cell (make_invertible_2cell (inv_B _ _ _ _ α))).
               *** refine (comp_of_invertible_2cell
                             (pb_1cell_pr2
                                (has_pb_ump_1
                                   pb pb_sqr
                                   (make_pb_cone
                                      (pr1 hz) (pr2 hz · g₂) (pr1 hg₂)
                                      (comp_of_invertible_2cell
                                         (rassociator_invertible_2cell (pr2 hz) g₂ f)
                                         (pr2 hg₂)))))
                             _) ; cbn.
                   cbn in *.
                   exact (inv_of_invertible_2cell
                            (make_invertible_2cell (inv_B _ _ _ _ (pr1 αα)))).
                *)
    Defined.
  End PullbackToCartesian.

  Definition cod_global_cleaving
    : global_cleaving (cod_disp_bicat B).
  Proof.
    intros x y hx f ; cbn in *.
    pose (pb_B _ _ _ f (pr2 hx)) as pb.
    pose (pr1 pb) as pb₁.
    pose (pr2 pb) as pb₂.
    simple refine ((_ ,, _) ,, (_ ,, _) ,, _) ; cbn.
    - exact pb₁.
    - exact (pb_cone_pr1 pb₁).
    - exact (pb_cone_pr2 pb₁).
    - exact (pb_cone_cell pb₁).
    - refine (is_pb_to_cartesian_1cell _ _ _).
      exact pb₂.
  Defined.

  Definition cod_fibration_of_bicats
    : fibration_of_bicats (cod_disp_bicat B).
  Proof.
    repeat split.
    - exact cod_local_cleaving.
    - exact cod_global_cleaving.
    - intro ; intros.
      apply cod_invertible_is_cartesian_2cell.
      apply inv_B.
    - intro ; intros.
      apply cod_invertible_is_cartesian_2cell.
      apply inv_B.
  Defined.
End CodomainFibration.

Definition cod_fibration_one_types
  : fibration_of_bicats (cod_disp_bicat one_types).
Proof.
  use cod_fibration_of_bicats.
  - exact @one_type_2cell_iso.
  - exact has_pb_one_types.
Defined.

(**
Fibration of fibrations over categories
 *)


(*********************************************************************
 *********************************************************************
 *********************************************************************
 *********************************************************************
                             MOVE
 *********************************************************************
 *********************************************************************
 *********************************************************************
 *********************************************************************)
Section CartesianFactorisationDispNatTrans.
  Context {C₁ C₂ : category}
          {F₁ F₂ F₃ : C₁ ⟶ C₂}
          {α : F₂ ⟹ F₃}
          {β : F₁ ⟹ F₂}
          {D₁ : disp_cat C₁}
          {D₂ : disp_cat C₂}
          (HD₂ : cleaving D₂)
          {FF₁ : disp_functor F₁ D₁ D₂}
          {FF₂ : disp_functor F₂ D₁ D₂}
          {FF₃ : disp_functor F₃ D₁ D₂}
          (αα : disp_nat_trans α FF₂ FF₃)
          (ββ : disp_nat_trans (nat_trans_comp _ _ _ β α) FF₁ FF₃)
          (Hαα : ∏ (x : C₁) (xx : D₁ x), is_cartesian (αα x xx)).

  Definition cartesian_factorisation_disp_nat_trans_data
    : disp_nat_trans_data β FF₁ FF₂
    := λ x xx, cartesian_factorisation (Hαα x xx) (β x) (ββ x xx).

  Definition cartesian_factorisation_disp_nat_trans_axioms
    : disp_nat_trans_axioms cartesian_factorisation_disp_nat_trans_data.
  Proof.
    intros x y f xx yy ff ; cbn in *.
    unfold cartesian_factorisation_disp_nat_trans_data.
    use (cartesian_factorisation_unique (Hαα y yy)).
    rewrite assoc_disp_var.
    rewrite cartesian_factorisation_commutes.
    refine (maponpaths _ (disp_nat_trans_ax ββ ff) @ _).
    unfold transportb.
    rewrite !transport_f_f.
    rewrite mor_disp_transportf_postwhisker.
    rewrite assoc_disp_var.
    rewrite transport_f_f.
    refine (!_).
    etrans.
    {
      do 2 apply maponpaths.
      exact (disp_nat_trans_ax αα ff).
    }
    unfold transportb.
    rewrite mor_disp_transportf_prewhisker.
    rewrite transport_f_f.
    rewrite assoc_disp.
    unfold transportb.
    rewrite transport_f_f.
    rewrite cartesian_factorisation_commutes.
    apply maponpaths_2.
    apply homset_property.
  Qed.

  Definition cartesian_factorisation_disp_nat_trans
    : disp_nat_trans β FF₁ FF₂.
  Proof.
    simple refine (_ ,, _).
    - exact cartesian_factorisation_disp_nat_trans_data.
    - exact cartesian_factorisation_disp_nat_trans_axioms.
  Defined.
End CartesianFactorisationDispNatTrans.

Section CartesianFactorisationDispFunctor.
  Context {C₁ C₂ : category}
          {D₁ : disp_cat C₁}
          {D₂ : disp_cat C₂}
          (HD₁ : cleaving D₂)
          {F G : C₁ ⟶ C₂}
          (GG : disp_functor G D₁ D₂)
          (α : F ⟹ G).

  Definition cartesian_factorisation_disp_functor_data
    : disp_functor_data F D₁ D₂.
  Proof.
    simple refine (_ ,, _).
    - exact (λ x xx, pr1 (HD₁ (G x) (F x) (α x) (GG x xx))).
    - exact (λ x y xx yy f ff,
             cartesian_factorisation
               (pr22 (HD₁ (G y) (F y) (α y) (GG y yy)))
               _
               (transportb
                  (λ z, _ -->[ z ] _)
                  (nat_trans_ax α _ _ f)
                  (pr12 (HD₁ (G x) (F x) (α x) (GG x xx)) ;; #GG ff)%mor_disp)).
  Defined.

  Definition cartesian_factorisation_disp_functor_axioms
    : disp_functor_axioms cartesian_factorisation_disp_functor_data.
  Proof.
    repeat split.
    - intros x xx ; cbn.
      use (cartesian_factorisation_unique
             (pr22 (HD₁ (G x) (F x) (α x) (GG x xx)))).
      rewrite cartesian_factorisation_commutes.
      rewrite disp_functor_id.
      unfold transportb.
      rewrite mor_disp_transportf_prewhisker.
      rewrite transport_f_f.
      rewrite id_right_disp.
      unfold transportb.
      rewrite transport_f_f.
      rewrite mor_disp_transportf_postwhisker.
      rewrite id_left_disp.
      unfold transportb.
      rewrite transport_f_f.
      apply maponpaths_2.
      apply homset_property.
    - intros x y z xx yy zz f g ff hh ; cbn.
      use (cartesian_factorisation_unique
             (pr22 (HD₁ (G z) (F z) (α z) (GG z zz)))).
      unfold transportb.
      rewrite cartesian_factorisation_commutes.
      rewrite disp_functor_comp.
      unfold transportb.
      rewrite mor_disp_transportf_prewhisker.
      rewrite transport_f_f.
      rewrite mor_disp_transportf_postwhisker.
      rewrite assoc_disp_var.
      rewrite transport_f_f.
      rewrite cartesian_factorisation_commutes.
      rewrite mor_disp_transportf_prewhisker.
      rewrite transport_f_f.
      rewrite !assoc_disp.
      unfold transportb.
      rewrite transport_f_f.
      rewrite cartesian_factorisation_commutes.
      rewrite mor_disp_transportf_postwhisker.
      rewrite !transport_f_f.
      apply maponpaths_2.
      apply homset_property.
  Qed.

  Definition cartesian_factorisation_disp_functor
    : disp_functor F D₁ D₂.
  Proof.
    simple refine (_ ,, _).
    - exact cartesian_factorisation_disp_functor_data.
    - exact cartesian_factorisation_disp_functor_axioms.
  Defined.

  Definition cartesian_factorisation_disp_functor_is_cartesian
             (HGG : is_cartesian_disp_functor GG)
    : is_cartesian_disp_functor cartesian_factorisation_disp_functor.
  Proof.
    intros x y f xx yy ff Hff ; cbn.
    pose (HGff := HGG _ _ _ _ _ _ Hff).
    refine (is_cartesian_precomp
              (idpath _)
              _
              (pr22 (HD₁ (G x) (F x) (α x) (GG x xx)))
              (is_cartesian_transportf
                 (!(nat_trans_ax α _ _ f))
                 (is_cartesian_comp_disp
                    (pr22 (HD₁ (G y) (F y) (α y) (GG y yy)))
                    HGff))).
    rewrite cartesian_factorisation_commutes.
    apply idpath.
  Qed.

  Definition cartesian_factorisation_disp_functor_cell_data
    : disp_nat_trans_data α cartesian_factorisation_disp_functor_data GG
    := λ x xx, pr12 (HD₁ (G x) (F x) (α x) (GG x xx)).

  Definition cartesian_factorisation_disp_functor_cell_axioms
    : disp_nat_trans_axioms cartesian_factorisation_disp_functor_cell_data.
  Proof.
    intros x y f xx yy ff ; cbn ; unfold cartesian_factorisation_disp_functor_cell_data.
    unfold transportb.
    rewrite cartesian_factorisation_commutes.
    apply idpath.
  Qed.

  Definition cartesian_factorisation_disp_functor_cell
    : disp_nat_trans
        α
        cartesian_factorisation_disp_functor_data
        GG.
  Proof.
    simple refine (_ ,, _).
    - exact cartesian_factorisation_disp_functor_cell_data.
    - exact cartesian_factorisation_disp_functor_cell_axioms.
  Defined.

  Definition cartesian_factorisation_disp_functor_cell_is_cartesian
             {x : C₁}
             (xx : D₁ x)
    : is_cartesian (cartesian_factorisation_disp_functor_cell x xx).
  Proof.
    exact (pr22 (HD₁ (G x) (F x) (α x) (GG x xx))).
  Defined.
End CartesianFactorisationDispFunctor.


Definition transportf_reindex
           {C' C : category}
           {D : disp_cat C}
           {F : C' ⟶ C}
           {x y : C'}
           {xx : D(F x)} {yy : D(F y)}
           {f g : x --> y}
           (p : f = g)
           (ff : xx -->[ (# F)%Cat f] yy)
  : transportf
      (@mor_disp
         C'
         (reindex_disp_cat F D)
         _ _
         xx yy)
      p
      ff
    =
    transportf
      (@mor_disp
         C
         D
         _ _
         xx yy)
      (maponpaths (#F)%Cat p)
      ff.
Proof.
  induction p ; apply idpath.
Qed.

Definition iso_disp_to_iso_disp_reindex
           {C₁ C₂ : category}
           {F : C₁ ⟶ C₂}
           {D : disp_cat C₂}
           {x : C₁}
           {xx yy : D (F x)}
  : iso_disp (identity_iso (F x)) xx yy
    →
    @iso_disp
       _
       (reindex_disp_cat F D)
       _
       _
       (identity_iso x)
       xx
       yy.
Proof.
  intros i.
  use make_iso_disp.
  - exact (transportb
             (λ z, _ -->[ z ] _)
             (functor_id _ _)
             i).
  - simple refine (_ ,, _ ,, _).
    + exact (transportb
               (λ z, _ -->[ z ] _)
               (functor_id _ _)
               (inv_mor_disp_from_iso i)).
    + abstract
        (cbn ;
         unfold transportb ;
         rewrite mor_disp_transportf_prewhisker ;
         rewrite transport_f_f ;
         rewrite mor_disp_transportf_postwhisker ;
         rewrite transport_f_f ;
         refine (maponpaths (λ z, transportf _ _ z) (iso_disp_after_inv_mor i) @ _) ;
         unfold transportb ;
         rewrite !transport_f_f ;
         refine (!_) ;
         etrans ; [ apply transportf_reindex | ] ;
         rewrite transport_f_f ;
         apply maponpaths_2 ;
         apply homset_property).
    + abstract
        (cbn ;
         unfold transportb ;
         rewrite mor_disp_transportf_prewhisker ;
         rewrite transport_f_f ;
         rewrite mor_disp_transportf_postwhisker ;
         rewrite transport_f_f ;
         refine (maponpaths (λ z, transportf _ _ z) (inv_mor_after_iso_disp i) @ _) ;
         unfold transportb ;
         rewrite !transport_f_f ;
         refine (!_) ;
         etrans ; [ apply transportf_reindex | ] ;
         rewrite transport_f_f ;
         apply maponpaths_2 ;
         apply homset_property).
Defined.

Definition iso_disp_reindex_to_iso_disp
           {C₁ C₂ : category}
           {F : C₁ ⟶ C₂}
           {D : disp_cat C₂}
           {x : C₁}
           {xx yy : D (F x)}
  : @iso_disp
       _
       (reindex_disp_cat F D)
       _
       _
       (identity_iso x)
       xx
       yy
    →
    iso_disp (identity_iso (F x)) xx yy.
Proof.
  intros i.
  use make_iso_disp.
  - exact (transportf
               (λ z, _ -->[ z ] _)
               (functor_id _ _)
               i).
  - simple refine (_ ,, _ ,, _).
    + exact (transportf
               (λ z, _ -->[ z ] _)
               (functor_id _ _)
               (inv_mor_disp_from_iso i)).
    + abstract
        (unfold transportb ;
         rewrite mor_disp_transportf_prewhisker ;
         rewrite mor_disp_transportf_postwhisker ;
         rewrite !transport_f_f ;
         etrans ;
         [ apply maponpaths ;
           pose (iso_disp_after_inv_mor i) as p ;
           cbn in p ;
           exact (transportf_transpose_right p)
         | ] ;
         unfold transportb ;
         rewrite !transport_f_f ;
         etrans ;
         [ apply maponpaths ;
           apply transportf_reindex
         | ] ;
         rewrite !transport_f_f ;
         apply maponpaths_2 ;
         apply homset_property).
    + abstract
        (unfold transportb ;
         rewrite mor_disp_transportf_prewhisker ;
         rewrite mor_disp_transportf_postwhisker ;
         rewrite !transport_f_f ;
         etrans ;
         [ apply maponpaths ;
           pose (inv_mor_after_iso_disp i) as p ;
           cbn in p ;
           exact (transportf_transpose_right p)
         | ] ;
         unfold transportb ;
         rewrite !transport_f_f ;
         etrans ;
         [ apply maponpaths ;
           apply transportf_reindex
         | ] ;
         rewrite !transport_f_f ;
         apply maponpaths_2 ;
         apply homset_property).
Defined.

Definition iso_disp_weq_iso_disp_reindex
           {C₁ C₂ : category}
           {F : C₁ ⟶ C₂}
           {D : disp_cat C₂}
           {x : C₁}
           (xx yy : D (F x))
  : iso_disp (identity_iso (F x)) xx yy
    ≃
    @iso_disp
       _
       (reindex_disp_cat F D)
       _
       _
       (identity_iso x)
       xx
       yy.
Proof.
  use make_weq.
  - exact iso_disp_to_iso_disp_reindex.
  - use gradth.
    + exact iso_disp_reindex_to_iso_disp.
    + abstract
        (intros i ;
         use subtypePath ; [ intro ; apply isaprop_is_iso_disp | ] ;
         cbn ;
         apply transportfbinv).
    + abstract
        (intros i ;
         use subtypePath ; [ intro ; apply isaprop_is_iso_disp | ] ;
         cbn ;
         apply transportbfinv).
Defined.

Definition is_univalent_reindex_disp_cat
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
           (HD : is_univalent_disp D)
  : is_univalent_disp (reindex_disp_cat F D).
Proof.
  intros x y p xx yy.
  induction p.
  use weqhomot.
  - exact (iso_disp_weq_iso_disp_reindex xx yy
           ∘ make_weq
               (@idtoiso_disp _ D _ _ (idpath _) xx yy)
               (HD _ _ _ xx yy))%weq.
  - abstract
      (intros p ;
       induction p ;
       use subtypePath ; [ intro ; apply isaprop_is_iso_disp | ] ;
       apply idpath).
Defined.

Definition is_cartesian_in_reindex_disp_cat
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
           {x y : C₁}
           {f : x --> y}
           {xx : D (F x)}
           {yy : D (F y)}
           (ff : xx -->[ #F f ] yy)
           (Hff : is_cartesian ff)
  : @is_cartesian _ (reindex_disp_cat F D) y x f yy xx ff.
Proof.
  intros z g zz gg ; cbn in *.
  use iscontraprop1.
  - abstract
      (use invproofirrelevance ;
       intros φ₁ φ₂ ;
       use subtypePath ; [ intro ; apply D | ] ;
       use (cartesian_factorisation_unique Hff) ;
       rewrite (transportf_transpose_right (pr2 φ₁)) ;
       rewrite (transportf_transpose_right (pr2 φ₂)) ;
       apply idpath).
  - simple refine (_ ,, _).
    + refine (cartesian_factorisation
                Hff
                (#F g)
                (transportf (λ z, _ -->[ z ] _) _ gg)).
      abstract
        (apply functor_comp).
    + abstract
        (cbn ;
         rewrite cartesian_factorisation_commutes ;
         unfold transportb ;
         rewrite transport_f_f ;
         apply transportf_set ;
         apply homset_property).
Defined.

(*
Definition is_cartesian_from_reindex_disp_cat
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
           {x y : C₁}
           {f : x --> y}
           {xx : D (F x)}
           {yy : D (F y)}
           (ff : xx -->[ #F f ] yy)
           (Hff : @is_cartesian _ (reindex_disp_cat F D) y x f yy xx ff)
  : is_cartesian ff.
Proof.
  intros z g zz gg ; cbn in *.
  use iscontraprop1.
  - apply TODO.
    (*abstract
      (use invproofirrelevance ;
       intros φ₁ φ₂ ;
       use subtypePath ; [ intro ; apply D | ] ;
       use (cartesian_factorisation_unique Hff) ;
       rewrite (transportf_transpose_right (pr2 φ₁)) ;
       rewrite (transportf_transpose_right (pr2 φ₂)) ;
       apply idpath).
     *)
  - simple refine (_ ,, _).
    + cbn in *.
      pose (@cartesian_factorisation _ _ _ _ _ _ _ _ Hff).
      cbn in m.
      cbn.
      refine (cartesian_factorisation
                Hff
                (#F g)
                (transportf (λ z, _ -->[ z ] _) _ gg)).
      abstract
        (apply functor_comp).
    + abstract
        (cbn ;
         rewrite cartesian_factorisation_commutes ;
         unfold transportb ;
         rewrite transport_f_f ;
         apply transportf_set ;
         apply homset_property).
  apply TODO.
Defined.
 *)


Definition cleaving_reindex_disp_cat
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
           (HD : cleaving D)
  : cleaving (reindex_disp_cat F D).
Proof.
  intros x y f d.
  pose (HD (F x) (F y) (#F f) d) as lift.
  simple refine (_ ,, (_ ,, _)).
  - exact (pr1 lift).
  - exact (pr12 lift).
  - simpl.
    apply is_cartesian_in_reindex_disp_cat.
    exact (pr22 lift).
Defined.


Definition reindex_disp_cat_disp_functor_data
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
  : disp_functor_data F (reindex_disp_cat F D) D.
Proof.
  simple refine (_ ,, _).
  - exact (λ _ xx, xx).
  - exact (λ _ _ _ _ _ ff, ff).
Defined.

Definition reindex_disp_cat_disp_functor_axioms
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
  : disp_functor_axioms (reindex_disp_cat_disp_functor_data F D).
Proof.
  split ; cbn ; intros ; apply idpath.
Qed.

Definition reindex_disp_cat_disp_functor
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
  : disp_functor F (reindex_disp_cat F D) D.
Proof.
  simple refine (_ ,, _).
  - exact (reindex_disp_cat_disp_functor_data F D).
  - exact (reindex_disp_cat_disp_functor_axioms F D).
Defined.

Definition is_cartesian_reindex_disp_cat_disp_functor
           {C₁ C₂ : category}
           (F : C₁ ⟶ C₂)
           (D : disp_cat C₂)
  : is_cartesian_disp_functor (reindex_disp_cat_disp_functor F D).
Proof.
  intros x y f xx yy ff Hff.
  cbn.
  intro ; intros.
  unfold is_cartesian in Hff.
  cbn in Hff.

  (*
  apply is_cartesian_from_reindex_disp_cat.
  exact Hff.
   *)
  apply TODO.
Defined.

Definition lift_functor_into_reindex_data
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           (FF : disp_functor (F₁ ∙ F₂) D₁ D₃)
  : disp_functor_data F₁ D₁ (reindex_disp_cat F₂ D₃).
Proof.
  simple refine (_ ,, _).
  - exact (λ x xx, FF x xx).
  - exact (λ x y xx yy f ff, #FF ff)%mor_disp.
Defined.

Definition lift_functor_into_reindex_axioms
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           (FF : disp_functor (F₁ ∙ F₂) D₁ D₃)
  : disp_functor_axioms (lift_functor_into_reindex_data FF).
Proof.
  split.
  - intros x xx ; cbn.
    unfold transportb.
    refine (!_).
    etrans.
    {
      apply transportf_reindex.
    }
    rewrite transport_f_f.
    refine (!_).
    rewrite (disp_functor_id FF).
    unfold transportb.
    apply maponpaths_2.
    apply homset_property.
  - intros x y z xx yy zz f g ff gg ; cbn.
    unfold transportb.
    refine (!_).
    etrans.
    {
      apply transportf_reindex.
    }
    rewrite transport_f_f.
    rewrite (disp_functor_comp FF).
    unfold transportb.
    apply maponpaths_2.
    apply homset_property.
Qed.

Definition lift_functor_into_reindex
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           (FF : disp_functor (F₁ ∙ F₂) D₁ D₃)
  : disp_functor F₁ D₁ (reindex_disp_cat F₂ D₃).
Proof.
  simple refine (_ ,, _).
  - exact (lift_functor_into_reindex_data FF).
  - exact (lift_functor_into_reindex_axioms FF).
Defined.

Definition is_cartesian_lift_functor_into_reindex
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           {FF : disp_functor (F₁ ∙ F₂) D₁ D₃}
           (HFF : is_cartesian_disp_functor FF)
  : is_cartesian_disp_functor (lift_functor_into_reindex FF).
Proof.
  intros x y f xx yy ff Hff.
  apply is_cartesian_in_reindex_disp_cat.
  apply HFF.
  exact Hff.
Defined.

Definition lift_functor_into_reindex_commute_data
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           (FF : disp_functor (F₁ ∙ F₂) D₁ D₃)
  : disp_nat_trans_data
      (nat_trans_id _)
      (disp_functor_composite
         (lift_functor_into_reindex FF)
         (reindex_disp_cat_disp_functor _ _))
      FF
  := λ x xx, id_disp _.

Definition lift_functor_into_reindex_commute_axioms
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           (FF : disp_functor (F₁ ∙ F₂) D₁ D₃)
  : disp_nat_trans_axioms (lift_functor_into_reindex_commute_data FF).
Proof.
  intros x y f xx yy ff ; unfold lift_functor_into_reindex_commute_data ; cbn.
  rewrite id_left_disp, id_right_disp.
  unfold transportb.
  rewrite transport_f_f.
  apply maponpaths_2.
  apply homset_property.
Qed.

Definition lift_functor_into_reindex_commute
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ : C₁ ⟶ C₂}
           {F₂ : C₂ ⟶ C₃}
           (FF : disp_functor (F₁ ∙ F₂) D₁ D₃)
  : disp_nat_trans
      (nat_trans_id _)
      (disp_functor_composite
         (lift_functor_into_reindex FF)
         (reindex_disp_cat_disp_functor _ _))
      FF.
Proof.
  simple refine (_ ,, _).
  - exact (lift_functor_into_reindex_commute_data FF).
  - exact (lift_functor_into_reindex_commute_axioms FF).
Defined.

Definition lift_functor_into_reindex_disp_nat_trans_data
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ F₁' : C₁ ⟶ C₂}
           {α : F₁ ⟹ F₁'}
           {F₂ : C₂ ⟶ C₃}
           {FF₁ : disp_functor (F₁ ∙ F₂) D₁ D₃}
           {FF₂ : disp_functor (F₁' ∙ F₂) D₁ D₃}
           (αα : disp_nat_trans (post_whisker α _) FF₁ FF₂)
  : disp_nat_trans_data
      α
      (lift_functor_into_reindex_data FF₁)
      (lift_functor_into_reindex_data FF₂)
  := λ x xx, αα x xx.

Definition lift_functor_into_reindex_disp_nat_trans_axioms
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ F₁' : C₁ ⟶ C₂}
           {α : F₁ ⟹ F₁'}
           {F₂ : C₂ ⟶ C₃}
           {FF₁ : disp_functor (F₁ ∙ F₂) D₁ D₃}
           {FF₂ : disp_functor (F₁' ∙ F₂) D₁ D₃}
           (αα : disp_nat_trans (post_whisker α _) FF₁ FF₂)
  : disp_nat_trans_axioms (lift_functor_into_reindex_disp_nat_trans_data αα).
Proof.
  intros x y f xx yy ff ; cbn ; unfold lift_functor_into_reindex_disp_nat_trans_data.
  etrans.
  {
    apply maponpaths.
    exact (disp_nat_trans_ax αα ff).
  }
  unfold transportb.
  rewrite !transport_f_f.
  refine (!_).
  etrans.
  {
    apply transportf_reindex.
  }
  rewrite transport_f_f.
  apply maponpaths_2.
  apply homset_property.
Qed.

Definition lift_functor_into_reindex_disp_nat_trans
           {C₁ C₂ C₃ : category}
           {D₁ : disp_cat C₁}
           {D₃ : disp_cat C₃}
           {F₁ F₁' : C₁ ⟶ C₂}
           {α : F₁ ⟹ F₁'}
           {F₂ : C₂ ⟶ C₃}
           {FF₁ : disp_functor (F₁ ∙ F₂) D₁ D₃}
           {FF₂ : disp_functor (F₁' ∙ F₂) D₁ D₃}
           (αα : disp_nat_trans (post_whisker α _) FF₁ FF₂)
  : disp_nat_trans
      α
      (lift_functor_into_reindex_data FF₁)
      (lift_functor_into_reindex_data FF₂).
Proof.
  simple refine (_ ,, _).
  - exact (lift_functor_into_reindex_disp_nat_trans_data αα).
  - exact (lift_functor_into_reindex_disp_nat_trans_axioms αα).
Defined.

(*********************************************************************
 *********************************************************************
 *********************************************************************
 *********************************************************************
                             END MOVE
 *********************************************************************
 *********************************************************************
 *********************************************************************
 *********************************************************************)




Definition fib_of_fibs_is_cartesian_2cell
           {C₁ C₂ : bicat_of_cats}
           {F₁ F₂ : C₁ --> C₂}
           {α : F₁ ==> F₂}
           {D₁ : DispBicatOfFibs C₁}
           {D₂ : DispBicatOfFibs C₂}
           {FF₁ : D₁ -->[ F₁ ] D₂}
           {FF₂ : D₁ -->[ F₂ ] D₂}
           (αα : FF₁ ==>[ α ] FF₂)
           (Hαα : ∏ (x : (C₁ : univalent_category))
                    (xx : (pr1 D₁ : disp_cat _) x),
                  is_cartesian (pr11 αα x xx))
  : is_cartesian_2cell DispBicatOfFibs αα.
Proof.
  intros G GG β βα.
  use iscontraprop1.
  - abstract
      (use invproofirrelevance ;
       intros φ₁ φ₂ ;
       use subtypePath ; [ intro ; apply DispBicatOfFibs | ] ;
       use subtypePath ; [ intro ; apply isapropunit | ] ;
       use disp_nat_trans_eq ;
       intros x xx ;
       assert (p₁ := maponpaths (λ z, (pr11 z) x xx) (pr2 φ₁)) ;
       assert (p₂ := maponpaths (λ z, (pr11 z) x xx) (pr2 φ₂)) ;
       cbn in p₁, p₂ ;
       pose (r := p₁ @ !p₂) ;
       use (cartesian_factorisation_unique (Hαα x xx)) ;
       exact r).
  - simple refine ((_ ,, tt) ,, _).
    + exact (cartesian_factorisation_disp_nat_trans (pr1 αα) (pr1 βα) Hαα).
    + abstract
        (use subtypePath ; [ intro ; apply isapropunit | ] ;
         use subtypePath ; [ intro ; apply isaprop_disp_nat_trans_axioms| ] ;
         use funextsec ; intro x ;
         use funextsec ; intro xx ;
         apply cartesian_factorisation_commutes).
Defined.

Definition fib_of_fibs_cartesian_2cell_is_pointwise_cartesian
           {C₁ C₂ : bicat_of_cats}
           {F₁ F₂ : C₁ --> C₂}
           {α : F₁ ==> F₂}
           {D₁ : DispBicatOfFibs C₁}
           {D₂ : DispBicatOfFibs C₂}
           {FF₁ : D₁ -->[ F₁ ] D₂}
           {FF₂ : D₁ -->[ F₂ ] D₂}
           (αα : FF₁ ==>[ α ] FF₂)
           (Hαα : is_cartesian_2cell DispBicatOfFibs αα)
           (x : (C₁ : univalent_category))
           (xx : (pr1 D₁ : disp_cat _) x)
  : is_cartesian (pr11 αα x xx).
Proof.
  intros z g zz gg.
  unfold is_cartesian_2cell in Hαα.
  cbn in Hαα.
  (*
  cbn in *.
  pose (Hαα (constant_functor C₁ C₂ z)) as i.
  cbn in i.
  assert (disp_functor (constant_functor C₁ C₂ z) (pr1 D₁) (pr1 D₂)).
  {
    use tpair.
    - simple refine ((λ _ _, zz) ,, (λ _ _ _ _ _ _, _)).
      exact (id_disp zz).
    - apply TODO.
  }
  specialize (i (X ,, TODO)).
  cbn.
  cbn in i.
   *)
  apply TODO.
Defined.

Definition fib_of_fibs_local_cleaving
  : local_cleaving DispBicatOfFibs.
Proof.
  intros C₁ C₂ D₁ D₂ F G GG α.
  cbn in *.
  simple refine (_ ,, _).
  - simple refine (_ ,, _).
    + exact (cartesian_factorisation_disp_functor (pr22 D₂) (pr1 GG) α).
    + apply cartesian_factorisation_disp_functor_is_cartesian.
      exact (pr2 GG).
  - simpl.
    simple refine ((_ ,, tt) ,, _).
    + exact (cartesian_factorisation_disp_functor_cell (pr22 D₂) (pr1 GG) α).
    + apply fib_of_fibs_is_cartesian_2cell.
      apply cartesian_factorisation_disp_functor_cell_is_cartesian.
Defined.

Definition fib_of_fibs_lwhisker_cartesian
  : lwhisker_cartesian DispBicatOfFibs.
Proof.
  intros C₁ C₂ C₃ D₁ D₂ D₃ H F G HH FF GG α αα Hαα.
  apply fib_of_fibs_is_cartesian_2cell.
  intros x xx ; cbn.
  apply (fib_of_fibs_cartesian_2cell_is_pointwise_cartesian _ Hαα).
Defined.

Definition fib_of_fibs_rwhisker_cartesian
  : rwhisker_cartesian DispBicatOfFibs.
Proof.
  intros C₁ C₂ C₃ D₁ D₂ D₃ H F G HH FF GG α αα Hαα.
  apply fib_of_fibs_is_cartesian_2cell.
  intros x xx ; cbn.
  pose (pr2 GG) as m.
  cbn in m.
  apply m.
  apply (fib_of_fibs_cartesian_2cell_is_pointwise_cartesian _ Hαα).
Defined.

Definition fib_of_fibs_lift_obj
           {C₁ C₂ : bicat_of_cats}
           (D₂ : DispBicatOfFibs C₂)
           (F : C₁ --> C₂)
  : DispBicatOfFibs C₁.
Proof.
  simple refine (reindex_disp_cat F (pr1 D₂) ,, _ ,, _) ; cbn.
  - exact (is_univalent_reindex_disp_cat F _ (pr12 D₂)).
  - exact (cleaving_reindex_disp_cat F (pr1 D₂) (pr22 D₂)).
Defined.

Definition fib_of_fibs_lift_mor
           {C₁ C₂ : bicat_of_cats}
           (D₂ : DispBicatOfFibs C₂)
           (F : C₁ --> C₂)
  : fib_of_fibs_lift_obj D₂ F -->[ F ] D₂.
Proof.
  simple refine (_ ,, _).
  - exact (reindex_disp_cat_disp_functor F (pr1 D₂)).
  - exact (is_cartesian_reindex_disp_cat_disp_functor F (pr1 D₂)).
Defined.

Definition fib_of_fibs_lift_mor_lift_1cell
           {C₁ C₂ C₃ : bicat_of_cats}
           {D₂ : DispBicatOfFibs C₂}
           {D₃ : DispBicatOfFibs C₃}
           {F : C₁ --> C₂}
           {H : C₃ --> C₁}
           (HH : D₃ -->[ H · F] D₂)
  : lift_1cell DispBicatOfFibs (fib_of_fibs_lift_mor D₂ F) HH.
Proof.
  simple refine (_ ,, _).
  - simple refine (_ ,, _).
    + exact (lift_functor_into_reindex (pr1 HH)).
    + exact (is_cartesian_lift_functor_into_reindex (pr2 HH)).
  - simple refine ((_ ,, tt) ,, _).
    + exact (lift_functor_into_reindex_commute (pr1 HH)).
    + apply DispBicatOfFibs_is_disp_invertible_2cell.
      intros x xx.
      apply id_is_iso_disp.
Defined.

Definition fib_of_fibs_lift_mor_lift_2cell
           {C₁ C₂ C₃ : bicat_of_cats}
           {F : C₁ --> C₂}
           {H₁ H₂ : C₃ --> C₁}
           {α : H₁ ==> H₂}
           {D₂ : DispBicatOfFibs C₂}
           {D₃ : DispBicatOfFibs C₃}
           {HH₁ : D₃ -->[ H₁ · F] D₂}
           {HH₂ : D₃ -->[ H₂ · F] D₂}
           (αα : HH₁ ==>[ α ▹ F] HH₂)
  : lift_2cell
      DispBicatOfFibs
      (fib_of_fibs_lift_mor D₂ F)
      αα
      (fib_of_fibs_lift_mor_lift_1cell HH₁)
      (fib_of_fibs_lift_mor_lift_1cell HH₂).
Proof.
  use iscontraprop1.
  - apply TODO.
  - simple refine ((_ ,, tt) ,, _).
    + exact (lift_functor_into_reindex_disp_nat_trans (pr1 αα)).
    + (*cbn.
      use subtypePath ; [ intro ; apply isapropunit | ].
      use disp_nat_trans_eq.
      intros x xx.
      cbn.
      rewrite pr1_transportf.
      cbn.
      unfold lift_functor_into_reindex_commute_data, lift_functor_into_reindex_commute.
      cbn.*)
      apply TODO.
Defined.

Definition fib_of_fibs_lift_mor_cartesian
           {C₁ C₂ : bicat_of_cats}
           (D₂ : DispBicatOfFibs C₂)
           (F : C₁ --> C₂)
  : cartesian_1cell DispBicatOfFibs (fib_of_fibs_lift_mor D₂ F).
Proof.
  simple refine (_ ,, _).
  - intros C₃ D₃ H HH.
    exact (fib_of_fibs_lift_mor_lift_1cell HH).
  - intros C₃ D₃ H₁ H₂ HH₁ HH₂ α αα.
    exact (fib_of_fibs_lift_mor_lift_2cell αα).
Defined.

Definition fib_of_fibs_global_cleaving
  : global_cleaving DispBicatOfFibs.
Proof.
  intros C₁ C₂ D₂ F.
  simple refine (_ ,, _ ,, _).
  - exact (fib_of_fibs_lift_obj D₂ F).
  - exact (fib_of_fibs_lift_mor D₂ F).
  - exact (fib_of_fibs_lift_mor_cartesian D₂ F).
Defined.

Definition fib_of_fibs
  : fibration_of_bicats DispBicatOfFibs.
Proof.
  repeat split.
  - exact fib_of_fibs_local_cleaving.
  - exact fib_of_fibs_global_cleaving.
  - exact fib_of_fibs_lwhisker_cartesian.
  - exact fib_of_fibs_rwhisker_cartesian.
Defined.
