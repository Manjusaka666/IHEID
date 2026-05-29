# Anti-Involution Essay Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Write a concise (~6 pages body + references) LaTeX essay arguing that China's anti-involution campaign is supply-side reform within the industrial-policy state, not retreat from it, and that without demand-side reform it will export downward price pressure globally.

**Architecture:** 5-section LaTeX essay following the diamond structure: root cause (Section 1) → evidence (Section 2) → two parallel consequences: domestic response (Section 3) and global spillover (Section 4) → synthesis (Section 5). Uses `thebibliography` for references (matching essay 1 pattern), a compact `booktabs` table in Section 2, and `natbib` authoryear citations throughout.

**Tech Stack:** LaTeX (pdflatex), EB Garamond 12pt, single space, natbib, booktabs, hyperref

---

## File Structure

All files live in `/Users/mint/Desktop/china syndrome/essay2/source/`.

| File | Responsibility |
|------|---------------|
| `main.tex` | Document class, packages, title, inputs section files and references |
| `section1.txt` | Section 1: Introduction and the Policy Engine |
| `section2.txt` | Section 2: Overcapacity in the "New Three" (includes table) |
| `section3.txt` | Section 3: Anti-Involution as Domestic Response |
| `section4.txt` | Section 4: Global Spillover — Downward Price Pressure |
| `section5.txt` | Section 5: Tensions and Outlook |
| `references.txt` | `thebibliography` block with 16 entries |

---

### Task 1: Create the LaTeX scaffold

**Files:**
- Create: `source/main.tex`

- [ ] **Step 1: Create the source directory**

```bash
mkdir -p "/Users/mint/Desktop/china syndrome/essay2/source"
```

- [ ] **Step 2: Write main.tex**

```latex
\documentclass[12pt]{article}

\usepackage[margin=1in]{geometry}
\usepackage[lining]{ebgaramond}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{setspace}
\singlespacing
\usepackage[authoryear,round]{natbib}
\usepackage{hyperref}
\usepackage{xurl}
\usepackage{booktabs}

\title{Anti-Involution and Exported Deflation:\\
China's New Supply-Side Reform and the Global Spillovers\\
of Green Industrial Overcapacity}
\author{MINT427 --- The China Syndrome\\
Geneva Graduate Institute, Spring 2025--2026}
\date{}

\begin{document}

\maketitle

\input{section1.txt}

\input{section2.txt}

\input{section3.txt}

\input{section4.txt}

\input{section5.txt}

\input{references.txt}

\end{document}
```

- [ ] **Step 3: Verify compilation with empty section stubs**

Create empty placeholder files for all section and reference files, then compile:

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
touch section1.txt section2.txt section3.txt section4.txt section5.txt references.txt
pdflatex main.tex
```

Expected: compiles with no errors, produces a PDF with title only.

- [ ] **Step 4: Commit**

```bash
git add source/main.tex source/section*.txt source/references.txt
git commit -m "scaffold: LaTeX essay structure for anti-involution essay"
```

---

### Task 2: Write the bibliography (references.txt)

**Files:**
- Create: `source/references.txt`

This task comes before the section writing so that `\citep` and `\citet` keys are defined when sections compile. The bibliography uses `thebibliography` environment (matching essay 1), not a `.bib` file.

- [ ] **Step 1: Write references.txt with all 16 core references**

Each entry uses a short citation key (e.g., `BranstetterLi2022`, `FangLiLu2025`). The entries must exactly match the verified metadata from the reference checker review. The 16 core references are:

1. `BranstetterLi2022` — Branstetter & Li, NBER WP 30676 (also Research Policy 2024)
2. `BranstetterLiRen2022` — Branstetter, Li & Ren, NBER WP 30699
3. `EUParliament2026` — European Parliament, Industrial Overcapacities
4. `FangLiLu2025` — Fang, Li & Lu, NBER WP 33814
5. `FangLiWu2022` — Fang, Li & Wu, NBER WP 30780 (corrected authors)
6. `IMF2026` — IMF Article IV 2026
7. `KleinPettis2020` — Klein & Pettis, Trade Wars Are Class Wars
8. `MERICS2025` — Beyond Overcapacity
9. `NBS2026PPI` — NBS PPI December 2025
10. `OECD2025Subsidies` — State of Play of Industrial Subsidies as of 2023
11. `OECD2026Solar` — Subsidies and the Solar Panel Industry
12. `RotunnoRuta2024` — IMF WP 2024/180
13. `StateCouncil2025NEV` — Premier meeting on NEV competition
14. `StateCouncil2025Market` — Unified national market guideline
15. `USCC2025` — 2025 Annual Report, Chapter 8
16. `WorldBank2025` — China Economic Update Dec 2025

```latex
\begin{thebibliography}{99}

