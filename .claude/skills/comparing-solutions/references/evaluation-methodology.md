# Evaluation methodology

Frameworks for scoring, weight calibration, sensitivity analysis, risk classification, and cost modeling used in tool comparison evaluations.

## Contents

- [Scoring rubric design](#scoring-rubric-design)
- [Weight calibration](#weight-calibration)
- [Evaluation matrix construction](#evaluation-matrix-construction)
- [Sensitivity analysis](#sensitivity-analysis)
- [Risk matrix framework](#risk-matrix-framework)
- [Cost modeling](#cost-modeling)
- [Academic citation integration](#academic-citation-integration)

---

## Scoring rubric design

Use a 5-point scale with clear semantic anchors. Every score level must be distinguishable from adjacent levels.

### Standard rubric

| Score | Meaning                                          | When to assign                                               |
| ----- | ------------------------------------------------ | ------------------------------------------------------------ |
| 5     | Fully meets requirement with clear advantage     | Solution exceeds the need; no workarounds or gaps            |
| 4     | Meets requirement well                           | Solution satisfies the need with minor limitations           |
| 3     | Adequate, no significant gaps                    | Functional but unremarkable; gets the job done               |
| 2     | Partially meets requirement, notable gaps        | Solution addresses part of the need but leaves material gaps |
| 1     | Does not meet requirement or introduces problems | Fundamental mismatch or the solution creates new problems    |

### Scoring rules

- **No half-points.** If you're torn between 3 and 4, the decision process forces you to choose. This ambiguity is informative and often reveals that the criterion is poorly defined.
- **Score against the criterion, not the solution overall.** A solution can score 5 on cost and 1 on integration. Averaged scores obscure these differences.
- **Every score needs inline evidence.** In the evaluation matrix, the description cell must contain enough information to justify the number. A reader should be able to verify the score without reading the rest of the document.

### Evidence patterns for each score level

| Score | Evidence pattern                                                                                            |
| ----- | ----------------------------------------------------------------------------------------------------------- |
| 5     | "Plan feeds directly into the next agent via file-based handoff. Four agents with defined contracts."       |
| 4     | "Native Jira integration with auto-trigger rules. Two-click setup."                                         |
| 3     | "Scans project structure and reads documentation. Analysis is thorough but session-scoped."                 |
| 2     | "One generic engine for all repositories. Improves through persistent learning but follows a fixed format." |
| 1     | "Produces plans with copy/paste handoff. No structured connection to downstream consumers."                 |

---

## Weight calibration

Weights encode organizational priorities. They are assertions about what matters most. Getting weights wrong produces a numerically correct but strategically wrong recommendation.

### Calibration process

1. **List criteria** from organizational requirements (not from a generic template)
2. **Force-rank** them: which criterion would you sacrifice last?
3. **Assign initial weights** based on the ranking. The top criterion gets the highest weight.
4. **Check for dominance**: if any single criterion exceeds 30%, ask whether it should be split into sub-criteria
5. **Check for triviality**: if any criterion is below 5%, ask whether it's worth including
6. **Verify sum = 100%** and adjust

### Weight distribution patterns

| Pattern   | Shape                   | When appropriate                                                        |
| --------- | ----------------------- | ----------------------------------------------------------------------- |
| Dominated | 30-25-15-10-10-5-5      | Clear primary constraint (e.g., pipeline integration is non-negotiable) |
| Balanced  | 20-20-15-15-15-10-5     | Multiple equally important concerns                                     |
| Long-tail | 25-20-15-10-10-10-5-3-2 | Many small considerations alongside a few major ones                    |

**Avoid equal distribution** (20-20-20-20-20). If everything matters equally, nothing matters most, and the evaluation cannot distinguish between solutions with different strength profiles.

### Weight justification

Every weight assignment needs a one-paragraph defense in Appendix B. The paragraph must answer:

- Why this weight?
- Why not higher?
- Why not lower?

Example: "Pipeline integration carries 25% because the organization's core investment is the four-stage agent pipeline. A planning tool that doesn't connect to downstream agents negates the pipeline's value. 30% would overweight one criterion; 20% would understate the structural dependency."

---

## Evaluation matrix construction

The evaluation matrix is the document's analytical core. Build it systematically.

### Column structure

```markdown
| # | Criterion (weight) | Solution A | Score | Solution B | Score |
```

### Construction rules

1. **Write all criterion descriptions first** before assigning any scores. This prevents anchoring bias from early scores.
2. **For each criterion, describe Solution A's approach** in 2-3 sentences with specific details. Name the mechanism, its properties, and its limitations.
3. **Then describe Solution B's approach** with identical detail level.
4. **Only after both descriptions exist**, assign scores based on the rubric.
5. **Bold the scores** for visual scanning: `**4**` not `4`.

### Common pitfalls

- **Anchoring on the first solution scored.** If you score Solution A first on all criteria, you unconsciously calibrate all scores relative to A. Score both solutions on the same criterion before moving to the next.
- **Conflating presence with quality.** "Has Jira integration" is not the same as "Has Jira integration with auto-trigger rules, label matching, and two-click setup." Describe the quality, not just the existence.
- **Describing features instead of fit.** "Has real-time chat" is a feature. "Enables multiple stakeholders to refine plans before handoff" is an outcome the criterion evaluates.

---

## Sensitivity analysis

The sensitivity check tests whether the conclusion holds under different weighting assumptions.

### Standard sensitivity check

1. Identify the highest-weighted criterion (or the two highest if close)
2. Remove it entirely and redistribute its weight equally across remaining criteria
3. Recalculate weighted scores
4. Check if the winner changes

**If the winner holds:** The conclusion is stable. State this: "Even if C1 is removed entirely, Solution B still scores higher."

**If the winner flips:** The conclusion depends on that criterion. This is not automatically a problem. But it requires stronger justification for the weight. State this transparently: "The recommendation depends on pipeline integration carrying 25% weight. See Appendix B for the rationale."

### Extended sensitivity check (for close results)

When the gap between solutions is less than 0.5 points:

1. Run the standard check on the top two criteria
2. Add +1 to every score for the lower-scoring solution
3. Check if the gap closes

If +1 across the board closes the gap, the solutions are too close to call. Consider a "conditional recommendation" or identify the tiebreaker criterion.

### Reporting format

Always include the sensitivity check after the weighted scores table. One paragraph is sufficient:

"**Sensitivity check:** Even if pipeline integration and architecture enforcement are removed entirely (weight redistributed equally to remaining criteria), Solution B still scores higher due to advantages in specificity, cost, and data residency. The conclusion holds."

---

## Risk matrix framework

### Probability scale

| Level   | Definition                                                       |
| ------- | ---------------------------------------------------------------- |
| Certain | Will happen if the solution is adopted. Structural inevitability |
| High    | Expected to happen based on current trajectory                   |
| Medium  | Plausible under normal conditions                                |
| Low     | Unlikely but possible                                            |

### Impact scale

| Level  | Definition                                                       |
| ------ | ---------------------------------------------------------------- |
| High   | Blocks core workflow, causes data loss, or creates security risk |
| Medium | Degrades efficiency or quality; workarounds exist                |
| Low    | Minor inconvenience; negligible effect on outcomes               |

### Risk identification checklist

For each solution, evaluate risks across these categories:

- **Integration risks:** Format incompatibility, manual handoff steps, translation requirements
- **Vendor risks:** Lock-in, pricing changes, product discontinuation, beta instability
- **Security risks:** Data residency, code exposure to third parties, authentication gaps
- **Quality risks:** Generic output, missing constraints, no governance enforcement
- **Process risks:** Lost review checkpoints, merged responsibilities, assumption propagation
- **Operational risks:** Maintenance burden, configuration drift, API changes

### Mitigation rules

Every mitigation must be:

- **Specific:** "Build a translation agent to convert output format" not "address the issue"
- **Costed:** "~$10,000 one-time development" or "~$50/year maintenance"
- **Owned:** Identify who is responsible (the team, the vendor, infrastructure)

### Summary pattern

End the risk section with a narrative summary comparing risk profiles:

"Solution A carries N risks, with X rated High/High. These are structural problems, not configuration issues. Solution B carries M risks, all rated Medium or Low impact. R7 is the primary concern and is addressable through [specific mechanism]."

---

## Cost modeling

### Time horizon

Use 3 years as the default projection period. This captures subscription costs, one-time setup amortization, and maintenance trends. State the horizon explicitly.

### Cost categories

| Category             | Examples                                               |
| -------------------- | ------------------------------------------------------ |
| Subscription / API   | Per-user SaaS fees, LLM API costs per invocation       |
| One-time setup       | Agent generation, vendor security review, integration  |
| Maintenance (annual) | Config updates, vendor API changes, agent regeneration |

### Formula presentation

Show all arithmetic. The reader must be able to verify every number.

| Pattern                                    | Purpose                          |
| ------------------------------------------ | -------------------------------- |
| `$24 x 20 users x 36 months = $17,280`     | Subscription calculation         |
| `$0.50 x 40 runs/month x 36 months = $720` | Usage-based calculation          |
| `$3 x 10 projects = $30`                   | One-time per-project calculation |

### Cost multiplier

Calculate and state the ratio: "The cost differential is approximately 42x over three years."

This single number communicates more than the full table. Lead with it in the executive summary.

### Exclusions

Note what the calculation does not include: "This excludes enterprise pricing, which would increase Solution A's costs." Explicit exclusions prevent false precision.

---

## Academic citation integration

Research citations strengthen structural arguments. Use them selectively for claims that benefit from external validation.

### When to cite

- Claims about LLM behavior (self-correction limits, multi-agent advantages)
- Pipeline architecture patterns (specialization benefits, checkpoint value)
- Cost or performance benchmarks from published studies

### When not to cite

- Obvious claims ("tables are easier to scan than prose paragraphs")
- Organizational preferences ("the team prefers Jira")
- Product features (cite the product documentation instead)

### Inline citation format

Introduce the source naturally. State the finding and how it applies:

"Research supports the separated approach. 'Large language models cannot self-correct reasoning yet' (Huang et al., ICLR 2024) demonstrates that LLMs produce better results with explicit checkpoints where external feedback can interrupt error propagation."

### Appendix citation format

Full reference with context:

```markdown
- Huang et al., "Large language models cannot self-correct reasoning yet,"
  ICLR 2024. [arXiv:2310.01798](https://arxiv.org/abs/2310.01798) --
  Cited in Sections 4.1, 5.2. Supports checkpoint-based workflows.
```

The "Cited in" annotation connects the paper to specific sections. The one-sentence summary tells the reader why it matters without reading the paper.
