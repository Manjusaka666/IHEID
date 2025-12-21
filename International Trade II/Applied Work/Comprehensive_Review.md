# Applied Work 全面专业审查报告

## 总体评价

**优点：**
- 结构完整，回答了所有问题(a-m)
- R代码实现正确，生成了所有必要的表格
- 理论框架基本正确，显示了对重力模型和计量经济学的良好理解

**主要问题：**
1. **数据一致性**：文本中的系数与代码生成的表格不一致（已在前一份反馈中详述）
2. **理论解释深度不足**：部分关键概念需要更详细的阐述
3. **结果解释不够全面**：未充分讨论某些规格之间的对比
4. **遗漏重要分析**：Question h的年度回归结果应该包含并分析

---

## 逐题专业审查

### Question a: Rose引言评论 ⭐⭐⭐⭐☆

**理论准确性：✓ 优秀**
- τ^{-5} ≈ 3.35 → τ ≈ 0.78的计算正确
- 22%贸易成本降低的推导合理
- 遗漏变量偏误的论述恰当

**需要改进：**

1. **更明确的文献联系**
   - 当前：提到了Rose & Stanley (2005)
   - 建议：明确指出这是Baldwin & Taglioni (2006)框架中"Gold Medal Mistake"的例子
   
2. **替代性解释**
   - 补充：可能还包括**选择性偏误**（Rose样本中的CU多为小国或特殊安排）
   - 补充：提及**时间维度问题**（主要依赖cross-sectional variation）

**修改建议：**
```latex
... thereby biasing the coefficient upwards. This cross-sectional approach exemplifies 
what Baldwin \& Taglioni (2006) term the "Gold Medal Mistake"—the failure to account 
for multilateral resistance terms and time-invariant bilateral heterogeneity.

Additionally, Rose's sample includes a disproportionate number of small, post-colonial 
currency unions (e.g., CFA franc zone), which may not be representative of larger, 
more developed currency areas like the Euro zone.
```

---

### Question b: 机制和预期效应 ⭐⭐⭐⭐☆

**完整性：✓ 良好，但可补充**

**已包含机制（5个）：** 汇率不确定性、交易成本、价格透明度、政策协调、信号效应

**建议补充：**
- **网络效应**：CU可能促进更深层次的金融一体化
- **固定成本降低**：企业进入新市场的沉没成本减少

**大/小效应的讨论：**
- 当前回答合理，但可以更具体
- 建议：给出文献中的经验证据范围
  
**修改建议：**
```latex
\subsection*{Reasons for expecting a large effect:}
\begin{itemize}
    \item High initial trade costs and exchange rate volatility.
    \item Trade in differentiated goods with high elasticity of substitution 
          (\textit{empirical estimates suggest $\sigma \in [5, 10]$}).
    \item Weak monetary policy credibility prior to union.
    \item \textbf{[NEW]} Network effects in production chains requiring stable 
          cross-border coordination.
\end{itemize}
```

---

### Question c: 数据构建 ⭐⭐☆☆☆

**主要问题：关键统计数字被注释掉了**

**当前状态：**
```latex
% \text{Number of observations: } 102,018 \\
% \text{Number of unique country pairs: } 22,124 \\
```

**建议：取消注释并更新为实际数字**

从代码输出看：
- Observations: 361,100 (原始) → 约100,578 (回归用)  
- 10 years (1960, 1965, ..., 2005)
- Mean CU share: 变化从3.7% (1960) 到 1.43% (2005)

**修改建议：**
```latex
\section*{Question c: Data Construction and Summary}

The gravity dataset was constructed by merging:
\begin{itemize}
    \item Bilateral trade flows from DOTS (1960-2005, every 5 years): 361,100 observations
    \item GDP and population data from Penn World Tables
    \item RTA and CU dummies (time-varying)
    \item Time-invariant geographic variables from CEPII (distance, language, colonial ties, etc.)
\end{itemize}

\textbf{Summary statistics:}
\begin{itemize}
    \item \textbf{Final regression sample:} Approximately 100,578 observations with complete data
    \item \textbf{Years:} 10 time periods (1960, 1965, \ldots, 2005)
    \item \textbf{CU participation:} Ranges from 3.7\% of country pairs (1960) to 1.4\% (2005)
    \item \textbf{RTA participation:} Increased from 2.8\% (1960) to 7.6\% (2005)
    \item \textbf{Trade value:} Mean trade flows show strong growth over time, 
          reflecting both real trade expansion and nominal effects
\end{itemize}

The low and declining share of CU pairs indicates that identification of the currency 
union effect relies on a small subset of observations, which may affect statistical 
power and external validity.
```

