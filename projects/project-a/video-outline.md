# Video outline — "Thermal Conductivity on Demand: AI-Designed Defect Populations"

**Status:** draft outline for review (2026-09-15), built on
`lit-review/defect-representations-deep-dive.md` and `lit-review/refinement-searches.md`.
The next step after sign-off is expanding each beat into full narration in `script.md`.

**Submission target:** Strategic Systems topic area, shopping notice DARPA-SN-26-103
(Thermal Management, window closes **Sept 30, 2026** — see timing decision, bottom).
Video title on the form: `DARPA-SN-26-103: Thermal Conductivity on Demand — AI-Designed
Defect Populations` (94 characters, under the 128 limit).

**Format constraints (from `eris/eris-notes.md`):** 7:00 max, 1280x720 .mp4 under 1 GB,
four required elements in order, no proprietary/export-controlled/CUI content. Budget
about 900 narrated words at 130 wpm; the plan below allocates about 880.

**Through-line (one sentence):** experiments have already proven that defects can
*program* a material's thermal conductivity — what's missing is the ability to *design*
them, and we are building the missing design layer: the first charge-aware, transferable
AI representation of defects, closed against real thermal measurements.

---

## Beat sheet

Time budget per beat, narration word target in parentheses (about 130 wpm).

### Cold open — 0:00-0:35 (75 words)

| Beat | Narration content | On-screen |
|---|---|---|
| Hook | Every DoD system that overheats — hypersonic leading edge, laser diode, satellite avionics — is limited by a materials number: thermal conductivity. And that number is set by *defects*: missing atoms, dopants, radiation damage. Researchers have tuned thermal conductivity more than five-fold just by controlling vacancies, and written thermal circuits into a nanowire with an ion beam. Defects can program heat flow. Nobody can design them. Yet. | Thermal-camera b-roll of hot electronics; animation of a crystal lattice where removing atoms visibly chokes a heat-flow arrow. Title card. |

Evidence behind the hook: >5x reversible tuning in LSCO (Nat. Commun. 2023,
CorpusId 257771454); ion-dose-programmed Si nanowire and thermal cloak (Nat. Commun.
2017, CorpusId 20742011).

### Element 1 — Problem and current state of the art — 0:35-2:05 (195 words)

| Beat | Narration content | On-screen |
|---|---|---|
| 1a. The DoD problem (0:35-1:05) | Thermal limits gate the envelopes SN-26-103 names: hypersonics, space platforms, directed energy, edge computing. The best thermal materials — diamond, AlN, UHTCs — lose their conductivity to the defects that processing, oxidation, and radiation put in; thermal barriers and switches depend on defects we place on purpose. Today both directions are trial-and-error: defect effects are discovered empirically, one alloy at a time. | Quad of application images; measured-kappa-vs-defect-density curve (e.g., AlN literature data). |
| 1b. Why AI hasn't fixed it (1:05-1:45) | State of the art: AI for materials is built on *pristine* crystals. There is no standard machine-readable representation of a defect. Best-in-class graph networks hit 0.15 eV on defects they trained on — and 2 to 3 eV, twenty times worse, on chemistries they haven't seen. Universal "foundation" potentials systematically soften defect physics and can't tell charge states apart at all. | Simple bar chart: in-domain 0.15 eV vs zero-shot 2.2-3.0 eV (APL Mach. Learn. 2023); "no standard, no benchmark" callout. |
| 1c. The verified gap (1:45-2:05) | And no framework exists that goes end-to-end — processing conditions in, thermal conductivity out. Predictions get validated against measurement only in one-off, post-hoc campaigns on single materials. The representation gap is the bottleneck — not compute, not models. | White-space graphic: filled boxes (defect DFT, phonon codes, one-off validations) around an empty center box labeled "transferable defect -> kappa design loop". |

Evidence: transfer collapse (CorpusId 261696474); foundation-potential softening
(269757150) and charge failures (286256203); white space verified by Asta turn 4 (only
partial prior art: ThO2 235507809, TaFeSb 274777007); one-off validation exemplars from
turn 5 (278171299, 274788456).

### Element 2 — Advancing the state of the art — 2:05-4:15 (280 words)

| Beat | Narration content | On-screen |
|---|---|---|
| 2a. The insight (2:05-2:45) | Our advance starts with representation, grounded in two literature-backed design principles. First: represent the defect, not the crystal — encode every defect as an explicit *difference from its pristine host*, so the model learns the localized perturbation instead of relearning each host from scratch. That is what collapses today's transfer failures. Second: condition explicitly on charge state — identical atomic positions carry different energies and different phonons per charge state, so structure-only models *provably cannot* get defect physics right. | Split animation: full supercell (tangled) vs delta-to-pristine pair (clean); charge-state ladder showing one geometry, three energy surfaces. |
| 2b. The pipeline (2:45-3:30) | We chain that representation into the first end-to-end design loop: predict *which* defects form under given processing conditions; predict how those defects scatter phonons; predict thermal conductivity. Then close the loop physically — synthesize the designed defect populations, measure thermal conductivity by laser flash in our lab, and feed misses back into the model. Processing in, measured thermal conductivity out. Nobody has built this loop. | Pipeline diagram with four blocks (representation -> defect thermodynamics -> phonon scattering -> kappa) wrapped by a synthesize/measure/update arrow through a photo of the LFA 457. |
| 2c. Falsifiable targets (3:30-4:15) | We hold ourselves to numbers, per the notice's demand for physics-based evidence. Trained on five host chemistries and tested on a held-out sixth, the representation must beat full-crystal models by better than a factor of two. Charge-conditioned models must hold force errors below 75 milli-eV per angstrom across charge states — the level published charge-aware potentials reach on single hosts. And the headline metric: predicted versus measured thermal-conductivity degradation agreeing within 20 percent across at least five host materials in year one. Every one of these can fail — that's what makes them worth funding. | Metrics table (three rows, big numbers); "falsifiable" stamp motif. |

