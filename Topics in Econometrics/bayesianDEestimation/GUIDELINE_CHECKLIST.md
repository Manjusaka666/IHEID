# Term Paper Guidelines Checklist (EI137)

Source: `MM_TermPaperGuidelines.pdf` (Marko Mlikota, 2025-02-18). This checklist defines **hard constraints** for the *submission* build.

## Required Structure (Term Paper)
- [ ] **Title page** (title/subtitle, name, university, course, semester, professor, date, etc.)
- [ ] **Abstract** on a **separate page** right after the title page
- [ ] **Main text**: Introduction + intermediate sections (body) + Conclusion
- [ ] **References/Bibliography**
- [ ] **Appendix** (secondary/tertiary material; may be referenced from main text)

## Length Constraint (Main Part)
- [ ] **Main part length**: **5–10 pages**
- [ ] Main part corresponds to the **main text** (Introduction through Conclusion)
- [ ] Appendix material (long algebra, data treatment details, robustness/secondary results) should be **moved out of the main text**

## Formatting (Hard Requirements)
- [ ] Font: **commonly used**, **12pt**
- [ ] Line spacing: **1.25**
- [ ] Paper size: **A4 or US letter**
- [ ] Margins: **3cm** on all sides
- [ ] Page numbering:
  - [ ] **Title page unnumbered**
  - [ ] Pages before Introduction (abstract/ToC/etc.) in **roman numerals** (lower case i, ii, …)
  - [ ] **Arabic numbering starts at page 1 of the Introduction**
  - [ ] Appendix pages may be numbered continuously or separately (either is acceptable)
- [ ] Citations: **in-text** citations (not footnote-only; not numeric-only) + **APA-style bibliography**
- [ ] Numbering: footnotes, tables, and figures use **arabic numbers** and are **continuously numbered** throughout the paper

## Tables and Figures
- [ ] Short, clear titles for tables/figures
- [ ] Detailed explanation in **footnote-sized** notes below each table/figure
- [ ] Main text provides interpretation; notes allow understanding without relying on the main text
- [ ] Sensible row/column names; avoid raw variable names; use an appropriate number of digits
- [ ] All tables/figures/equations referenced via `\label{}` / `\ref{}` (or equivalent)

## Writing Rules (Graded Heavily)
- [ ] Abstract: 1–3 sentences each on (i) question + relevance, (ii) methods, (iii) main results
- [ ] Introduction:
  - [ ] Get to the point quickly; by end of page 1 state contribution, what is done, and headline results
  - [ ] Literature review is the **second part** of the introduction and is organized by **how this paper contributes**
- [ ] Intermediate sections:
  - [ ] Each section opens with a short “purpose” paragraph and closes with a short “takeaway” paragraph
  - [ ] Avoid too many details in the main text; move long algebra/data treatment/secondary results to the appendix
  - [ ] **No lonely subsection rule**: each section has either **0 subsections** or **at least 2**
- [ ] Results discussion:
  - [ ] Lead with main takeaways in words, then corroborate with the most diagnostic numbers
  - [ ] Do not discuss every coefficient/row; keep focus on 1–few messages
- [ ] Conclusion:
  - [ ] Even **shorter than the abstract**
  - [ ] No new results; give a disciplined outlook/future work

## Reproducibility Expectations
- [ ] Results are reproducible from raw data without undocumented edits
- [ ] Code used to generate results and a short replication note are provided (zip/GitHub acceptable; special rules if data is confidential)