\bibitem[Branstetter and Li(2022)]{BranstetterLi2022}
Branstetter, Lee~G., and Guangwei Li. 2022. ``Does `Made in China 2025' Work for China? Evidence from Chinese Listed Firms.'' \textit{NBER Working Paper} No.~30676. Also published in \textit{Research Policy} 53 (6), 2024.

\bibitem[Branstetter et~al.(2022)]{BranstetterLiRen2022}
Branstetter, Lee~G., Guangwei Li, and Mengjia Ren. 2022. ``Picking Winners? Government Subsidies and Firm Productivity in China.'' \textit{NBER Working Paper} No.~30699.

\bibitem[European Parliament(2026)]{EUParliament2026}
European Parliament. 2026. ``Industrial Overcapacities, with a Focus on China.'' Directorate-General for External Policies, EXPO\_STU(2026)783610.

\bibitem[Fang et~al.(2025)]{FangLiLu2025}
Fang, Hanming, Ming Li, and Guangli Lu. 2025. ``Decoding China's Industrial Policies.'' \textit{NBER Working Paper} No.~33814.

\bibitem[Fang et~al.(2022)]{FangLiWu2022}
Fang, Hanming, Ming Li, and Zenan Wu. 2022. ``Tournament-Style Political Competition and Local Protectionism: Theory and Evidence from China.'' \textit{NBER Working Paper} No.~30780.

\bibitem[IMF(2026)]{IMF2026}
International Monetary Fund. 2026. \textit{People's Republic of China: 2025 Article IV Consultation.} IMF Country Report No.~2026/044.

\bibitem[Klein and Pettis(2020)]{KleinPettis2020}
Klein, Matthew~C., and Michael Pettis. 2020. \textit{Trade Wars Are Class Wars.} New Haven: Yale University Press.

\bibitem[MERICS(2025)]{MERICS2025}
Zenglein, Max~J., and Jacob Gunter. 2025. ``Beyond Overcapacity: Chinese-Style Modernization and the Clash of Economic Models.'' MERICS Report, April 2025.

\bibitem[NBS(2026)]{NBS2026PPI}
National Bureau of Statistics of China. 2026. ``Industrial Producer Price Indexes in December 2025.'' January 12, 2026. \url{https://www.stats.gov.cn/english/PressRelease/202601/t20260112_1962293.html}.

\bibitem[OECD(2025)]{OECD2025Subsidies}
OECD. 2025. ``The State of Play of Industrial Subsidies as of 2023.'' \textit{OECD Policy Briefs} No.~22. Paris: OECD Publishing.

\bibitem[OECD(2026)]{OECD2026Solar}
OECD. 2026. ``Subsidies and the Solar Panel Industry: Too Close to the Sun.'' \textit{OECD Policy Briefs} No.~47. Paris: OECD Publishing.

\bibitem[Rotunno and Ruta(2024)]{RotunnoRuta2024}
Rotunno, Lorenzo, and Michele Ruta. 2024. ``Trade Implications of China's Subsidies.'' \textit{IMF Working Paper} 2024/180.

\bibitem[State Council(2025{\natexlab{a}})]{StateCouncil2025NEV}
State Council of the People's Republic of China. 2025a. ``Chinese Premier Chairs Meeting on Internal Circulation, NEV Industry Competition.'' July 17, 2025. \url{https://english.www.gov.cn/news/202507/17/content_WS68782fb8c6d0868f4e8f438d.html}.

\bibitem[State Council(2025{\natexlab{b}})]{StateCouncil2025Market}
State Council / NDRC. 2025b. ``China Unveils Guideline for Building Unified National Market.'' January 7, 2025. \url{https://english.www.gov.cn/policies/policywatch/202501/07/content_WS677d2d7dc6d0868f4e8ee95a.html}.

\bibitem[USCC(2025)]{USCC2025}
U.S.-China Economic and Security Review Commission. 2025. \textit{2025 Annual Report to Congress}, Chapter~8: ``China Shock 2.0.''

\bibitem[World Bank(2025)]{WorldBank2025}
World Bank. 2025. \textit{China Economic Update, December 2025: Advancing Reforms, Enhancing Prospects.}

\end{thebibliography}
```