---

### Question d: RTA/CU演变 ⭐⭐⭐☆☆

**数据呈现：✓ 描述了趋势，但缺少具体数字表格**

**建议：**
1. 恢复被注释的表格（见原文line 233-253）
2. 或者创建一个简洁的summary table
3. 确保提及图表（Figure 1）已经生成

**修改建议：**
```latex
Table 1 summarizes the evolution of RTA and CU participation over time.

\begin{table}[H]
\centering
\caption{Evolution of RTA and CU Shares}
\begin{tabular}{lccccc}
\toprule
Year & CU Pairs (\%) & RTA Pairs (\%) & CU Trade (\%) & RTA Trade (\%) \\
\midrule
1960 & 3.7 & 2.8 & 7.7 & 9.5 \\
1980 & 0.9 & 1.1 & 0.1 & 27.4 \\
2005 & 1.4 & 7.6 & 2.5 & 54.7 \\
\bottomrule
\end{tabular}
\end{table}

\textbf{Key insights:}
\begin{itemize}
    \item The \textbf{divergence} between pair shares and trade-weighted shares 
          (especially for RTAs) indicates that larger, more trade-intensive countries 
          are more likely to form trade agreements.
    \item The spike in trade-weighted CU share in 2000-2005 corresponds to the 
          introduction of the Euro, involving major European economies.
\end{itemize}
```

---

### Question e(a): Krugman模型系数 ⭐⭐⭐☆☆

**理论问题：对系数的解释不准确**

**当前文本：**
> "coefficients... approach 1 when country fixed effects are included (1.22 and 0.74)"

**问题：**
- 1.22 ≠ "approaching 1"（显著大于1）
- 0.74 ≠ "approaching 1"（显著小于1）

**正确解释：**
1. **Without country FE**: 系数 < 1是因为遗漏变量偏误（未控制MRT和国家特征）
2. **With country FE**: 
   - ln_gdp_o = 1.22 > 1：可能反映了**国内市场潜力**或**规模经济**（"market capacity effect"）
   - ln_gdp_d = 0.72 < 1：进口国GDP的弹性较小可能表明饱和效应

**修改建议：**
```latex
Thus, the theoretical coefficients on $\ln Y_i$ and $\ln Y_j$ are \textbf{exactly 1}. 

In our estimations:
\begin{itemize}
    \item \textbf{Specifications (1)-(3) without country FE:} Coefficients on ln\_gdp\_o 
          and ln\_gdp\_d are 0.6-0.8, \textbf{below the theoretical prediction}. This 
          downward bias likely arises from omitted multilateral resistance terms and 
          country-specific characteristics (the "Gold Medal Mistake").
    
    \item \textbf{Specification (4) with country FE:} Coefficients are 1.22 (origin) 
          and 0.72 (destination). The \textbf{origin coefficient exceeds unity}, which 
          may reflect domestic market capacity effects or the fact that exporter fixed 
          effects absorb some of the true GDP elasticity. The \textbf{destination 
          coefficient remains below unity}, consistent with the literature finding 
          asymmetric import elasticities.
\end{itemize}

While not exactly 1.0, these estimates are more consistent with theory than the 
specifications without country fixed effects.
```

---

### Question h: 年度回归 ⭐⭐☆☆☆

**严重遗漏：结果已生成但未分析**

**当前文本：**
> "Although the year-by-year regression results are not shown..."

**实际情况：**
- 代码生成了`table h_yearly_cu.tex`
- 结果显示了**极其重要的时间趋势**：CU效应从1970年代的1.45下降到2005年的0.215（不显著）

**这是关键发现！必须讨论！**

