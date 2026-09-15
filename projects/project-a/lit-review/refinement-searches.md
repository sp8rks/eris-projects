# Refinement searches: sharpening the pitch claims (2026-09-15)

**Purpose:** three follow-up Asta paper-finder turns (continuing thread
`d6343236-1f24-45aa-8b24-c345b2da6853`, turns 4-6) targeting the open questions in
Section 9 of `defect-representations-deep-dive.md`, run before drafting the video
outline (`../video-outline.md`). Raw JSON in `asta-artifacts/` (`.004`-`.006` files).

Each search changed a pitch claim. Summary of the deltas:

| Turn | Question | Outcome | Effect on pitch |
|---|---|---|---|
| 4 | Does any end-to-end framework couple defect thermodynamics with phonon scattering (processing conditions in, kappa out)? | **No.** White space verified. | Central claim of element 2, now defensible |
| 5 | How common is measured-vs-predicted closure for defect-limited kappa? | More common than we claimed — for one-off, well-characterized crystals. | **Correction:** soften the deep dive's Section 4 claim; reframe differentiator |
| 6 | Has anyone experimentally *programmed* kappa via controlled defects? | Yes, repeatedly — but empirically, one material at a time. | New feasibility evidence + sharper framing: "actuation exists, design does not" |

---

## Turn 4 — end-to-end thermodynamics-to-kappa coupling (white space VERIFIED)

Query: frameworks coupling predicted equilibrium defect populations (vs processing
conditions: temperature, chemical potential, growth environment) to phonon-defect
scattering / lattice thermal conductivity.

**Asta's verdict, verbatim:** "No papers were found that fully implement an end-to-end
framework where processing conditions ... are input and lattice thermal conductivity is
output, via explicit coupling of defect thermodynamics ... with phonon-defect scattering
or thermal conductivity prediction." Only 2 papers rated relevant, both partial:

- *Integrated experimental + computational investigation of defect and microstructural
  effects on thermal transport in ThO2* (Acta Mater., 2021) — closest prior art: defect
  evolution modeling coupled to first-principles phonon transport, benchmarked against
  experiment, but nuclear-fuel-specific and not a general or automated workflow.
  [CorpusId:235507809](https://api.semanticscholar.org/CorpusId:235507809)
- *Role of defects in lattice transport of half-Heusler TaFeSb: ML analysis* (2024) —
  links predicted defect formation energies to phonon spectra and reduced kappa in one
  host; not end-to-end, not transferable.
  [CorpusId:274777007](https://api.semanticscholar.org/CorpusId:274777007)

Reviews ([237353018](https://api.semanticscholar.org/CorpusId:237353018),
[287701931](https://api.semanticscholar.org/CorpusId:287701931),
[239677426](https://api.semanticscholar.org/CorpusId:239677426)) name the integration as
a recognized open direction. **Use in video:** we can now state, with a documented
search behind it, that the processing-in/kappa-out capability does not exist and name
the two nearest attempts as the state of the art we advance past.

## Turn 5 — measured-vs-predicted closure (CLAIM CORRECTED)

Query: validation of predicted defect-/dopant-limited kappa against measured kappa
(LFA, TDTR, 3-omega) on real doped/irradiated/defective crystals.

**Finding: 16 relevant studies.** Closure between first-principles predictions and
measurement is achieved for well-characterized single crystals with quantified defect
levels — e.g. B-doped 3C-SiC via TDTR
([278171299](https://api.semanticscholar.org/CorpusId:278171299)), Zr-doped ThO2
([274788456](https://api.semanticscholar.org/CorpusId:274788456)), heavily N-doped
3C-SiC ([272968849](https://api.semanticscholar.org/CorpusId:272968849)), AlN
([207780348](https://api.semanticscholar.org/CorpusId:207780348)), high-purity BAs
([267365123](https://api.semanticscholar.org/CorpusId:267365123)). Discrepancies
persist when defect populations are not independently quantified or in
disordered/polycrystalline samples.

**Correction to the deep dive:** Section 4's line that published work validates
"essentially never against measured thermal conductivity" is too strong and must not
appear in the video. The accurate, still-powerful version: **validation today is
one-off and post-hoc** — a heroic per-material campaign that confirms a prediction
after the fact. No one runs a *closed design loop* in which a transferable defect
representation proposes defect populations, samples are synthesized, measured kappa
feeds back, and the model improves across hosts. That loop, not measurement per se, is
our LFA 457 differentiator. Bonus: the 16 papers define the measurement-protocol state
of the art we should mirror (and cite) for credibility.

## Turn 6 — defect-programmed kappa demonstrations (FEASIBILITY EVIDENCE ADDED)

Query: experimental demonstrations of deliberately tuning kappa to target values via
controlled point defects/dopants; suppression and recovery; kappa as a designable or
switchable property.

**Finding: the actuation side of "thermal conductivity on demand" is proven.**

- Greater than 5-fold *continuous, reversible* kappa tuning in La0.5Sr0.5CoO3-d films via
  oxygen-vacancy control by ion-gel gating (Nat. Commun., 2023).
  [CorpusId:257771454](https://api.semanticscholar.org/CorpusId:257771454)
- Site-selective *programming* of kappa along a single Si nanowire by helium-ion dose,
  including a microscale thermal cloak (Nat. Commun., 2017; HIM review 2021).
  [CorpusId:20742011](https://api.semanticscholar.org/CorpusId:20742011),
  [235741322](https://api.semanticscholar.org/CorpusId:235741322)
- Reversible vacancy-controlled kappa in epitaxial WO3 (Adv. Mater., 2019).
  [CorpusId:202569803](https://api.semanticscholar.org/CorpusId:202569803)
- Sulfur-vacancy superlattice patterning in MoS2 that suppresses *or restores* kappa
  depending on pattern period (Adv. Theory Simul., 2024).
  [CorpusId:274846406](https://api.semanticscholar.org/CorpusId:274846406)
- Defect-dipole-enhanced electric-field thermal switching in bulk BaTiO3
  (Chem. Mater., 2025). [CorpusId:283103115](https://api.semanticscholar.org/CorpusId:283103115)
- Vacancy-tailored anharmonicity in Zintl thermoelectrics (Nat. Commun., 2024).
  [CorpusId:268665989](https://api.semanticscholar.org/CorpusId:268665989)

**Use in video:** this is the hook's proof and the framing device for the whole pitch.
Every one of these results was found *empirically*, one material and one knob at a
time. The hardware for defect-programmed heat flow exists; the *design capability* —
predicting which defect population yields a target kappa in a new material — does not
(Turn 4). We supply the missing design layer. This "actuation without design" phrasing
also inoculates against the SN-26-103 warning about incremental cooling improvements:
we are not proposing a cooler, we are proposing the mechanism-level design capability.

## Provenance

Thread `d6343236-1f24-45aa-8b24-c345b2da6853`, turns 4-6, run 2026-09-15. The thread
index (`asta-artifacts/index.json`, renamed from `literature-thread-index.json` so the
Asta CLI auto-resumes it) records queries, narratives, and per-turn artifact files:
`thermo-phonon-coupling.004.json`, `kappa-experimental-validation.005.json`,
`defect-engineered-kappa.006.json`.
