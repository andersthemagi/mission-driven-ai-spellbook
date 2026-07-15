# Changelog

Versions of the Mission Driven AI Spellbook, newest first. The toolkit is designed to be re-installed to update (see [Updating](README.md#updating)).

## [1.1.0]

### Added
- **`/vibe-audit`**, an evidence-based security & architecture audit skill, developed in collaboration with Matt "Kelly" Williams at Making Software Greener. Reads a local repo, a GitHub URL, or pasted files; runs five specialist lenses (access, input safety, secrets/deployment, observability, tests/maintainability); verifies every finding against the source before reporting; and outputs a ranked risk ledger with file-and-line citations, a fragility check, a "what breaks at 10x" read, and a readiness scorecard. `--demo` mode appends an anonymized shareable summary.
- **Reference examples**, a full-length golden-reference report (`vibe-audit/examples/full-report-marketplace.md`) plus calibration runs in `examples.md` for `/vibe-audit`, `/mission-check`, `/prompt-brief`, `/rao-ready`, and `/ship-plan`.
- **[TESTING.md](TESTING.md)**, record of the codebases `/vibe-audit` was tested and calibrated against (~776k tracked LOC across 6 real projects).
- **Portability + versioning docs**, "Run it in any tool," "Updating," and "Versioning & contributing" sections; this changelog; a `VERSION` file.

### `/vibe-audit` methodology, refined across real audits (v1 → v5)
The skill was built, then run against progressively larger real codebases, and improved after each run:
- **v2**, phased pipeline: scope scan → parallel specialist lenses → merge-and-verify (re-read every cited line before it reaches the report).
- **v3**, Phase-1 execution-model determination and low-surface triage; negative-evidence citations (absence, shown, is evidence); "certain behavior / uncertain blast radius" severity rule.
- **v4**, client-side-gate rule for SPAs (a client gate is a finding only when nothing server-side backs it); concentrated-risk triage; platform-default-absence handling; blast-radius-vs-default-lower tiebreak.
- **v5**, Critical/High findings must ship a concrete fix with a code sketch, not a one-liner; large-repo authored-vs-vendored confirmation; migration-vs-live-DB handling.

## [1.0.0]

### Added
- Initial six skills: `/mission-check`, `/prompt-brief`, `/rao-ready`, `/ship-check`, `/ship-plan`, `/long-run`, the pre-build → ship-gate → long-term journey.
