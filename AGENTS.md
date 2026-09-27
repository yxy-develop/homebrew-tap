# Yxy Homebrew tap — agent and contributor instructions

This repository is the Homebrew tap for the `yxy` compiler: `Formula/yxy.rb`
and nothing else of substance. `CLAUDE.md` only imports this file. In the
maintainer workspace, the workspace rules are in `../plans/AGENTS.md`.

- The formula builds from source at a tag of `yxy-develop/yxy`, pinned by tag
  and commit. Changing the tag means changing both, in the same commit.
- Before any push: `brew style yxy-develop/tap`,
  `brew audit --strict yxy-develop/tap/yxy`,
  `brew install --build-from-source yxy-develop/tap/yxy` and
  `brew test yxy-develop/tap/yxy`, all green locally.
- Never claim in the formula, caveats or README more support than
  `docs/implementation/TARGETS.md` of the `yxy` repository records.
- English, commits authored by the maintainer identity configured in Git, with
  no AI attribution. No release, public tag or visibility change without the
  maintainer's authorization.