Evidence: Theorizer Theses A and B with thresholds (deep dive Section 6); AlN
charge-aware NNP about 69 meV/A (272831919); Sb2Se3 charge-embedding ablation (286256203).
The 20%/5-host kappa target is ours — aggressive but consistent with closure levels in
turn-5 literature; revisit before recording.

### Element 3 — Team capability — 4:15-5:30 (165 words)

| Beat | Narration content | On-screen |
|---|---|---|
| 3a. Sparks / Utah (4:15-4:50) | Taylor Sparks, University of Utah: PhD and publication record in thermal conductivity of defective and disordered materials; a decade building materials-informatics tools the community uses. Critically: an in-house synthesis and characterization lab with a Netzsch LFA 457 laser-flash system — the measured-validation engine of this program, not a subcontract. | Lab b-roll: sample synthesis, LFA 457 loading, publication covers/citations graphic. |
| 3b. Baird / BYU + why us (4:50-5:30) | Sterling Baird, BYU: self-driving laboratories and autonomous experimentation — co-author of the field's definitive review — and creator of materials-informatics benchmarks. His automation closes our loop at machine speed. Together we cover the full stack: representation research, phonon physics credibility, and hands-on measured validation. Published groups have one or two of these. The loop needs all three — that's the team's unfair advantage. | Two-person capability graphic mapping people to pipeline blocks; SDL review citation. |

Evidence: Chem. Rev. 2024 SDL review (CorpusId 271864611, Baird co-author). Keep
credentials factual and verifiable; no proprietary instrument data.

### Element 4 — Defense and commercial use case and impact — 5:30-6:40 (150 words)

| Beat | Narration content | On-screen |
|---|---|---|
| 4a. Defense impact (5:30-6:05) | For defense, this makes thermal conductivity a design variable. Hypersonic leading edges: UHTCs whose conductivity survives oxidation because their defect chemistry was designed for it. Directed energy: diamond and AlN spreaders that keep their conductivity under radiation and processing damage. Space systems: predicting thermal degradation from accumulated radiation defects before it happens — for hardware that can't come home for testing. Thermal barriers and switches designed in weeks, not discovered in years. | Application montage mapped to SN-26-103 envelopes. |
| 4b. Commercial + the layer (6:05-6:40) | Commercially the same loop serves power electronics, batteries, and thermoelectrics — industries that live and die by heat. And the representation itself is the durable asset: a defect standard, dataset, and benchmark — the missing foundation layer that electronic, quantum, and radiation-effects design will all build on. Thermal is the first proof, not the last. | "Defect Genome" layer diagram: thermal flagship on top, other property verticals behind. |

### Close — 6:40-7:00 (30 words, hard stop before 7:00)

| Beat | Narration content | On-screen |
|---|---|---|
| Ask | Defects already program heat. We're asking for the chance to make them designable — and to prove it in measured watts per meter-kelvin. Join us. | Team contact card, title restated, UEI/entity per submission form. |

---

## Supplemental alignment (the other package pieces)

- **Slide 3 (criteria quad chart):** reuse the falsifiable targets from beat 2c as the
  quantitative-merit quadrant; SN-26-103 envelope mapping from beat 4a as relevance.
- **Slide 4 (solution overview + white space):** the beat-1c white-space graphic *is*
  the white-space chart — representation families on one axis (descriptors, supercell
  GNNs, defect-centered, MLIPs), capabilities on the other (in-domain, OOD transfer,
  charge-aware, kappa-validated, closed-loop); our box alone spans the last three.
  Data to fill it: deep dive Sections 3-5.
- **Abstract (1,500 chars) skeleton:** hook sentence (actuation proven, design missing)
  -> representation insight (delta + charge) -> closed LFA-validated loop -> falsifiable
  metrics -> SN-26-103 impact envelope. Keywords (5+): defect engineering; thermal
  management; machine learning representation; phonon transport; thermal conductivity;
  charge states; laser flash analysis.
- **TRL:** claim a single level; TRL 2-3 territory (concept + published component
  evidence, no integrated loop yet) — pick one, justify in `README.md`. TRL 3 defensible
  via component demonstrations (charge-aware potentials, LFA capability); decide before
  the form is filled.

## Production notes

- 880 narrated words leaves about 20 seconds of breathing room — protect it; over 7:00
  is the most common ERIS rejection.
- Record narration first, cut visuals to it. Target lock by **Sept 26** for the
  SN-26-103 window (compliance check takes about a business day; never submit on the
  last day).
- Visual assets needed: lattice/heat-flow animation (beats 0, 2a), pipeline diagram
  (2b), transfer-collapse bar chart (1b), white-space chart (1c/slide 4), LFA 457 lab
  b-roll (2b, 3a), application montage (4a). All original or CC; nothing
  export-controlled; single copyright notice only.
- Tone check against SN-26-103: every beat says *mechanism and design capability*, never
  "ML toolkit" or incremental cooling. The notice's own vocabulary ("foundational
  mechanisms", "disrupting legacy thermodynamic limits") should appear once, verbatim,
  in beat 1a or 4a.

## Decisions needed from Taylor

1. **Go/no-go on the SN-26-103 window** (video locked by about Sept 26) vs. submitting
   to Strategic Systems in October without the notice flag. The outline works for both;
   only the title prefix and one line in beat 1a change.
2. The **20% / 5-host year-one kappa metric** in beat 2c — confirm or recalibrate
   against what you'd stand behind on camera.
3. TRL call (2 vs 3) and entity details for the close and submission form.