- [ ] **Step 2: Compile to check for bibliography errors**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex
```

Expected: compiles without undefined citation warnings (sections are still empty so no `\citep` calls yet).

- [ ] **Step 3: Commit**

```bash
git add source/references.txt
git commit -m "add: bibliography with 16 verified references"
```

---

### Task 3: Write Section 1 — Introduction and the Policy Engine

**Files:**
- Create: `source/section1.txt`

**Spec guidance:** Present the paradox, state the thesis, lay out the 5-link causal mechanism. Write concisely — aim for tight academic prose. End with the theoretical prediction, NOT empirical evidence.

**Citation keys to use:** `BranstetterLi2022`, `BranstetterLiRen2022`, `FangLiLu2025`, `FangLiWu2022`, `RotunnoRuta2024`

- [ ] **Step 1: Write section1.txt**

The section must contain:
- `\section{Introduction and the Policy Engine}`
- Opening hook: China's clean-tech success is also its most destabilizing industrial-policy outcome
- Thesis: Anti-involution is supply-side reform within the model, not retreat. Without demand-side reform, it exports downward price pressure.
- The 5-link causal mechanism (as a flowing argument, not a numbered list):
  1. Central targeting of strategic sectors
  2. Local tournament competition (cite `FangLiWu2022`; connect to regionally decentralized authoritarianism frameworks from the course)
  3. Soft budget constraint — state banks and LGFVs absorb losses (this distinguishes state-directed overcapacity from normal overinvestment)
  4. Firms expand for scale not profitability; subsidies don't produce proportional productivity gains (cite `BranstetterLi2022`, `BranstetterLiRen2022`)
  5. Domestic demand insufficient → price wars → export pressure
- Policy diffusion: Fang, Li & Lu (2025) show local governments imitate peer policies, creating duplicated capacity across hundreds of cities
- Transition sentence: the mechanism predicts overcapacity in centrally targeted sectors; the "New Three" provide the test case

**Writing style:** Match essay 1's dense, citation-rich academic prose. Every claim is sourced. No rhetorical filler. Use `\citep{}` for parenthetical citations and `\citet{}` for textual citations.

- [ ] **Step 2: Compile and check**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
```

Expected: compiles, section 1 renders. Check for undefined citation warnings — all `\citep`/`\citet` keys must match `references.txt`.

- [ ] **Step 3: Commit**

```bash
git add source/section1.txt
git commit -m "add: Section 1 — introduction and policy engine mechanism"
```

---

### Task 4: Write Section 2 — Overcapacity in the "New Three"

**Files:**
- Create: `source/section2.txt`

**Spec guidance:** Open directly with evidence — no mechanism restatement. Domestic capacity/demand data ONLY (trade flow data goes in Section 4). Include the compact `booktabs` table. Handle the contested overcapacity definition in 2 sentences, not a paragraph.

**Citation keys to use:** `OECD2026Solar`, `IMF2026`, `USCC2025`, `NBS2026PPI`, `MERICS2025`, `OECD2025Subsidies`

- [ ] **Step 1: Write section2.txt**

The section must contain:
- `\section{Overcapacity in the ``New Three''}`
- Solar PV paragraph: >1 TW/yr capacity vs ~500 GW demand, module prices >50% decline, 80%+ market share, OECD MAGIC database (3.2% of revenue subsidized vs 0.9% avg)
- Lithium-ion batteries paragraph: ~85% of global cell production, 2024 capacity ~2,500 GWh vs ~1,100 GWh demand
- EVs paragraph: share of loss-making firms doubled (12% to >22%), price wars post-subsidy phase-out, PPI deflation -2.6% full-year 2025
- A `booktabs` table:

