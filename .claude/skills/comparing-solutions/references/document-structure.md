# Document structure reference

Section-by-section guidance for building tool comparison evaluation documents. Each section includes its purpose, required elements, structural patterns, and rules derived from the reference evaluation format.

## Contents

- [Document metadata](#document-metadata)
- [Section 1: Executive summary](#section-1-executive-summary)
- [Section 2: Scope and methodology](#section-2-scope-and-methodology)
- [Section 3: Solution profiles](#section-3-solution-profiles)
- [Section 4: Evaluation framework](#section-4-evaluation-framework)
- [Section 5: Architectural fit analysis](#section-5-architectural-fit-analysis)
- [Section 6: Total cost of ownership](#section-6-total-cost-of-ownership)
- [Section 7: Risk assessment](#section-7-risk-assessment)
- [Section 8: Gap analysis](#section-8-gap-analysis)
- [Section 9: Improvement candidates](#section-9-improvement-candidates)
- [Section 10: Recommendation](#section-10-recommendation)
- [Appendix A: Sources](#appendix-a-sources)
- [Appendix B: Weight justification](#appendix-b-weight-justification)

---

## Document metadata

Place immediately after the H1 title, before Section 1.

```markdown
- **Status:** Draft | Review | Final
- **Last Updated:** YYYY-MM-DD
- **Classification:** Internal research | Public | Confidential
- **Authors:** [Team or individual name] under human supervision
```

**Rules:**

- Use ISO 8601 date format (YYYY-MM-DD)
- Append "under human supervision" when AI-assisted
- Update the date on every revision

---

## Section 1: Executive summary

**Purpose:** Orient the reader in 30 seconds. A decision-maker reads this section and nothing else. It must contain enough information to act on.

**Required elements (in this order):**

1. **Evaluation scope** - What is being compared and why. Correct false equivalences. If Solution A performs a single step while Solution B covers multiple stages, state that explicitly to prevent unfair downstream comparisons.

2. **Finding** - Neutral factual summary. No recommendation here. Describe the structural relationship: "A and B solve overlapping but structurally different problems. A provides X. B provides Y."

3. **Recommendation** - Decisive. State the action, then support with key numbers: "Retain B. Do not adopt A. B scores 4.45/5.00 against weighted criteria. A scores 2.05/5.00. Three specific features from A are documented in Section 9 as improvement candidates."

**Rules:**

- Keep to one page (~300 words)
- No new information that isn't expanded elsewhere
- Lead with scope, not recommendation. The reader needs context before the conclusion makes sense
- Include quantified evidence in the recommendation (scores, cost multiplier)
- Reference Section 9 if improvements from the rejected solution are worth adopting

---

## Section 2: Scope and methodology

**Purpose:** Establish what the evaluation covers, how it was conducted, and what to watch out for.

**Required subsections:**

### 2.1 Evaluation scope

Use a table with three columns: Dimension, In scope, Out of scope.

```markdown
| Dimension       | In scope                           | Out of scope                     |
| --------------- | ---------------------------------- | -------------------------------- |
| **Solution A**  | [specific product/version]         | [related products not evaluated] |
| **Solution B**  | [specific agents/stages]           | [related components if any]      |
| **Environment** | [platforms, tools, infrastructure] | [platforms not used]             |
```

### 2.2 Methodology

Numbered list of research methods used:

1. Product analysis via official documentation, product pages, blog posts, press coverage
2. Architecture review of internal solution including [specific artifacts reviewed]
3. Evaluation against weighted criteria derived from organizational requirements
4. Risk assessment using probability/impact classification

### 2.3 Key assumptions

Bullet list of facts assumed true for this evaluation. These are conditions that, if false, invalidate parts of the analysis.

### 2.4 Limitations

Bullet list of constraints on the analysis. Intellectual honesty matters here. Typical limitations:

- Product is in beta; feature set and pricing may change
- No hands-on testing was performed
- Analysis based on published documentation and press materials
- Internal solution quality varies by project

**Rules:**

- Be explicit about what was NOT evaluated and why
- Assumptions and limitations prevent the reader from over-generalizing the conclusions
- If hands-on testing was not performed, state that clearly

---

## Section 3: Solution profiles

**Purpose:** Present both solutions with enough detail for a reader unfamiliar with either.

**Structure:** Two subsections (3.1 and 3.2), one per solution. Both must follow identical structure.

**Required fields per solution:**

| Field             | Description                                     |
| ----------------- | ----------------------------------------------- |
| Type              | SaaS, local tool, framework, library, etc.      |
| Launch/maturity   | Release date, version, stability tier           |
| Vendor/maintainer | Company, funding stage, team size if relevant   |
| Mechanism         | How it works at a high level (2-4 sentences)    |
| Output structure  | Table mapping section names to content produced |
| Handoff method    | How output reaches the next step                |
| Generation time   | Time from trigger to output                     |
| Integrations      | Input sources and output targets                |

**The output structure table is critical.** It enables direct comparison of what each solution produces:

```markdown
| Section      | Content                              |
| ------------ | ------------------------------------ |
| Summary      | 2-3 sentence implementation overview |
| Research     | Files identified, patterns detected  |
| Phased Tasks | Logical work chunks                  |
```

**Rules:**

- Both profiles must cover identical fields. If a field is unavailable for one solution, note "Not available" rather than omitting it
- Use tables for structured data, prose for mechanism description
- State generation time as a range, not a point estimate
- Include handoff method (this reveals automation vs manual steps)

---

## Section 4: Evaluation framework

**Purpose:** Score both solutions against weighted criteria with full transparency. The reader must be able to verify every number.

**Required subsections:**

### 4.1 Criteria and weights

Table with columns: #, Criterion, Weight, Rationale.

```markdown
| #   | Criterion                | Weight | Rationale                                           |
| --- | ------------------------ | ------ | --------------------------------------------------- |
| C1  | Pipeline integration     | 25%    | Plans must feed downstream agents without manual... |
| C2  | Architecture enforcement | 20%    | Plans must respect project-specific constraints...  |
```

- Assign identifier codes (C1, C2, ...) for cross-referencing
- Weights must sum to exactly 100%
- Each rationale explains why this weight, not a higher or lower one

### 4.2 Scoring rubric

Define the 1-5 scale with clear semantic anchors:

```markdown
| Score | Meaning                                          |
| ----- | ------------------------------------------------ |
| 5     | Fully meets requirement with clear advantage     |
| 4     | Meets requirement well                           |
| 3     | Adequate, no significant gaps                    |
| 2     | Partially meets requirement, notable gaps        |
| 1     | Does not meet requirement or introduces problems |
```

### 4.3 Evaluation matrix

The core of the analysis. Table with columns: #, Criterion (weight), Solution A [description], Score, Solution B [description], Score.

**Each cell must contain evidence**, not just a number. A score without justification is an opinion, not an evaluation.

```markdown
| C1 | Pipeline integration (25%) | Produces plans with copy/paste handoff... | **1** | Plan feeds directly into Coder agent... | **5** |
```

### 4.4 Weighted scores

Show the full calculation for each solution:

```markdown
| Solution   | Calculation                                | Total    |
| ---------- | ------------------------------------------ | -------- |
| Solution A | (1 x 0.25) + (1 x 0.20) + (2 x 0.15) + ... | **2.05** |
| Solution B | (5 x 0.25) + (5 x 0.20) + (5 x 0.15) + ... | **4.45** |
```

After the table, add narrative analysis:

- State the gap and what drives it ("The gap is driven by C1 and C2, which carry 45% of the weight")
- Run a **sensitivity check**: "If C1 and C2 are removed entirely and weight redistributed, Solution B still scores higher due to advantages in C3, C6, and C7."
- The sensitivity check tests whether the conclusion depends on one or two criteria. If removing the dominant criteria flips the result, the recommendation is fragile and needs stronger justification for those weights

See [evaluation methodology](evaluation-methodology.md) for weight calibration and sensitivity analysis techniques.

---

## Section 5: Architectural fit analysis

**Purpose:** Analyze how each solution fits into the existing technical architecture. This goes beyond feature comparison into structural compatibility.

**Required subsections:**

### 5.1 Integration topology

Two Mermaid diagrams showing how each solution connects to the broader system. Place them side by side (one after the other) for comparison.

For the inferior integration, highlight problems with red nodes and annotate issues beneath the diagram:

```markdown
Problems:

- Manual copy/paste breaks automation
- Translation layer adds complexity and failure points
- No governance in the output
```

For the superior integration, annotate properties:

```markdown
Properties:

- All handoffs are file-based (markdown artifacts in git)
- Each stage produces a reviewable artifact
- Governance applies at every stage
```

### 5.2 Separation of concerns

If the solutions differ in how they divide responsibility, analyze the trade-offs. Use a table showing what each component does and does NOT do:

```markdown
| Component | Responsibility  | Does NOT do              |
| --------- | --------------- | ------------------------ |
| Agent A   | Research (WHAT) | Implementation, testing  |
| Agent B   | Planning (WHEN) | Research, implementation |
```

When one solution merges responsibilities that the other separates, analyze the trade-off explicitly. State the advantage of merging (fewer steps, faster) and the disadvantage (no review checkpoint, assumptions propagate unchecked).

Cite research if available. Papers on multi-agent specialization, self-correction limitations, or checkpoint-based workflows strengthen this analysis.

### 5.3 Governance propagation

If relevant, diagram how governance, rules, or constraints flow through each system. This reveals whether plans respect architectural boundaries or ignore them.

---

## Section 6: Total cost of ownership

**Purpose:** Quantify the cost differential over a meaningful time horizon (typically 3 years).

**Required elements:**

### 6.1 Cost model assumptions

State every input to the cost calculation:

- Team size
- Number of active projects
- Usage frequency (plans/month, runs/week)
- Pricing tier used for calculation
- API pricing assumptions
- One-time setup costs

### 6.2 Multi-year comparison

Table with cost categories as rows, solutions as columns:

```markdown
| Cost category            | Solution A (3 years)  | Solution B (3 years)  |
| ------------------------ | --------------------- | --------------------- |
| Subscription / API costs | $X x Y x Z = **$N\*\* | $A x B x C = **$M\*\* |
| One-time setup           | **$P**                | **$Q**                |
| Maintenance (annual)     | **$R/year**           | **$S/year**           |
| **Total (3 years)**      | **~$TOTAL_A**         | **~$TOTAL_B**         |
```

**Rules:**

- Show formulas, not just totals. "$24 x 20 x 36 = $17,280" not just "$17,280"
- Calculate and state the cost multiplier: "The cost differential is approximately 42x over three years"
- Note what's excluded from the calculation
- If enterprise pricing is unavailable, state that and use the available tier

---

## Section 7: Risk assessment

**Purpose:** Identify risks for both solutions with structured classification.

**Required elements:**

### 7.1 Risk matrix

Table with columns: Risk, Probability, Impact, Solution, Mitigation.

```markdown
| Risk                                  | Probability | Impact | Solution   | Mitigation                                 |
| ------------------------------------- | ----------- | ------ | ---------- | ------------------------------------------ |
| R1: Format incompatible with pipeline | Certain     | High   | Solution A | Build and maintain translation layer       |
| R7: Quality depends on governance     | Medium      | Medium | Solution B | Mitigated by existing generator meta-agent |
```

- Use risk identifiers (R1, R2, ...) for cross-referencing
- Probability: Certain, High, Medium, Low
- Impact: High, Medium, Low
- Every risk must name which solution it applies to
- Every risk must have a concrete mitigation (not "address the issue")

### 7.2 Risk assessment summary

Narrative summary: How many risks for each solution, which are high probability/high impact, and whether the high risks are structural or configurable.

"Solution A carries 6 risks, with 2 rated High/High. These are structural problems, not configuration issues."

---

## Section 8: Gap analysis

**Purpose:** Map capabilities that each solution has and the other lacks.

**Structure:** Two subsections, strictly bidirectional.

### 8.1 Capabilities A has that B lacks

Table with columns: Capability, Impact, Addressable internally?

The "Addressable?" column is the most important. It distinguishes between gaps that can be closed through internal development and gaps that are structural.

### 8.2 Capabilities B has that A lacks

Same table structure.

**End with a synthesis statement:**

"The asymmetry is clear: Solution B's gaps are addressable through internal improvements. Solution A's gaps are structural and cannot be addressed without redesigning the product."

This sentence carries the weight of the entire section. If the addressability analysis is strong, this conclusion follows naturally.

---

## Section 9: Improvement candidates

**Purpose:** Extract specific features from the rejected solution that could strengthen the recommended solution.

**Structure:** One subsection per improvement (typically 2-4 improvements).

Each improvement needs:

- **Problem** - What capability is missing
- **Proposed approach** - How to add it (concrete, not vague)
- **Effort estimate** - Small, Medium, or Large with one-sentence reasoning

```markdown
### 9.1 [Improvement name]

**Problem:** Each invocation re-analyzes the codebase from scratch.

**Proposed approach:** Generate a `.project-profile.md` during initialization
that catalogs detected patterns, key file locations, and conventions. The
agent reads this file alongside governance documents. Regenerate when project
structure changes.

**Effort estimate:** Small. The initialization generator already performs this
analysis. Persisting the output requires template modification only.
```

**Rules:**

- Scope improvements as "potential enhancement, not current commitment"
- Be specific enough for someone to act on
- Effort estimates should be honest, not optimistic

---

## Section 10: Recommendation

**Purpose:** Deliver the final decision with enough context for stakeholders to act.

**Required subsections:**

### 10.1 Primary recommendation

One decisive statement. "Retain Solution B. Do not adopt Solution A." Follow with the key evidence (weighted scores, cost multiplier, structural gaps).

### 10.2 Conditions that would change this recommendation

Bullet list of circumstances that would flip the conclusion. These are reversal conditions, not hedging. They demonstrate that the recommendation adapts to changing conditions.

"If Solution A adds structured API output (not copy/paste), pipeline integration becomes feasible."

### 10.3 Recommended next steps

Numbered list, ordered by priority. Reference specific improvement candidates from Section 9.

### 10.4 Re-evaluation schedule

Set a concrete date and state what to evaluate:

"Reassess Solution A in Q3 2026 when the product exits beta. Evaluate whether API output, governance awareness, or pipeline integration have been added."

---

## Appendix A: Sources

**Purpose:** Collect all sources referenced throughout the document.

**Structure:** Group by category:

1. **Solution A sources** - Product pages, documentation, blog posts, press coverage, pricing
2. **Solution B sources** - Internal documentation, repository links
3. **Research** - Academic papers with full citation format

**Academic citation format:**

```markdown
- Author et al., "Title," Venue Year. [arXiv:XXXX.XXXXX](https://arxiv.org/abs/XXXX.XXXXX)
  -- Cited in Sections X, Y. [One sentence explaining relevance.]
```

The "cited in" annotation helps readers understand why this paper matters to the evaluation. Without it, the bibliography is decorative.

**Product documentation format:**

```markdown
- [Human-readable label](https://url)
```

---

## Appendix B: Weight justification

**Purpose:** Defend every weight assignment from Section 4.1. This appendix exists because weight assignment is the most subjective part of the evaluation. Making the reasoning explicit invites scrutiny and correction.

**Structure:** One paragraph per criterion. Each paragraph explains:

- Why this criterion has this weight
- Why a higher weight would be wrong
- Why a lower weight would be wrong

```markdown
**C1 Pipeline integration (25%):** The highest weight reflects the
organization's core investment in the four-stage pipeline. A planning tool
that doesn't connect to downstream agents negates the pipeline's value
proposition. This is a structural requirement, not a preference.
```

**Rules:**

- Address every criterion from Section 4.1
- Connect weights to organizational context, not abstract reasoning
- Acknowledge trade-offs: "Cost alone doesn't drive the decision. If Solution A scored higher on C1 and C2, the cost premium might be acceptable."
