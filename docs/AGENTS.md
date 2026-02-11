# AGENTS.md
## Documentation Maintenance & Update Procedures

---

## Purpose

This document defines the agents (human or AI) responsible for maintaining and updating the Cantor documentation. Each agent has specific responsibilities and update triggers.

---

## Documentation Structure

```
docs/
├── AGENTS.md                    # This file
├── ai-music-collection.json     # AMF examples
├── cadence-dsl-reference.md     # Language reference
├── cadence-rfc-clean.md         # Formal specification
├── cantor-implementation-guide.md # Implementation details
└── scoredown-format.md          # Notebook format spec
```

---

## Agent Responsibilities

### 1. Language Agent
**Files:** `cadence-dsl-reference.md`, `cadence-rfc-clean.md`

**Responsibilities:**
- Update DSL syntax when new functions are added
- Maintain consistency between RFC and reference
- Document breaking changes
- Add new operator definitions
- Update compilation target specs

**Update Triggers:**
- New Cadence function added to `lib/cantor/cadence/`
- Parser changes in `lib/cantor/cadence/parser.ex`
- New operator implementations
- Compilation target additions

### 2. Format Agent
**Files:** `scoredown-format.md`, `ai-music-collection.json`

**Responsibilities:**
- Maintain Scoredown (markdown-ld) format specification
- Update AMF (AI Music Format) examples
- Document JSON-LD schema changes
- Add new music examples for AI consumption

**Update Triggers:**
- JSON-LD context changes
- New AMF fields added
- Markdown-LD parser updates
- New consciousness parameters discovered

### 3. Implementation Agent
**Files:** `cantor-implementation-guide.md`

**Responsibilities:**
- Keep Ash resource definitions current
- Update LiveView component docs
- Document new API endpoints
- Maintain deployment procedures

**Update Triggers:**
- New Ash resources in `lib/cantor/music/`
- LiveView updates in `lib/cantor_web/live/`
- Database schema migrations
- Dependency updates in `mix.exs`

### 4. Example Agent
**Files:** `ai-music-collection.json`

**Responsibilities:**
- Generate new AI Music Format examples
- Test AMF with Claude and document effects
- Create genre-specific patterns
- Document consciousness frequency effects

**Update Triggers:**
- New musical genres requested
- Consciousness research findings
- AI feedback on existing patterns
- Community contributions

---

## Update Procedures

### Adding New Functionality

1. **Code First:** Implement in appropriate Elixir module
2. **Test:** Ensure tests pass
3. **Document:** Update relevant docs based on agent responsibility
4. **Example:** Add example to AMF collection if applicable
5. **Commit:** Use clear commit message referencing doc updates

### Version Updates

When updating documentation for new versions:

```markdown
## Version History
- v1.0.0 (2025-01-27): Initial release
- v1.1.0 (date): Description of changes
```

### Documentation Standards

- **Code blocks:** Use language-specific syntax highlighting
- **Headers:** Follow existing hierarchy
- **Examples:** Always provide working examples
- **Links:** Use relative links to other docs
- **Terminology:** Consistent use of AMF, Cadence, Scoredown

---

## Automated Checks

### Pre-commit Hooks
```bash
# .git/hooks/pre-commit
# Check for outdated examples in docs
mix docs.check

# Verify all Cadence examples compile
mix cadence.verify_docs
```

### CI/CD Integration
```yaml
# .github/workflows/docs.yml
- name: Verify Documentation
  run: |
    mix docs.check
    mix cadence.verify_docs
```

---

## AI Agent Instructions

When an AI agent (like Claude) is asked to update documentation:

1. **Identify Role:** Determine which agent responsibility applies
2. **Check Consistency:** Ensure updates don't conflict with other docs
3. **Maintain Truth:** AMF is music FOR AI, not fingerprints
4. **Preserve Format:** Keep existing structure and style
5. **Add Examples:** Include working Cadence code where relevant

### Example AI Update Request
```
"Update the DSL reference to include the new `arpeggio()` function"

Response should:
1. Add to cadence-dsl-reference.md
2. Update RFC if specification changes
3. Add AMF example if it affects AI music format
4. Include working example
```

---

## Documentation Review Schedule

- **Weekly:** Check for undocumented code changes
- **Monthly:** Review and update examples
- **Quarterly:** Full documentation audit
- **On Release:** Complete version documentation

---

## Contact Points

- **Language Questions:** Cadence language team
- **Platform Issues:** Cantor platform team
- **AI Integration:** ZPC consciousness team
- **Community:** cantor.com/community

---

## Quick Reference

### File Purposes
- `AGENTS.md` - You are here
- `ai-music-collection.json` - AMF examples for feeding to AI
- `cadence-dsl-reference.md` - Quick language reference
- `cadence-rfc-clean.md` - Formal language specification
- `cantor-implementation-guide.md` - How to build/deploy
- `scoredown-format.md` - Notebook format specification

### Key Concepts
- **Cadence** - The DSL for music composition
- **AMF** - AI Music Format (JSON-LD), the "MP3 for AI"
- **Scoredown** - Markdown notebooks with embedded Cadence
- **Cantor** - The platform (cantor.com)

---

## Meta

This document itself should be updated when:
- New documentation files are added
- Agent responsibilities change
- Update procedures are modified
- New automated checks are implemented

Last updated: 2025-01-27
Version: 1.0.0