**修改建议：**
```latex
\section*{Question h: Year-by-Year Regressions with Country Fixed Effects}

\input{table h_yearly_cu.tex}

The year-by-year estimation results reveal a \textbf{striking temporal pattern} in 
the currency union effect:

\begin{itemize}
    \item \textbf{1960-1990}: The CU coefficient is large and highly significant, 
          ranging from 0.60 to 1.45. In 1970, the effect peaks at 1.45***, implying 
          that currency unions more than \textbf{quadrupled} trade 
          ($e^{1.45} \approx 4.26$).
    
    \item \textbf{1995 onwards}: The effect declines sharply. By 2000, the coefficient 
          is 0.008 (statistically zero), and in 2005 it is 0.215 (insignificant).
\end{itemize}

\subsection*{Interpretation:}

This pattern suggests that:
\begin{enumerate}
    \item \textbf{Composition effect}: Early CUs (e.g., CFA franc zone, OECS) involved 
          small, post-colonial economies with limited prior trade. The large effects may 
          reflect \textit{specific institutional arrangements} rather than the causal 
          impact of currency unions per se.
    
    \item \textbf{Euro's different nature}: The Euro, introduced in 1999-2002, dominates 
          the recent CU observations. Its smaller (or null) effect may be because:
          \begin{itemize}
              \item Eurozone members were \textbf{already highly integrated} through the 
                    Single Market and prior exchange rate mechanisms (ERM).
              \item The Euro eliminated fewer barriers than traditional CUs.
          \end{itemize}
    
    \item \textbf{Methodological lesson}: Using country固定效应 year-by-year is more 
          appropriate than pooling all years with a single CU coefficient, as the effect 
          is clearly \textbf{heterogeneous across time}.
\end{enumerate}
```

---

### Question i: Pair FE ⭐⭐⭐⭐☆

**理论正确，但可以更清晰**

**当前优点：**
- 识别了advantages和weaknesses
- 提到了3个critiques（reverse causality, omitted variables, misspecification）

**需要改进：**
1. **Pair FE解决哪些问题的机制说明不够清楚**
2. **具体例子能帮助理解**

**修改建议：**
```latex
\subsection*{i(1) Country-Pair Fixed Effects as a Solution}

The pair fixed effects specification yields a CU coefficient of \textbf{0.660***}, 
implying a 93\% increase in trade ($e^{0.660} - 1 = 0.93$).

\textbf{How pair FE addresses the three critiques:}

\begin{enumerate}
    \item \textbf{Reverse causality}: Partially addressed. If countries with high 
          \textit{time-invariant} bilateral affinity (e.g., France-Belgium) are more 
          likely to form a CU, pair FE absorb this selection. However, if selection 
          is based on \textit{time-varying} factors (e.g., recent trade growth), 
          pair FE cannot solve this.
    
    \item \textbf{Omitted time-invariant variables}: \textbf{Fully addressed}. All 
          permanent bilateral characteristics (geographic distance, colonial history, 
          cultural ties, legal system similarity) are absorbed by $\alpha_{ij}$.
    
    \item \textbf{Model misspecification}: Partially addressed. By controlling for 
          $\alpha_{ij}$, we reduce functional form errors related to bilateral 
          heterogeneity.
\end{enumerate}

\textbf{Identification strategy:}

The CU coefficient is identified from \textbf{within-pair variation over time}: 
\begin{equation}
\widehat{\beta}_{CU} = \frac{\Delta \ln T_{ij,t}}{\Delta CU_{ij,t}}
\end{equation}

For example, when Austria and Germany adopted the Euro in 1999, we compare their 
bilateral trade before and after this event, controlling for year effects and their 
unique bilateral relationship.

\textbf{Weakness in this context:}

With only 10 time periods and few CU transitions, identification relies on a 
\textbf{small number of "switchers"}. The precision may be limited, and results could 
be driven by specific Euro-related observations.
```

---

### Question j: 高维FE ⭐⭐⭐☆☆

**理论框架正确，需要更强调对比**