```latex
\begin{table}[h]
\centering
\small
\begin{tabular}{@{}lcccc@{}}
\toprule
Sector & China Capacity & Global Demand & Utilisation & Price Trend (2023--25) \\
\midrule
Solar PV & $>$1 TW/yr & $\sim$500 GW & $\sim$50\% & $>$50\% decline \\
Li-ion batteries & $\sim$2{,}500 GWh & $\sim$1{,}100 GWh & $\sim$44\% & $\sim$40\% decline \\
EVs & $\sim$40M units/yr & $\sim$22M units & $\sim$55\% & $\sim$30\% decline \\
\bottomrule
\end{tabular}
\caption{Overcapacity indicators in China's ``New Three'' clean-tech sectors. Utilisation rates use nameplate capacity. Sources: \citet{OECD2026Solar}; \citet{IMF2026}; \citet{USCC2025}.}
\label{tab:overcapacity}
\end{table}
```

- Two-sentence contested-definition note: Beijing vs. OECD/IMF framing. Essay follows the structural interpretation.

- [ ] **Step 2: Compile and check**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
```

Expected: compiles, table renders, no citation warnings.

- [ ] **Step 3: Commit**

```bash
git add source/section2.txt
git commit -m "add: Section 2 — overcapacity evidence with summary table"
```

---

### Task 5: Write Section 3 — Anti-Involution as Domestic Response

**Files:**
- Create: `source/section3.txt`

**Spec guidance:** This is the analytical core. Three parts: (A) define involution-style competition, (B) list policy instruments concisely, (C) present the strongest counterargument (Japan MITI precedent) and rebut it with three structural differences. The rebuttal is where the thesis is argued most directly.

**Citation keys to use:** `StateCouncil2025NEV`, `StateCouncil2025Market`, `WorldBank2025`, `MERICS2025`, `KleinPettis2020`

- [ ] **Step 1: Write section3.txt**

The section must contain:
- `\section{Anti-Involution as Domestic Response}`
- Part A: Define neijuan shi jingzheng (内卷式竞争). Excessive competition that compresses margins without improving productivity.
- Part B: Policy instruments — July 2025 State Council NEV meeting (cite `StateCouncil2025NEV`), unified national market guideline (cite `StateCouncil2025Market`), specific instruments (quality standards, consolidation, KPI shifts). Note these are administrative tools, not market-liberalizing reforms.
- Part C: Counterargument — Japan's MITI-era kato kyoso administrative guidance. Engage seriously.
  - Rebuttal point 1: Demand-side gap (Japan had rising household income; China has weak consumption, ~34% savings rate, property crisis, no social safety net) — cite `KleinPettis2020`, `WorldBank2025`
  - Rebuttal point 2: Local fiscal incentives unreformed (land sales, industrial project dependence)
  - Rebuttal point 3: Scale (hundreds of competing cities)
- Conclusion: anti-involution is administrative correction, not structural reform. Manages the problem, doesn't solve it.

- [ ] **Step 2: Compile and check**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
```

- [ ] **Step 3: Commit**

```bash
git add source/section3.txt
git commit -m "add: Section 3 — anti-involution analysis with MITI counterargument"
```

---

### Task 6: Write Section 4 — Global Spillover

**Files:**
- Create: `source/section4.txt`

**Spec guidance:** Focus on China's export behavior and price transmission. Trade flow data domain only (domestic capacity was Section 2). Three parts: (A) China Shock 2.0 framing with export-type distinction, (B) evidence of downward price pressure, (C) green-public-goods counterargument with rebuttal. Use "downward price pressure" not "exported deflation."

**Citation keys to use:** `USCC2025`, `RotunnoRuta2024`, `EUParliament2026`, `FangLiLu2025`

- [ ] **Step 1: Write section4.txt**

