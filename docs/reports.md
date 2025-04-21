# Overview

---

## Project Summary

**[DomiNyan](https://yifen9.github.io/DomiNyan)** is an open, modular research project that builds an AI‑training platform for the *partially‑observable* strategic deck‑building game [Dominion](https://en.wikipedia.org/wiki/Dominion_(card_game)).

The project couples a **deterministic simulation engine**, a structured logging system, and an extensible self‑play framework for studying decision‑making in stochastic, multi‑agent environments. Its long‑term vision is to become an open platform for experimentation and benchmarking in reinforcement learning (RL), agent modelling, and AI interpretability, with a deliberate focus on **reproducibility**, **accessibility**, and **scalability** across single‑ and multi‑agent settings.

The simulator is written entirely in **[Julia](https://en.wikipedia.org/wiki/Julia_(programming_language))**, chosen for high performance and a composable design ethos. Fine‑grained hooks expose state tracking, logging, and modular logic injection (card behaviours, agent strategies, rule variants). Python is intentionally avoided to minimise overhead and keep a single fast runtime.

Architecturally, the code base is evolving toward a **[domain‑specific language (DSL)](https://en.wikipedia.org/wiki/Domain-specific_language)** that cleanly expresses card effects and strategy reasoning. While the prototype lives in Julia macros, future iterations may isolate behaviour definitions in functional DSLs—e.g. [Elixir](https://en.wikipedia.org/wiki/Elixir_(programming_language)), [OCaml](https://en.wikipedia.org/wiki/OCaml), or [Gleam](https://en.wikipedia.org/wiki/Gleam_(programming_language))—or run them on high‑performance [Rust](https://en.wikipedia.org/wiki/Rust_(programming_language)) executors, improving composability, testability, and long‑term maintainability.

DomiNyan aims to:

- **Deliver** a faithful and reproducible Dominion engine with structured phase execution and deterministic game flow for rigorous benchmarking.
- **Enable** modular self‑play training via explicit strategy layers (`Choose.*`) and overridable decision points.
- **Generate** structured logs and temporal snapshots for replay, supervision, and downstream model training.
- **Provide** open‑science tooling, including GitHub Pages replays and standardised JSON/CSV exports for archival and sharing.
- **Establish** a scalable foundation for team‑based agents, meta‑strategy evolution, cross‑version generalisation, and curriculum‑based training—supporting both academic and applied research.

By modularising every layer—from core mechanics to export pipelines—**DomiNyan** offers a clean, extensible base for long‑term research, classroom exploration, and competitive AI benchmarking.

---

## Project Structure

The DomiNyan project is organized into modular components, structured around clear responsibilities. Below is the current directory tree with inline explanations.

### Overall repository layout

```
DomiNyan/
├── src/core/               # Game simulator (see detailed tree below)
├── docs/                   # MkDocs site, reports, static assets
│   ├── index.md            # Landing page
│   ├── reports.md          # Project summary & progress logs
│   ├── viewer.md           # Replay viewer
│   └── data/games/         # Auto‑exported logs & tracker snapshots
├── scripts/                # One‑off and automation utilities
│   ├── export_tracker_to_docs.jl
│   └── format.jl           # (planned) JuliaFormatter entry point
├── test/                   # Unit & integration tests
├── .github/
│   └── workflows/          # ci.yml, docs.yml, format.yml
├── Project.toml            # Julia package environment
├── Manifest.toml           # Locked dependency versions
├── README.md               # (planned) Quick‑start & architecture overview
├── CONTRIBUTING.md         # (planned) Coding style & PR checklist
└── LICENSE                 # (planned) MIT
```

### Game simulator:

```
src/core/                   # Core simulation engine
├── play/                   # Public gameplay API (draw, buy, resolve, …)
│   ├── play.jl             # External entry point
│   ├── types/              # Concrete type definitions & small traits
│   ├── player/             # Player data structures & helpers
│   ├── dispatcher/         # Dispatches external calls to effect pipeline
│   └── effects/            # Pure effect functions (gain_card!, trash_card!, …)
├── cards/                  # Card catalogue
│   ├── cards.jl            # Top‑level import + shared helpers
│   ├── registry/           # Registers card metadata into global table
│   ├── loader/             # Batch loader (by set, by filename, CLI)
│   └── set/                # Concrete card sets (Base, Intrigue, …)
└── game/                   # Session management
    ├── game.jl             # Session‑level entry (run, save, resume)
    ├── state/              # Immutable/serialisable game state snapshots
    ├── tracker/            # Time‑series state recorder
    ├── logger/             # Structured CSV / JSON logging
    ├── choose/             # Human & AI decision hooks (`Choose.*`)
    └── loop/               # Turn driver
        ├── loop.jl         # Orchestrates turn lifecycle
        └── phases/         # start.jl, action.jl, buy.jl, cleanup.jl
```

---

## Development timeline

### Milestone reports
| Phase | Target window | Status | Report | Highlights | Primary tech focus |
|-------|---------------|--------|--------|------------|--------------------|
| P1    | /             | Active | /      | `core.jl`, `loop.jl`, `log.csv`, `state.json` | Julia + macros |
| P1.1  | 2025-04-12    | Done   | /      | Basic loop, minimal logger | / |
| P1.2  | 2025-04-13    | Done   | /      | Tracker, first viewer stub | / |
| P1.3  | /             | Active | /      | Remaining effects, full base‑set cards | / |
| P1.4  | /             | Pending | /     | Complete simulator; expose `Choose.*` hooks | / |
| P2    | /             | Planned | /     | AST schema, runtime evaluator | AST design, DSL construction |
| P3    | /             | Planned | /     | Headless runner, stats module, charting | Julia multithreading or Elixir concurrency; Rust optional for high‑speed parser |
| P4    | /             | Planned | /     | PPO / genetic / self‑play baseline | Flux.jl + RL.jl |
| P5    | /             | Research | /    | `.domi` spec, AST → JSON converter; training | OCaml for type‑safe parser; Rust or Gleam alt. |
| P6    | /             | Research | /    | Elixir/Gleam service, supervisor tree, SQL | BEAM (Elixir or Gleam) + SQL |
| P7    | /             | Research | /    | Online DSL editor, strategy diff UI, public demos | / |

### Daily reports
| Date | Contributor | Summary |
|------|-------------|---------|
| 2025-04-11 → 2025-04-13 | Li Yifeng | P1.1 & P1.2 finished |
| [2025-04-19](./reports/2025-04-19.md) | Li Yifeng | Reporting pipeline bootstrapped, refactoring `core/play/` and `core/cards/` |
| [2025-04-20](./reports/2025-04-20.md) | Li Yifeng | Core refactor, effects pipeline added, 95.7% coverage. |
| [2025-04-21](./reports/2025-04-21.md) | Li Yifeng | Finalized the effects pipeline and choose flow integration, 95.8% test pass rate |

---

## Technical roadmap

### P1 - Simulator & logging

- Lock down deterministic game loop; complete all base‑set cards.
- Write property‑based tests until 90 % coverage.
- Master Julia macros for concise card definitions.

### P2 - DSL layer

- Draft EBNF grammar for card effects and strategy rules.
- Emit typed AST objects; build small interpreter in Julia.
- Explore Rust pest or OCaml Menhir as alternate parsers.

### P3 - Batch simulation & analytics

- Introduce Julia multithreading; benchmark vs. Erlang/Elixir concurrency.
- Aggregate logs; surface charts in MkDocs via Vega‑Lite.

### P4 - AI baseline

- Integrate Flux.jl and RL.jl; implement PPO and genetic agents.
- Add self‑play tournament driver; export Elo curves.

### P5 – DSL externalisation

- Freeze `.domi` file format (JSON schema).
- Provide CLI validator in OCaml for static guarantees (or Rust for speed).
- Investigate Gleam as strongly‑typed BEAM DSL host.

### P6 – Inference service platform

- Stand up Elixir (or Gleam) micro‑service to serve strategy decisions.
- Use OTP supervisor tree and a SQL store (PostgreSQL).
- Optional: port hot path to Rust and expose over NIF or WASM.

### P7 – Public authoring & visualisation

- Web DSL editor, strategy diff UI, public demos

---

## Current progress

> as of 2025‑04‑19

- 12/39 base‑set card files implemented; remaining action cards queued.
- Core tracker stable; CSV + JSON logs auto‑export to `docs/data/games/`.
- Viewer page loads snapshots; timeline scrubber half done.
- Unit‑test suite: 3 unit tests, 100% passing; CI and docs workflows scaffolded.

Next steps

1. Resolve effects that depend on the **choose** module  
   – wire `effects/` and the main game loop to `choose/` without circular calls.  
2. Implement all remaining card effects and missing cards.  
3. Improve the visual‑analytics tool and tighten benchmark tests.

---

## Contributors

Contribution graph is available [here](https://github.com/yifen9/DomiNyan/graphs/contributors).

| Name | Role | Status | First commit |
|------|------|--------|--------------|
| [Li Yifeng](https://yifen9.github.io) | Project Initiator, Core developer | Active | 2025-04-11 |
| [Luca Fiorini](https://github.com/lucaFiorini) | Core developer | Active | / |

![Contributors](https://contributors-img.web.app/image?repo=yifen9/DomiNyan)