**修改建议：**
```latex
\section*{Question j: High-Dimensional Fixed Effects}

\input{table j_structural_gravity.tex}

The structural gravity specifications represent the \textbf{state-of-the-art} approach 
in the literature:

\begin{enumerate}
    \item \textbf{Specification (1) — Time-varying multilateral resistance:} 
          CU coefficient = 0.633***, implying an 88\% increase in trade. 
          
          \textit{What this controls for:} Exporter-year and importer-year fixed effects 
          ($\nu_{it}$ and $\mu_{jt}$) absorb all time-varying country characteristics, 
          including:
          \begin{itemize}
              \item Changing GDP, population, productivity
              \item Evolving trade costs with the rest of the world 
                    (Anderson \& van Wincoop's $P_i$ and $P_j$)
              \item Monetary policy shocks, exchange rate regimes
          \end{itemize}
          
          This addresses Baldwin \& Taglioni's \textbf{"Silver Medal Mistake"}.

    \item \textbf{Specification (2) — Adding pair FE:} 
          CU coefficient = 0.308***, implying a 36\% increase in trade.
          
          The \textbf{dramatic drop from 0.660 (Table 2) to 0.308} illustrates that:
          \begin{itemize}
              \item Previous pair FE estimates \textit{without} country-year FE were 
                    \textbf{upward biased} due to correlated time-varying shocks.
              \item Example: If two countries simultaneously join a CU \textit{and} 
                    experience faster GDP growth, the simple pair FE model attributes 
                    all the trade increase to the CU.
          \end{itemize}
\end{enumerate}

\textbf{Economic magnitude:}

With the most demanding specification (Spec 2), the currency union effect is 
\textbf{0.308 ≈ 36\% increase}. This is:
\begin{itemize}
    \item Far below Rose's original estimate of 235\% ($e^{1.21} - 1$)
    \item Within the "plausible range" suggested by meta-analyses (30-90\%)
    \item Still economically substantial, but not implausibly large
\end{itemize}
```

---

### Question k: 小国效应 ⭐⭐☆☆☆

**问题：代码已改为连续交互项，但文本仍讨论虚拟变量**

**需要完全重写**（已在第一份反馈中给出）

---

### Question l: PPML ⭐⭐⭐⭐☆

**理论正确，需要更深入的** econometric讨论

**修改建议：**
```latex
\subsection*{Two Main Problems with Log-Linear Gravity Equation}

\begin{enumerate}
    \item \textbf{Zero trade flows (sample selection bias):} 
    
    The log transformation is undefined for zero trade values, forcing researchers to 
    drop these observations. However, zeros are \textbf{not random}:
    \begin{itemize}
        \item Small countries or distant pairs are more likely to have zero trade.
        \item If currency unions \textit{create} trade where none existed before, 
              dropping zeros \textbf{underestimates} the CU effect.
        \item Conversely, if CUs only intensify existing trade, dropping zeros 
              \textbf{overestimates} the effect.
    \end{itemize}
    
    Santos Silva \& Tenreyro (2006) show this creates \textbf{inconsistent} OLS estimates.

    \item \textbf{Heteroskedasticity:}
    
    Trade data exhibit variance proportional to $E[T_{ij}]^2$, violating 
    homoskedasticity. In log-linear models, this implies:
    \begin{equation}
    E[\ln T_{ij} | X] \neq \ln E[T_{ij} | X]
    \end{equation}
    
    due to Jensen's inequality. OLS on the log model is therefore \textbf{inconsistent}.
\end{enumerate}

\subsection*{PPML Estimation Results}

The PPML estimate yields a CU coefficient of \textbf{-0.122} (insignificant), 
implying essentially \textbf{no effect} of currency unions on trade.

\textbf{Why such a different result?}

\begin{itemize}
    \item \textbf{Zero flows matter:} PPML includes 196,999 observations vs.~约120,000 
          in log-linear models. The additional 75,000+ observations with zero or very 
          low trade paint a different picture.
    
    \item \textbf{Efficiency vs. consistency trade-off:} While log-linear models may 
          have lower standard errors, they are \textbf{biased}. PPML sacrifices some 
          precision for consistency.
    
    \item \textbf{Robustness implication:} The positive CU effects in log-linear 
          specifications appear to be \textbf{artifacts} of sample selection and 
          heteroskedasticity, not genuine trade creation.
\end{itemize}
```

---

### Question m: Euro效应 ⭐⭐⭐☆☆

**数据错误已在第一份反馈中指出，这里强调解释深度**