The section must contain:
- `\section{Global Spillover: Downward Price Pressure}`
- Part A: Original China Shock (Autor, Dorn, Hanson 2013) = comparative advantage in labor-intensive goods. Current wave = state-directed overcapacity in capital-intensive green tech. Mechanism different (subsidised vs market-driven), scale comparable, welfare calculus more complex. Distinguish: (a) strategic export-oriented capacity (BYD Thailand/Hungary) vs (b) residual dumping from domestic margin collapse.
- Part B: Rising export volumes + falling unit values (cite `USCC2025`, `RotunnoRuta2024`). One sentence on RMB depreciation amplifying competitiveness. Precise language: "downward price pressure."
- Part C: Green-public-goods counterargument — cheap Chinese solar/batteries accelerate decarbonization, especially for developing countries. This is the strongest objection. Response: (1) concentrated adjustment costs on specific sectors/workers, (2) supply-chain vulnerability from single-source dependence, (3) trade policy responses (US 100% EV tariff, EU 17.4-37.6% duties) already fragmenting markets and undermining the welfare gain.

- [ ] **Step 2: Compile and check**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
```

- [ ] **Step 3: Commit**

```bash
git add source/section4.txt
git commit -m "add: Section 4 — global spillover with green-public-goods counterargument"
```

---

### Task 7: Write Section 5 — Tensions and Outlook

**Files:**
- Create: `source/section5.txt`

**Spec guidance:** Synthesize, don't introduce new evidence. One scenario (muddled middle), not two. Restate thesis.

**Citation keys:** Minimal — synthesis section.

- [ ] **Step 1: Write section5.txt**

The section must contain:
- `\section{Tensions and Outlook}`
- Central tension: anti-involution addresses the symptom (destructive price competition) but not the disease (insufficient domestic demand). China needs both production-side discipline AND demand-side reform (household consumption, social protection, local fiscal restructuring). Anti-involution delivers only the first.
- Most likely outcome: muddled middle — partial consolidation in some sectors (solar), continued overcapacity in others (EVs, where local government stakes are highest), differentiated trade responses, ongoing tension. Green-transition benefit and industrial-disruption cost coexist uncomfortably.
- Thesis restated: anti-involution reveals the contradiction in China's growth model. The state that created overcapacity through industrial policy now tries to regulate it. Reform within the model, not retreat from it. Success depends on demand-side shift, not administrative discipline. Until then, the global economy absorbs the spillover.

- [ ] **Step 2: Compile full essay**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
```

Expected: full essay compiles, no warnings.

- [ ] **Step 3: Commit**

```bash
git add source/section5.txt
git commit -m "add: Section 5 — tensions, outlook, and thesis restatement"
```

---

### Task 8: Final compilation, page count check, and trimming

**Files:**
- Modify: all `source/*.txt` files as needed

- [ ] **Step 1: Full compilation (two passes for references)**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
```

- [ ] **Step 2: Check page count**

```bash
pdfinfo main.pdf | grep Pages
```

Target: ~6 pages body + ~1 page references = ~7 pages total. Hard ceiling: 10 pages total.

- [ ] **Step 3: If over target, trim**

Read the compiled PDF. Identify which sections are verbose. Trim based on what the actual prose reveals is redundant — not arbitrary word-count targets. Priority cuts:
- Elaboration that restates what the mechanism already implies
- Policy instrument enumeration that could be consolidated
- Evidence that duplicates what the table already shows
- Rebuttal points that could be merged

- [ ] **Step 4: Re-compile and verify**

```bash
cd "/Users/mint/Desktop/china syndrome/essay2/source"
pdflatex main.tex && pdflatex main.tex
pdfinfo main.pdf | grep Pages
```

- [ ] **Step 5: Final commit**

```bash
git add source/
git commit -m "complete: anti-involution essay — final version"
```

---

## Execution Notes

- **Writing style reference:** Essay 1 at `/Users/mint/Desktop/china syndrome/essay/source/` — dense academic prose, every claim cited, `\citep` for parenthetical and `\citet` for textual citations, no rhetorical filler.
- **Brevity priority:** The syllabus says "prioritize brevity and articulate explanations." Write each section as concisely as the argument allows. Don't pad. Don't pre-set word counts — let the argument's natural length determine the prose, then trim what's genuinely redundant.
- **Spec location:** Full design spec at `/Users/mint/Desktop/china syndrome/essay2/docs/superpowers/specs/2026-05-20-anti-involution-essay-design.md` — consult for detailed section guidance, citation keys, and all three reviewer reports.
- **No git repo:** The essay2 directory is not in a git repository. **Skip all git commit steps** in every task. Focus on file creation and compilation only.
