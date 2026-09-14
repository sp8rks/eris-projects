# Deep dive: representing and featurizing defects in materials for ML/AI

**Date:** 2026-09-14
**Prepared by:** Claude agent (Asta paper-finder + Theorizer runs), for Taylor Sparks and Sterling Baird
**Purpose:** Literature record and idea development for a candidate ERIS video submission on
AI-ready representations of point defects and dopants, with a thermal-management application focus.
Raw Asta search and Theorizer outputs are archived in `asta-artifacts/` alongside this file.

---

## 1. Framing: why this problem

Dopants and defects control the properties we actually care about in functional materials —
carrier concentrations, optical emission, ionic transport, mechanical response, and (centrally
for us) lattice thermal conductivity. Yet ML/AI for materials has been built almost entirely
around *pristine* crystals: composition featurizers, crystal graph networks, and now foundation
interatomic potentials are all trained overwhelmingly on defect-free structures. There is no
agreed-upon way to even *represent* a defect for a machine learning model. That representation
gap — not model capacity and not compute — is the bottleneck blocking AI-accelerated defect
engineering. This is the message that resonated with the DARPA PM, and the literature below
substantiates it.

The state of the art breaks in three specific places:

1. **Transferability.** Models trained on one host/defect chemistry fail badly on new ones
   (documented eV-scale errors, Section 3).
2. **Charge states.** Identical atomic coordinates map to different energies and force constants
   for different defect charge states, which structure-only representations cannot distinguish
   (Section 3.5).
3. **Data scarcity.** Defect DFT is 100-1000x more expensive than bulk DFT (large supercells,
   charge corrections, hybrid functionals), so defect datasets are thousands of entries, not
   millions. Representations must be data-efficient by construction.

---

## 2. Headline findings (TL;DR)

- The field has converged on **five representation families** (descriptor/tabular, defective
  supercell GNNs, defect-centered/sparse encodings, topological features, and MLIP/foundation
  potential approaches), but there is **no benchmark and no standard** — every group rolls its own.
- **Universal "foundation" interatomic potentials systematically fail on defects**: systematic
  softening of the potential energy surface, about 1 eV/atom host-energy bias in bad cases, and
  0.2-0.4 A structural errors on charged defects. Fine-tuning fixes it per-system but destroys
  the "universal" premise. This is the clearest published white space.
- Two sharp, falsifiable design principles emerged from the Asta Theorizer run (Section 6):
  **(A)** encode defects as explicit *differences from a pristine reference* (delta-to-pristine),
  not as absolute defective supercells; **(B)** condition representations *explicitly on defect
  charge state* — this is an identifiability requirement, not a nice-to-have, and it is decisive
  for phonon and thermal-conductivity prediction.
- The defect-to-thermal-conductivity ML pipeline exists in fragments (charge-aware potentials for
  AlN, vacancy studies in Si, Ga2O3, c-BN, LiNbO3, ThO2) but **no general, experimentally
  validated framework** connects a defect representation to predicted kappa degradation. Our LFA 457
  capability is a genuine differentiator here: essentially all published work validates against
  DFT, not against measured thermal conductivity.
- **ERIS alignment:** an active DSO shopping notice on thermal management (DARPA-SN-26-103,
  Strategic Systems topic area) is open **until Sept 30, 2026**. Strong hook, tight timing, and it
  demands physics-grounded thermal innovation rather than an ML tool per se — see Section 7 for
  framing options and risks.

---

## 3. Landscape: how people represent defects today

### 3.1 Hand-crafted descriptors (tabular ML)

The first generation encodes a defect as a feature vector of elemental and site properties
(electronegativity, ionic radius, oxidation state, coordination, band edges of the host).