**修改建议：**
```latex
\subsection*{Economic Interpretation}

The \textbf{insignificant (or negative)} Euro effect is consistent with several 
interpretations:

\begin{enumerate}
    \item \textbf{Already-integrated baseline:}
    
    Eurozone members had achieved deep trade integration through:
    \begin{itemize}
        \item The Single Market Program (1992)
        \item The Exchange Rate Mechanism (ERM), which stabilized currencies 
              de facto
        \item Decades of preferential trade agreements
    \end{itemize}
    
    The Euro eliminated \textit{residual} transaction costs that were already small.

    \item \textbf{Trade diversion:}
    
    The Euro may have \textbf{diverted} trade from non-Eurozone to Eurozone partners, 
    leaving total trade unchanged or reduced. When we include pair FE, we cannot detect 
    aggregate trade creation, only relative shifts.

    \item \textbf{Short time horizon:}
    
    Our data end in 2005, only 6-7 years after Euro adoption. Some estimates 
    (e.g., Glick \& Rose 2016) find that currency union effects emerge gradually over 
    decades as firms adjust supply chains.

    \item \textbf{Methodological stringency:}
    
    By controlling for pair FE + year FE with PPML, we impose a very high bar for 
    statistical significance. This guards against false positives but may miss true 
    but small effects.
\end{enumerate}

\subsection*{Comparison with the Literature}

Our null finding aligns with Baldwin et al. (2008), who argue that the Euro's trade 
effect is "elusive" once proper controls are applied. In contrast, studies using 
less rigorous specifications (e.g., without pair FE or using OLS) tend to find 
positive effects—suggesting these are likely spurious.
```

---

## 额外建议

### 1. **缺少的部分：Question c 应该包含数据清理步骤的说明**

建议添加：
```latex
\textbf{Data cleaning steps:}
\begin{enumerate}
    \item Merged five datasets on ISO3 country codes and year
    \item Created log-transformed variables (ln\_trade, ln\_gdp\_o, ln\_gdp\_d, ln\_dist)
    \item Generated pair identifiers for clustering standard errors
    \item Removed observations with missing GDP or trade data (约260,000 obs dropped)
    \item Final estimation sample: 100,578 observations
\end{enumerate}
```

### 2. **学术写作风格**

**当前问题：**
- 使用了一些非正式表达（例如："surprising and interesting"）
- 缺少明确的section transitions

**建议：**
- 每个section开头用一句话总结核心发现
- 避免主观形容词，用数据说话

### 3. **文献引用**

**当前引用：**
- Rose (2004)
- Rose & Stanley (2005)
- Baldwin & Taglioni (2006)
- Anderson & van Wincoop (2003)

**建议补充：**
- **Santos Silva & Tenreyro (2006)** - PPML方法的原始论文
- **Baldwin et al. (2008)** - Euro效应的研究
- **Glick & Rose (2016)** - Currency unions的meta-analysis

---

## 总结

| 问题 | 当前评分 | 主要改进方向 |
|------|---------|------------|
| a. Rose评论 | ⭐⭐⭐⭐☆ | 更明确文献联系 |
| b. 机制 | ⭐⭐⭐⭐☆ | 补充网络效应 |
| c. 数据 | ⭐⭐☆☆☆ | **恢复统计表格** |
| d. 演变 | ⭐⭐⭐☆☆ | 添加summary table |
| e(a). Krugman | ⭐⭐⭐☆☆ | **修正系数解释** |
| e(b-e). 结果 | ✓ | 更新数字 |
| f. Gold Medal | ⭐⭐⭐⭐☆ | 理论已正确 |
| g. Silver/Bronze | ⭐⭐⭐⭐☆ | 可更详细 |
| h. 年度回归 | ⭐⭐☆☆☆ | **必须添加分析** |
| i. Pair FE | ⭐⭐⭐⭐☆ | 更清晰识别策略 |
| j. 高维FE | ⭐⭐⭐☆☆ | 强调对比 |
| k. 小国 | ⭐⭐☆☆☆ | **完全重写** |
| l. PPML | ⭐⭐⭐⭐☆ | 更深入讨论 |
| m. Euro | ⭐⭐⭐☆☆ | **经济学解释** |

**优先级：**
1. 🔴 **高优先级**：Question h（添加年度分析），Question k（重写），Question c（恢复数据表格）
2. 🟡 **中优先级**：所有数字更新，Question e(a)系数解释
3. 🟢 **低优先级**：文献补充，写作风格优化