- *Universal ML framework for defects in zinc blende semiconductors* (Patterns, 2021) — impurity
  formation energies and charge transition levels across 12+ hosts from elemental descriptors;
  RMSE around 0.2-0.3 eV in-domain. [CorpusId:237648228](https://api.semanticscholar.org/CorpusId:237648228)
- *Oxygen vacancy formation energy in metal oxides* (Chem. Mater., 2023) — site-specific
  descriptors (cation identity, oxidation state) over thousands of oxides.
  [CorpusId:261530176](https://api.semanticscholar.org/CorpusId:261530176)
- *ML-learned impurity levels in Cd chalcogenides* and multi-fidelity charge-transition-level
  models extend the approach with multi-fidelity data (PBE + HSE).

**Limitation:** descriptors are host-family-specific, ignore relaxation/local strain fields, and
do not generalize outside the fitted chemistry. Good screening tools, dead end for a general
representation.

### 3.2 Crystal graph neural networks on defective supercells

Second generation: feed the whole defective supercell to a CGCNN/ALIGNN/MEGNet-style GNN.

- *Defect graph neural networks (dGNN) for high-temperature clean-energy applications*
  (Nat. Comput. Sci., 2023) — vacancy formation enthalpies directly from structure; used to screen
  oxides. [CorpusId:260822682](https://api.semanticscholar.org/CorpusId:260822682)
- *Accelerating defect predictions in semiconductors using GNNs* (APL Mach. Learn., 2023) — the
  key transferability data point. ALIGNN reaches RMSE 0.15 eV in-domain on native zinc blende
  defects, but transferred zero-shot to impurities/alloys/complexes the RMSE explodes to
  **2.17 / 2.68 / 2.98 eV**. Adding 50% in-domain data recovers 0.36/0.70/0.18 eV.
  [CorpusId:261696474](https://api.semanticscholar.org/CorpusId:261696474)
- *ML prediction of charged-defect formation energies from crystal structures* (PRL, 2025) —
  CGCNN-based prediction of charged oxygen vacancies plus hole-dopability screening; shows the
  supercell-GNN approach is being pushed to charged defects.
  [CorpusId:281706039](https://api.semanticscholar.org/CorpusId:281706039)
- *Vacancy formation across diverse materials with a single GNN* (AIP Adv., 2022) — notably
  computes formation energy as the *difference* of two pretrained bulk-energy model evaluations
  (defective minus pristine): an early delta-to-pristine pipeline. MAE about 1 eV — feasible but
  insufficient alone. [CorpusId:261593198](https://api.semanticscholar.org/CorpusId:261593198)

**Limitation:** the network must implicitly learn and subtract a large host-dependent baseline
energy before it can see the small defect perturbation. In-domain accuracy is excellent;
out-of-distribution transfer collapses (the 2-3 eV numbers above).

### 3.3 Defect-centered and sparse representations

Third generation: represent only the *perturbation*, not the whole cell.

- *Sparse representation for ML of defects in 2D materials* (npj Comput. Mater., 2023) —
  encodes only defect sites and their interactions rather than the full supercell; faster and
  more accurate than full-structure baselines for defect energetics in 2D hosts.
  [CorpusId:259254057](https://api.semanticscholar.org/CorpusId:259254057)
- *Persistent homology features + GNNs* (Chem. Mater., 2024) — topological features of the
  defect neighborhood improve vacancy formation energies and capture defect-defect interactions
  in perovskites. [CorpusId:271050863](https://api.semanticscholar.org/CorpusId:271050863)
- Physics-informed featurization + transfer learning for 2D defect properties (ACS Nano, 2020)
  is the early exemplar. [CorpusId:221569337](https://api.semanticscholar.org/CorpusId:221569337)

**This family is the seed of Thesis A (Section 6):** explicit defect-centering / pristine
referencing is repeatedly reported as the accuracy and transferability lever.

### 3.4 MLIPs and machine-learned force fields for defects

Rather than predicting a defect property end-to-end, learn the potential energy surface and
compute defect properties (formation energies, migration barriers, phonons) from it.

- GAP for phonon transport in Si with vacancies (PRM, 2019) — early proof that ML potentials can
  capture phonon-vacancy scattering. [CorpusId:162183956](https://api.semanticscholar.org/CorpusId:162183956)
- *DeFecT-FF* for CdTe solar cells (PCCP, 2025) — charge-state-resolved MLFFs from a
  defect-specific high-throughput dataset; explicitly shows pretrained universal potentials
  transfer poorly to charged defect chemistry.
  [CorpusId:282388807](https://api.semanticscholar.org/CorpusId:282388807)
- *ML structural reconstructions for accelerated defect calculations* (npj Comput. Mater., 2024,
  Mosquera-Lois et al.) — defect geometries are often *not* the ideal-site relaxation
  (symmetry-broken reconstructions); fine-tuned universal MLFFs can find them across unseen
  compositions. Important caution: naive representations that assume the ideal defect geometry
  are wrong at the ground-structure level.
  [CorpusId:267068724](https://api.semanticscholar.org/CorpusId:267068724)

### 3.5 Charge-aware representations (the frontier)

- *ML potential for phonon transport in AlN with defects in multiple charge states* (PRM, 2024,
  Dou et al.) — Behler-Parrinello network with a **global system-charge input**; reproduces
  DFT phonon spectra and computes kappa degradation across charge states with force RMSE about
  69 meV/A. The direct defect-to-thermal-transport exemplar.
  [CorpusId:272831919](https://api.semanticscholar.org/CorpusId:272831919)
- *Multi-fidelity MLIPs for charged point defects* (2026, Wang et al., Sb2Se3) — MACE backbone
  plus a **global charge embedding**; without the charge embedding the model collapses charge
  states and misidentifies defect minima; with it, ground-state RMSD ≤ 0.05 A and transition
  levels within 0.015 eV of hybrid DFT. Foundation MLIPs without charge descriptors gave
  0.2-0.4 A structural errors. [CorpusId:286256203](https://api.semanticscholar.org/CorpusId:286256203)
- Reviews: *Defect modeling in semiconductors: first-principles + ML* (J. Phys. Mater., 2025)
  [CorpusId:276329821](https://api.semanticscholar.org/CorpusId:276329821); *ML approaches to point
  defects in non-metallic materials* (Appl. Phys. Express, 2026)
  [CorpusId:288316564](https://api.semanticscholar.org/CorpusId:288316564); *Accelerating
  point-defect simulations with data-driven and ML approaches* (MRS Bull., 2026)
  [CorpusId:287701931](https://api.semanticscholar.org/CorpusId:287701931).

---

## 4. Defects and thermal transport: what ML can and cannot do today

Point defects are often the dominant phonon-scattering channel in real (non-isotopically-pure,
doped, irradiated) materials. The ML literature connecting defects to kappa:

| System | Method | Finding | Ref |
|---|---|---|---|
| Si + vacancies | GAP + BTE | phonon-vacancy scattering captured by MLIP | [162183956](https://api.semanticscholar.org/CorpusId:162183956) |
| AlN, charged defects | charge-aware NNP | kappa vs charge state; forces about 69 meV/A | [272831919](https://api.semanticscholar.org/CorpusId:272831919) |
| beta-Ga2O3 + point defects | deep MLP + EMD | defect-driven kappa suppression via anharmonicity + group velocity | [287397294](https://api.semanticscholar.org/CorpusId:287397294) |
| LiNbO3, O vacancies | MLIP | depth-dependent kappa from defect profiles | [278219436](https://api.semanticscholar.org/CorpusId:278219436) |
| c-BN vacancies/isotopes | NNP | vacancy-induced phonon softening and localization | [269097744](https://api.semanticscholar.org/CorpusId:269097744) |
| ThO2 + fission products | first-principles Green's function | quantitative kappa degradation per defect type | [261031684](https://api.semanticscholar.org/CorpusId:261031684) |
| MoS2/WS2 monolayers | BTE + T-matrix | point-defect kappa suppression, quantitative | [264145981](https://api.semanticscholar.org/CorpusId:264145981) |
| BAs | MLIP | defect scattering in ultrahigh-kappa material | [278117551](https://api.semanticscholar.org/CorpusId:278117551) |

Plus the field review: *Machine learning for predicting thermal transport properties of solids*
(Mater. Sci. Eng. R, 2021) explicitly flags **descriptor challenges for defective crystals** as
an open problem. [CorpusId:237353018](https://api.semanticscholar.org/CorpusId:237353018)

**Gap analysis:** every entry above is a *bespoke, single-host* study. There is no
representation that lets a model trained on defect-phonon physics in one host predict kappa
degradation in another; there is no coupling of defect *formation* models (which defects will
actually be present at processing conditions) with defect *scattering* models (what those defects
do to kappa); and validation is against DFT/BTE, essentially never against measured thermal
conductivity of characterized defective samples. That last gap is exactly what an LFA 457 plus
sample-synthesis capability addresses.

---

## 5. Datasets, benchmarks, and the foundation-model gap

- *Screening of material defects using universal MLIPs* (Small, 2025) — benchmarks four
  universal potentials on defect databases, then screens about 86,000 materials for vacancy
  properties. Universal MLIPs are usable for coarse screening but not for quantitative defect
  physics. [CorpusId:277633925](https://api.semanticscholar.org/CorpusId:277633925)
- *Systematic softening in universal MLIPs* (2024) — pretrained universal potentials
  **systematically underestimate** defect energetics (129 defects, 32 systems); fine-tuning
  corrects it per-system. [CorpusId:269757150](https://api.semanticscholar.org/CorpusId:269757150)
- *U-MLIPs for defects in metals and random alloys* (Mach. Learn. Sci. Technol., 2025) — broad
  benchmark across vacancies, grain boundaries, dislocations, solute-defect interactions.
  [CorpusId:276161599](https://api.semanticscholar.org/CorpusId:276161599)
- *APEX* (npj Comput. Mater., 2025) — automated property benchmarking; pretrained universal
  models underperform specialized potentials on defect properties.
  [CorpusId:277586600](https://api.semanticscholar.org/CorpusId:277586600)
- *Foundation model for defect ID from vibrational spectra* (Matter, 2025) — inverse direction
  (spectra to defect identity); shows "defect foundation model" is becoming thinkable, but only
  for characterization, not property prediction.
  [CorpusId:279075603](https://api.semanticscholar.org/CorpusId:279075603)
- Datasets that exist: zinc blende defect sets (APL ML 2023), 2D material defect sets (npj 2023),
  oxide vacancy sets (Chem. Mater. 2023, dGNN 2023), CdTe defect set (PCCP 2025). All are
  single-family, mutually incompatible in format, and mostly neutral-defect only.

**White space, stated plainly:** there is no MNIST/Materials-Project equivalent for defects — no
canonical dataset, no agreed representation, no OOD benchmark, and foundation models demonstrably
fail there. Whoever defines the representation standard + benchmark + charge-aware,
transfer-tested model for defects owns the layer that every downstream defect-engineering
application (thermal, electronic, quantum, radiation) will build on.

---

## 6. Asta Theorizer output: two falsifiable design theses

Full run archived at `asta-artifacts/theorizer-defect-representations.json` (20 papers retrieved,
novelty-focused objective). The eight generated theories cluster into two theses; each comes with
concrete forks and numeric thresholds we could adopt directly as project milestones or use as
white-space evidence in the pitch.

### Thesis A — Delta-to-pristine encoding is the transfer bottleneck

Full-defective-supercell representations force the model to implicitly learn and subtract a large
host-energy baseline, which is what collapses out-of-distribution transfer (the 2-3 eV ALIGNN
failures). Representations that explicitly encode the defect as a *difference from a matched
pristine reference* (paired defect/pristine subgraphs, delta readouts, or difference targets)
compress the learning problem to the localized perturbation.

Representative falsifiable claims from the run:
- With 5 or more training hosts and leave-one-host-out testing, a delta-to-pristine model reaches
  RMSE ≤ 0.6 eV where a matched-capacity full-supercell model stays above 1.0 eV.
- With ≤ 100 labels in a new defect category, delta-encoding reaches ≤ 0.7 eV while absolute
  encoding stays above 1.5 eV.
- Angular/three-body features fix in-domain accuracy but do *not* rescue cross-category transfer
  (supported: ALIGNN 0.15 eV in-domain vs 2.17 eV zero-shot).
- Local MLIPs trained defect-only develop about 1 eV/atom host-energy bias at larger supercells
  unless pristine host frames are included in training.

### Thesis B — Explicit charge conditioning is an identifiability requirement

For charged defects, identical coordinates map to different energies/forces/force-constants
depending on charge state; a structure-only representation *cannot* separate these potential
energy surfaces regardless of capacity. A minimal global charge token (embedding or scalar)
resolves it and is more data-efficient than separate per-charge models — decisively so for
phonon and thermal-conductivity targets, which need consistent derivatives across charge states.

Representative falsifiable claims:
- With about 2,000 training structures over 5 charge states, charge-embedded models hit relaxed
  ground-state RMSD ≤ 0.1 A per charge state; charge-agnostic models fail on most (supported by
  the Sb2Se3 MACE ablation and foundation-MLIP failures).
- Under a total budget of ≤ 3,000 structures, one charge-conditioned model keeps force RMSE
  ≤ 75 meV/A across charge states; separate per-charge models exceed 100 meV/A (supported by
  the AlN charge-aware NNP at about 69 meV/A).
- Open question flagged by the Theorizer: a global charge token may be insufficient for *defect
  complexes*, which may need local charge-density descriptors — a natural stretch goal.

**Why this matters for the pitch:** these are exactly the kind of quantitative, physics-grounded,
falsifiable statements the DSO shopping notice says it wants ("rigorous, physics-based evidence
... over qualitative, marketing-style assertions"), and they define crisp Phase-1-style
milestones.

---

## 7. ERIS topic alignment: options and recommendation

### Option 1 (recommended): Strategic Systems topic + DARPA-SN-26-103 thermal-management shopping notice

`eris/docs/special-topics/DARPA-SN-26-103-ERIS-Shopping-Notice-Thermal-Management.pdf` — DSO is
actively shopping the marketplace **July 31 through Sept 30, 2026** for "game-changing,
foundational mechanisms ... capable of fundamentally disrupting legacy thermodynamic limits,"
submitted under the Strategic Systems topic area with video title format
`DARPA-SN-26-103: [Title]`.

Fit:
- The notice's material-level obstacle list is literally a defect problem: high-conductivity
  materials (diamond, graphene, UHTCs) limited by instability, oxidation, and fabrication — all
  defect-mediated degradation of kappa. Predictive defect engineering is a *foundational
  mechanism* for routing/preserving heat, not a bolt-on cooling package.
- The notice explicitly wants defined target envelopes (hypersonics, space, directed energy, edge
  computing), aggressive self-defined metrics (effective kappa), physics-based evidence, and
  multidisciplinary teams doing generalizable heat-transfer science — all compatible with the
  framing "thermal conductivity as a *designable*, defect-controlled property."

Risks / honest caveats:
- **Timing is tight**: the window closes Sept 30, 2026, and ERIS compliance review argues against
  last-day submission, so a video would need to be done by around Sept 26-29. Fallback: submit to
  the Strategic Systems topic after the window anyway (the topic remains open; we lose only the
  shopping-notice flag), or resubmit an improved version later.
- The notice asks for thermal *mechanisms*, and warns against incremental cooling improvements.
  A pitch that reads as "an ML representation toolkit" is off-scope. The framing must be:
  **defect-programmed thermal transport** — using AI-designed dopant/defect populations to set
  kappa on demand (suppress it for thermal barriers and directed insulation; preserve it in
  high-kappa heat-spreader materials under radiation/oxidation damage) — with the representation
  breakthrough as the enabler, and LFA 457 measurements as the physics evidence engine.

### Option 2: Space operations topic (LEO/MEO/GEO/Cislunar)

The R10 topic list explicitly includes "thermal management" and "AI/ML for space systems" under
space operations. Defect angle: radiation-induced defects progressively degrade thermal and
electronic performance of space electronics, solar cells, and radiators; predicting kappa vs
accumulated defect population is a genuine space-sustainment problem, and spacecraft cannot be
brought home for recharacterization. Weaker hook than an active shopping notice, but no deadline
pressure and a clean story. Also a natural *second* video (ERIS allows up to three per month).

### Option 3: AI/ML convergence topic (prepare/deploy/execute/return resilience)

R10 frames this around foundation models and "data factories" for chemistry and biology; a
materials-defect data factory is arguably adjacent (the topic's spirit is AI-ready scientific
data infrastructure), but the letter of the topic is chem/bio. Note: topic choice does not
affect scoring (see `eris/eris-notes.md`), so this is mainly a discoverability/categorization
decision. Not recommended as primary.

### Recommendation

Target **Option 1** with the defect-programmed-thermal-transport framing and the SN-26-103 title
format if the video can be produced by late September; otherwise submit the same pitch to the
Strategic Systems topic in the October window and keep Option 2 in reserve as a second
submission.

---

## 8. Candidate pitch concepts

1. **"Thermal conductivity on demand: AI-designed defect populations"** *(primary, fits
   SN-26-103).* Problem: thermal limits of DoD systems are set by materials whose kappa degrades
   unpredictably with the defects introduced by processing, doping, oxidation, and radiation;
   today defect effects on kappa are discovered empirically, one alloy at a time. Advance:
   first transferable, charge-aware defect representation (Theses A+B) trained across hosts,
   coupled to phonon-defect scattering models, closing the loop with synthesized samples and
   LFA 457 thermal conductivity measurement — turning kappa into a designable quantity.
   Metrics: predicted-vs-measured kappa degradation across N hosts; OOD transfer targets from
   Section 6. Impact: heat spreaders that survive extreme environments, engineered-anisotropy
   thermal routing, TBCs designed in weeks instead of years; commercial spillover to power
   electronics, batteries, and thermoelectrics.

2. **"The Defect Genome"** *(broader infrastructure play).* A canonical representation standard,
   curated multi-host charged-defect dataset, OOD benchmark suite, and pretrained defect
   foundation model — the missing MNIST/Materials-Project layer for defects. Thermal conductivity
   is the flagship validated property; electronic/quantum/radiation properties follow. Riskier
   for ERIS (reads as tooling), but the strongest long-term differentiation; could be the
   commercial/impact slide of concept 1 rather than a separate pitch.

3. **"Radiation-aware thermal sustainment for space systems"** *(Option 2 vehicle).* Predict
   kappa and device thermal margins as a function of accumulated radiation-induced defect
   populations in space electronics and radiator materials; same core representation technology,
   space-operations framing.

**Team capability notes (element 3 of the pitch):** Sparks — PhD and publication record in
thermal conductivity of defective/disordered materials, materials informatics track record
(citrination-era featurizers onward), LFA 457 laser-flash instrument plus synthesis and
characterization lab at Utah; Baird — self-driving labs and materials-informatics benchmarks
(co-author on the Chemical Reviews SDL review found in the earlier Asta test run), autonomous
experimentation infrastructure at BYU. The combination covers "multidisciplinary team with
demonstrated expertise in discovering and validating new physical principles" plus the
experimental validation loop most competing ML groups lack.

---

## 9. Open questions for follow-up runs

- Quantitative white-space chart data: pull citation/venue counts per representation family per
  year (Asta paper-finder follow-up) to draw the slide-4 white-space chart.
- Does anyone couple defect *thermodynamics* (which defects form at processing conditions) with
  defect *phonon scattering* end-to-end? Initial searches say no; verify with a targeted search
  before claiming it in the video.
- Prior DoD/DARPA investment scan (MSEE? QIS defect programs are quantum-centric) to sharpen the
  "why now / why us" argument.
- Theorizer novelty-evaluation stage was skipped for runtime; rerun `evaluate-novelty` on
  theories 3/5 (delta-encoding) and 6/8 (charge conditioning) before writing the script, so the
  claimed novelty in the pitch is defensible.

## 10. Provenance

- Asta paper-finder thread `d6343236-1f24-45aa-8b24-c345b2da6853`, three turns (2026-09-14):
  defect representations (18 papers), defects and thermal transport (12), datasets/foundation
  models (12). Raw JSON in `asta-artifacts/` with per-paper relevance judgements and snippets.
- Asta Theorizer `literature-theory-generation`, novelty-focused, 20 papers, qualified novelty
  evaluation disabled; 16 extraction tables + 8 theories in
  `asta-artifacts/theorizer-defect-representations.json`.
