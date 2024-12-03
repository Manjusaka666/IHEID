<TeXmacs|2.1.4>

<style|<tuple|generic|number-europe|number-long-article|framed-theorems>>

<\body>
  <doc-data|<doc-title|Macroeconomics A>|<doc-author|<author-data|<author-name|Christopher
  Fu>|<\author-affiliation>
    <with|font-shape|italic|Version>: 23 Sep. 2024
  </author-affiliation>>>>

  <\table-of-contents|toc>
    <vspace*|2fn><with|font-series|bold|math-font-series|bold|font-size|1.19|1<space|2spc>Solow
    Model & Dev Accounting> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-1><vspace|1fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|1<space|2spc>Solow
    model> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-2><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|Reveiw Session>
    <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-3><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|2<space|2spc>Development
    Accounting> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-4><vspace|0.5fn>

    <vspace*|1fn><with|font-series|bold|math-font-series|bold|3<space|2spc>Neoclassical
    Growth Model> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
    <no-break><pageref|auto-5><vspace|0.5fn>
  </table-of-contents>

  <\chapter>
    Solow Model & Dev Accounting
  </chapter>

  <section|Solow model>

  <\eqnarray*>
    <tformat|<table|<row|<cell|Y >|<cell|=>|<cell|F<around*|(|K, L,
    A|)>>>|<row|<cell|>|<cell|=>|<cell|w<rsub|t>L<rsup|s><around*|(|t|)> +
    R<rsub|t>K<rsup|s><around*|(|t|)> + \<Pi\><around*|(|t|)>>>|<row|<cell|>|<cell|=>|<cell|labor
    income + capital income + profits>>>>
  </eqnarray*>

  Rental rate of capital:

  <\equation*>
    R<rsub|t> = F<rsub|K><around*|(|K<around*|(|t|)>, L, A|)> =
    f<rprime|'><around*|(|k<around*|(|t|)>|)>
  </equation*>

  Wage rate:

  <\equation*>
    w<rsub|t> = F<rsub|L><around*|(|K, L<around*|(|t|)>, A|)> =
    f<around*|(|k<around*|(|t|)>|)> - f<rprime|'><around*|(|k<around*|(|t|)>|)>k<around*|(|t|)>
  </equation*>

  <\equation*>
    <with|color|red|k<around*|(|t + 1|)> = <around*|(|1 -
    \<delta\>|)>k<around*|(|t|)> + s f<around*|(|k<around*|(|t|)>|)>>
  </equation*>

  <with|font-series|bold|Steady state:> All variables grow at constant rates.

  For the steady state <math|k<rsup|\<ast\>>>,

  <\equation*>
    \<delta\>k<rsup|\<ast\>> = s f<around*|(|k<rsup|\<ast\>>|)>
  </equation*>

  <\equation*>
    <frac|f<around*|(|k<rsup|\<ast\>>|)>|k<rsup|\<ast\>>> =
    <frac|\<delta\>|s>
  </equation*>

  <section*|Reveiw Session>

  <\question>
    <with|font-series|bold|AK Model> <math|Y = A K + B L>
  </question>

  <\enumerate-alpha>
    <item>Is it neoclassical? \V\V<with|color|red|NO>

    Constant return: <with|color|red|YES>. <math|\<lambda\>Y = A
    <around*|(|\<lambda\>K|)> + B <around*|(|\<lambda\>L|)>>

    Positive & diminishing marginal return: <with|color|red|NO>.
    <math|<frac|\<partial\>Y|\<partial\>K> = A \<gtr\> 0>,
    <math|<frac|\<partial\><rsup|2>Y|\<partial\>K<rsup|2>> =
    0>(<with|color|red|\<times\>>)

    Inada conditions: <with|color|red|NO>. <math|<below|lim|K
    \<rightarrow\>0>A = A>(<with|color|red|\<times\>>)

    <item><math|y = k A + B>, where <math|y = <frac|Y|L>> and <math|k =
    <frac|K|L>>

    marginal product of <math|k>: <math|<frac|\<partial\>y|\<partial\>k> = A>

    average product of <math|k>: <math|<frac|Y|K> = A + B\<cdot\><frac|L|K> =
    A + <frac|B|k>>

    <item>fundamental equation of the Solow model: <math|K<rsub|t+1> =
    <around*|(|1 - \<delta\>|)>K<rsub|t> + I<rsub|t>>, <math|I<rsub|t> = s
    Y<rsub|t> = s f<around*|(|k<rsub|t>|)>>

    <math|<wide|k<rsub|t>|\<dot\>> = s y<rsub|t> - <around*|(|\<delta\>+n|)>
    k<rsub|t>> and <math|<wide|K<rsub|t>|\<dot\>> = s Y<rsub|t> -
    <around*|(|\<delta\> +n|)>K<rsub|t>>, given <math|k = <frac|K|L>>,
    capital depreciating at speed <math|\<delta\>> and population growth rate
    <math|n>: <math|<frac|<wide|L|\<dot\>>|L> = n>.

    <item>(<math|Y = A K + B L>) At the steady state, <math|<wide|k|\<dot\>>
    = 0>, thus <math|<wide|k|\<dot\>> = s y<rsub|t> - <around*|(|n +
    \<delta\>|)>k<rsub|t> = 0>, <math|k = <frac|s B|n + \<delta\> - s A>>

    If <math|n + \<delta\> \<gtr\> s A>, there exists the steady state, yet
    if <math|n + \<delta\> \<less\> s A>, there's no steady state, it's the
    endogenous growth. Increase of population and depreciation of capital
    never counters investment, it forms an endogenous growth.

    <item>(<math|Y = A K + B L>) In the case of <math|n + \<delta\> \<less\>
    s A>, over time, <math|<frac|<wide|K|\<dot\>>|K> = s
    <frac|Y<rsub|t>|K<rsub|t>> - \<delta\> = s<around*|(|A + <frac|B|k>|)> -
    \<delta\>>, as <math|<wide|k|\<dot\>> = s y<rsub|t> - <around*|(|n +
    \<delta\>|)>k<rsub|t> = <around*|(|s A - n - \<delta\>|)>k<rsub|t> + s B
    \<gtr\> 0>, <math|k> keeps increasing. Thus, in the long run, <math|k
    \<rightarrow\> \<infty\>>, and <math|<frac|B|k> \<rightarrow\> 0>,
    <math|<frac|<wide|K|\<dot\>>|K> \<rightarrow\> s A - \<delta\>>.\ 

    For output, <math|<frac|<wide|y|\<dot\>>|y> = <frac|<wide|k|\<dot\>>A|k A
    + B> \<approx\> <frac|<wide|k|\<dot\>>A|k A> = <frac|<wide|k|\<dot\>>|k>
    = s A - <around*|(|n + \<delta\>|)>>.

    For consumption, <math|c<rsub|t> = <around*|(|1 - \<delta\>|)>y<rsub|t>>,
    thus <math|<frac|<wide|c|\<dot\>>|c> = <frac|<wide|y|\<dot\>>|y>
    \<approx\> s A - <around*|(|n + \<delta\>|)>>.

    <item><math|s = 0.4>, <math|A = 1>, <math|B = 2>,<math| \<delta\> =
    0.08>, and <math|n = 0.02>, then <math|>the long-run growth rate of this
    economy is <math|s A - <around*|(|n + \<delta\>|)> = 0.4 -
    <around*|(|0.02 + 0.08|)> = 0.3>, if <math|B> changes, there's no
    difference.
  </enumerate-alpha>

  <\question>
    <with|font-series|bold|Government in the Solow Model> <math|Y<rsub|t> =
    C<rsub|t> + I<rsub|t> + G<rsub|t>>

    <math|G(t)> denoting government spending at time <math|t>. Imagine that
    government spending is given by <math|G(t) = \<sigma\>Y (t)>.

    <\enumerate-alpha>
      <item>Assuming <math|C (t) = s Y(t)> is not very reasonable since it
      implies that consumption for a given level of aggregate income would be
      independent of government spending. Since government spending is
      financed by taxes, it is more reasonable to assume that higher
      government spending would reduce consumption to some extent. As an
      alternative, we may assume that consumers follow the rule of consuming
      a constant share of their after tax income, captured by the functional
      form <math|C (t) = s (Y (t) - G (t))>. Using <math|G (t) =
      \<sigma\>Y(t)>, this functional form is also equivalent to <math|C (t)
      = (s - s\<sigma\>) Y(t)>. In Part (b), we assume a more general
      consumption rule <math|C (t) = (s \ - \<lambda\>\<sigma\>) Y(t)> with
      the parameter <math|\<lambda\> \<in\> <around*|[|0, 1|]>> controlling
      the response of consumption to increased taxes. The case
      <math|\<lambda\> = 0> corresponds to the extreme case of no response,
      <math|\<lambda\> = s> corresponds to a constant after-tax savings rule,
      and <math|\<lambda\> \<in\> <around*|[|0, 1|]>> correspond to other
      alternatives.

      <\note*>
        Higher <math|\<sigma\>> means lower consumption
      </note*>

      <item><math|C<rsub|t> = <around*|(|c -
      \<lambda\>\<sigma\>|)>Y<rsub|t>>, <math|I<rsub|t> = <around*|(|1 - c -
      <around*|(|1 - \<lambda\>|)>\<sigma\>|)>Y<rsub|t>>. So, if government
      spending increases (<math|\<sigma\>> is higher),\ 

      <math|K<rsub|t+1> = <around*|(|1 - \<delta\>|)>K<rsub|t> + <around*|(|1
      - c - <around*|(|1 - \<lambda\>|)>\<sigma\>|)>Y<rsub|t>> \<Rightarrow\>
      <math|<wide|k<rsub|t>|\<dot\>> = <around*|(|1 - c - <around*|(|1 -
      \<lambda\>|)>\<sigma\>|)>y<rsub|t> - \<delta\>k<rsub|t>>

      Assuming there's no population growth, <math|k<rsub|t+1> = <around*|(|1
      - \<delta\>|)>k<rsub|t> + <around*|(|1 - c - <around*|(|1 -
      \<lambda\>|)>\<sigma\>|)>y<rsub|t>>.

      With higher government spending, capital per labor <math|k> will
      decrease, which is that <math|k<rsub|\<sigma\>><around*|(|t|)> \<gtr\>
      k<rsub|\<sigma\><rprime|'>><around*|(|t|)>> for
      <math|\<sigma\><rprime|'> \<gtr\> \<sigma\>>.\ 

      Intuitively, higher government spending reduces net income and savings
      in the economy and depresses the equilibrium capital-labor ratio in the
      Solow growth model.

      As in the baseline Solow model, the capital-labor ratio in this economy
      converges to a unique positive steady state level
      <math|k<rsup|\<ast\>>> characterized by

      <math|<frac|y<rsup|\<ast\>>|k<rsup|\<ast\>>> = <frac|\<delta\>|1 - c -
      \<sigma\><around*|(|1 - \<lambda\>|)>>>

      The unique solution <math|k<rsup|\<ast\>>> is decreasing in
      <math|\<sigma\>> and increasing in <math|\<lambda\>> since
      <math|f(k)/k> is a decreasing

      function of <math|k>. In the economy with higher government spending
      (higher <math|\<sigma\>>), the capital-labor

      ratio is lower at all times, and in particular, is also lower at the
      steady state. Also, the more

      individuals reduce their consumption in response to government spending
      and taxes (higher

      <math|\<lambda\>>), the more they save, the higher the capital-labor
      ratio at all times and, in particular, the

      higher the steady state capital-labor ratio.

      <item>a fraction <math|\<phi\>> of <math|G(t)> is invested in the
      capital stock, so that total investment at time <math|t> is given by
      <math|I<rsub|t> = <around*|(|1 - c - <around*|(|1 - \<lambda\> -
      \<phi\>|)>\<sigma\>|)>Y<rsub|t>>

      <math|<wide|k<rsub|t>|\<dot\>> =<around*|(|1 - c - <around*|(|1 -
      \<lambda\> - \<phi\>|)>\<sigma\>|)>y<rsub|t> - \<delta\>k<rsub|t> >,
      <math|<frac|y<rsup|\<ast\>>|k<rsup|\<ast\>>> = <frac|\<delta\>|1 - c -
      <around*|(|1 - \<lambda\> - \<phi\>|)>\<sigma\>>>

      <math|<frac|\<partial\>|\<partial\>\<sigma\>> =
      ><math|<frac|\<delta\><around*|(|1 - \<lambda\> - \<phi\>|)>|1 - c -
      <around*|(|1 - \<lambda\> - \<phi\>|)>\<sigma\>>>

      SO, if <math|\<phi\> \<gtr\> 1 - \<lambda\>>,
      <math|<frac|\<partial\>|\<partial\>\<sigma\>> \<less\> 0>, which means
      government spends a lot, it's not very reasonable.
    </enumerate-alpha>
  </question>

  <section|Development Accounting>

  Whether the factors of production can explain income levels?

  Use Cobb-Douglas production function in physical and human capital

  (\<rightarrow\> more general than labor):

  <\equation*>
    Y<rsub|j> = A<rsub|j>K<rsub|j><rsup|\<alpha\>><around*|(|L<rsub|j>h<rsub|j>|)><rsup|1-\<alpha\>>
  </equation*>

  <\equation*>
    y<rsub|j> = \ A<rsub|j>K<rsub|j><rsup|\<alpha\>>h<rsub|j><rsup|1-\<alpha\>>
    \<backassign\> A<rsub|j>y<rsub|j><rsup|K H>
  </equation*>

  Caselli's measure of success:\ 

  <\equation*>
    success = <frac|Var<around*|(|log<around*|(|y<rsub|j><rsup|K
    H>|)>|)>|Var<around*|(|log<around*|(|y<rsub|j>|)>|)>>
  </equation*>

  If all countries had the same technology <math|A<rsub|j>>, then
  <math|success = 1>.

  \;

  <section|Neoclassical Growth Model>

  The same basic environment as Solow model without the assumption of the
  constant exogenous saving rate.

  <\equation*>
    Y = F<around*|(|K<around*|(|t|)>, L<around*|(|t|)>, Z<around*|(|t|)>|)>
  </equation*>

  As in basic general equilibrium theory, let us suppose that preference
  orderings can be represented by utility functions. In particular, suppose
  that there is a unique consumption good, and each household <math|h> has
  an<with|font-shape|italic| <with|color|blue|instantaneous utility
  function>> given by: <math|u<around*|(|c<rsup|h><around*|(|t|)>|)>>, where
  <math|c<rsup|h><around*|(|t|)>> is the consumption and <math|u:
  <with|font|Bbb|R><rsub|+> \<rightarrow\> <with|font|Bbb|R>> is increasing
  and concave.

  <\note*>
    <with|color|red|Negative levels of consumption are not allowed.>
  </note*>

  We shall make 2 major asusmptions:

  <\description-compact>
    <item*|>Household does not derive any utility from the consumption of
    other households, so consumption externalities are ruled out.

    <item*|>Impose the condition that overall utility is
    <with|color|blue|<with|font-shape|italic|time-separable and stationary>>;
    that is, instantaneous utility at time <math|t> is independent of the
    consumption levels at past or future dates and is represented by the same
    utility function uh at all dates.
  </description-compact>

  Representative household with preferences:

  <\equation*>
    U<rsup|h><around*|(|T|)> = <big|sum><rsub|t=0><rsup|T><around*|(|\<beta\><rsup|h>|)><rsup|t>u<rsup|h><around*|(|c<rsup|h><around*|(|t|)>|)>
  </equation*>

  where <math|\<beta\><rsup|h> \<in\> <around*|(|0, 1|)>> is the time
  discount factor of household <math|h>.

  A solution <math|<around*|{|x<around*|(|t|)>|}><rsub|t=1><rsup|T>> to a
  dynamic optimization problem is <with|font-shape|italic|<with|color|blue|time-consistent>>
  if the following is true: <with|font-shape|italic|When
  <math|<around*|{|x<around*|(|t|)>|}><rsub|t=1><rsup|T>> is a solution to
  teh continuation dynamic optimization problem starting from <math|t=0>,
  <math|<around*|{|x<around*|(|t|)>|}><rsub|t=t<rprime|'>><rsup|T>> is a
  solution the the continuation dynamic optimization starting from the time
  <math|t = t<rprime|'> \<gtr\> 0>>. \ 

  Let's consider the simplest case and suppose all households are
  infinitely-lived and identical. Then the demand side of the economy can be
  represented as the solution of the following maximization problem at time
  <math|t=0>:

  <\equation*>
    max <big|sum><rsub|t=0><rsup|\<infty\>>\<beta\><rsup|t>u<around*|(|c<around*|(|t|)>|)>
  </equation*>

  where <math|\<beta\>\<in\><around*|(|0, 1|)>>.

  Budget constraint:

  <\equation*>
    C<around*|(|t|)> + K<around*|(|t+1|)> =
    <around*|(|1+r<around*|(|t|)>|)>K<around*|(|t|)> +
    w<around*|(|t|)>L<around*|(|t|)>
  </equation*>

  <math|r(t)> is the rate of return on lending capital to firms.

  <\note*>
    <with|font-series|bold|<with|color|blue|Optimal Growth>>

    <\with|font-series|bold>
      If the economy consists of a number of identical households, then this
      problem corresponds to the Pareto optimal allocation giving the same
      (Pareto) weight to all households. Therefore the optimal growth problem
      in discrete time with no uncertainty, no population growth, and no
      technological progress can be written as follows:

      <\eqnarray*>
        <tformat|<cwith|1|1|2|2|cell-halign|l>|<table|<row|<cell|<below|max|<around*|{|c<around*|(|t|)>,
        k<around*|(|t|)>|}><rsub|i=1><rsup|\<infty\>>>>|<cell|<big|sum><rsub|t=0><rsup|\<infty\>>\<beta\><rsup|t>u<around*|(|c<around*|(|t|)>|)>>|<cell|>>|<row|<cell|s.t.>|<cell|k<around*|(|t+1|)>
        = f<around*|(|k<around*|(|t|)>|)> +
        <around*|(|1-\<delta\>|)>k<around*|(|t|)> -
        c<around*|(|t|)>>|<cell|>>>>
      </eqnarray*>

      with <math|k<around*|(|t|)>\<geq\> 0> and given
      <math|k<around*|(|0|)>\<gtr\>0>.

      The constraint is straightforward to understand:
      <with|font-shape|italic|<with|color|blue|total output per capita
      produced with capital-labor ratio <math|k<around*|(|t|)>,
      f<around*|(|k<around*|(|t|)>|)>>, together with a fraction
      <math|<around*|(|1-\<delta\>|)>> of the capital that is undepreciated
      make up the total resources of the economy at date <math|t>.>>

      Assuming that the representative household has <math|L<around*|(|t|)>>
      unit of labor supplied inelastically and denoting its assets at time
      <math|t> by <math|a(t)>, this problem can be written as:

      <\eqnarray*>
        <tformat|<cwith|1|1|2|2|cell-halign|l>|<table|<row|<cell|<below|max|<around*|{|c<around*|(|t|)>,
        k<around*|(|t|)>|}><rsub|i=1><rsup|\<infty\>>>>|<cell|<big|sum><rsub|t=0><rsup|\<infty\>>\<beta\><rsup|t>u<around*|(|c<around*|(|t|)>|)>>|<cell|>>|<row|<cell|s.t.>|<cell|a<around*|(|t+1|)>
        = <around*|(|1+r<around*|(|t|)>|)>a<around*|(|t|)>-c<around*|(|t|)>+w<around*|(|t|)>L<around*|(|t|)>>|<cell|>>>>
      </eqnarray*>

      where <math|r<around*|(|t|)>> is the net rate of return on assets, so
      that <math|1+r<around*|(|t|)>> is the fross rate of return, and
      <math|w<around*|(|t|)>> is teh equilibrium wage rate.
      <with|color|red|Market clearing then requires
      <math|a<around*|(|t|)>=k<around*|(|t|)>>.>
    </with>
  </note*>

  And, we have the non-Ponzi condition:

  <\equation*>
    <below|lim|t\<rightarrow\>\<infty\>><around*|{|K<around*|(|t|)><around*|[|<big|prod><rsub|s=1><rsup|t-1><around*|(|<frac|1|1
    + r<rsub|s>>|)>|]>|}> \<geq\> 0
  </equation*>

  which refers to: limit of the PDV of debt has to be nonnegative (you cannot
  die in debt)

  <\theorem>
    <with|color|blue|<with|font-series|bold|Euler Equation>>

    <\equation*>
      \<forall\> t: u<rprime|'><around*|(|c<rsub|t>|)> =
      \<beta\><around*|(|1+r<rsub|t+1>|)>u<rprime|'><around*|(|c<rsub|t+1>|)>
    </equation*>
  </theorem>

  With an infinite horizon (<math|T \<rightarrow\> \<infty\>>), the Euler
  equations still determine the relative consumption levels. The terminal
  condition becomes <with|color|blue|transversality condition> is the limit
  of the terminal condition:

  <\equation*>
    <below|lim|T\<rightarrow\>\<infty\>>K<rsub|T+1>\<beta\><rsup|T>u<rprime|'><around*|(|c<rsub|T>|)>
    = <below|lim|T\<rightarrow\>\<infty\>>K<rsub|T+1>\<beta\><rsup|T+1>u<rprime|'><around*|(|c<rsub|T+1>|)><around*|(|1
    + r<rsub|T+1>|)> = 0
  </equation*>

  Hence

  <\equation*>
    <below|lim|t\<rightarrow\>\<infty\>>\<beta\><rsup|t>u<rprime|'><around*|(|c<rsub|t>|)><around*|(|1+r<rsub|t>|)>K<rsub|t>
    = 0
  </equation*>

  Then, we have two conditiond involve the infinity:

  <\equation>
    <below|lim|t\<rightarrow\>\<infty\>>\<beta\><rsup|t>u<rprime|'><around*|(|c<rsub|t>|)><around*|(|1+r<rsub|t>|)>K<rsub|t>
    = 0<label|3.1>
  </equation>

  <\equation>
    <below|lim|t\<rightarrow\>\<infty\>><around*|{|K<around*|(|t|)><around*|[|<big|prod><rsub|s=1><rsup|t-1><around*|(|<frac|1|1
    + r<rsub|s>>|)>|]>|}> \<geq\> 0<label|3.2>
  </equation>

  The <reference|3.1> is a condition for optimal behavior. The
  <reference|3.2> is a condition to make sure that the flow budget
  constraints are consistent with a lifetime budget constraint and no
  perpetual debt.

  <with|font-series|bold|Steady State> <math|<around*|(|C<rsup|\<ast\>>,
  K<rsup|\<ast\>>|)>>

  From the Euler equation:

  <\equation*>
    u<rprime|'><around*|(|C<rsup|\<ast\>>|)> = \<beta\><around*|(|1 +
    F<rsub|K><around*|(|K<rsup|\<ast\>>, L|)>|)>u<rprime|'><around*|(|C<rsup|\<ast\>>|)>
  </equation*>

  hence

  <\equation*>
    1 + r<rsup|\<ast\>> = 1 + F<rsub|K><around*|(|k<rsup|\<ast\>>, 1|)> -
    \<delta\> = <frac|1|\<beta\>>
  </equation*>

  which fully determines <math|k<rsup|\<ast\>>>.

  <\note*>
    This shows that <math|k<rsup|\<ast\>>> does not depend on
    <math|u<around*|(|\<cdot\>|)>>.
  </note*>

  Level of per-capita consumption is then given by the economy's resource
  constraint:

  <\equation*>
    C<rsup|\<ast\>> + K<rsup|\<ast\>> = <around*|(|1 -
    \<delta\>|)>K<rsup|\<ast\>> + F<around*|(|K<rsup|\<ast\>>, L|)>
  </equation*>

  hence,

  <\equation*>
    c<rsup|\<ast\>> = F<around*|(|k<rsup|\<ast\>>, 1|)> -
    \<delta\>k<rsup|\<ast\>>
  </equation*>

  <\equation*>
    F<rsub|K>*<around*|(|k<rsup|\<ast\>>, 1|)> = \<delta\> +
    <around*|(|<frac|1|\<beta\>> - 1|)>
  </equation*>

  In the Solow model the golden-rule level of capital (which maximizes
  steady-state consumption) satisfies

  <\equation*>
    F<rprime|'><rsub|K><around*|(|k<rsub|S><rsup|GR>, 1|)> = \<delta\>
  </equation*>

  hence

  <\equation*>
    k<rsup|\<ast\>><rsub|NGM> \<less\> k<rsub|S><rsup|GR>
  </equation*>

  <\note*>
    <with|font-series|bold|Intuition:>

    In NGM model, people tend to consume more on the near future rather than
    in the far steady state.
  </note*>

  <subsection|NGM in continuous time>

  Assume labor supply <math|L> growth at rate <math|n>:

  <\equation*>
    L<around*|(|t|)> = e<rsup|n t>
  </equation*>

  Households choose consumption/saving to maximize

  <\equation*>
    U = <big|int><rsub|0><rsup|\<infty\>>e<rsup|-\<rho\> t>e<rsup|n
    t>u<around*|(|c<around*|(|t|)>|)> d t =
    <big|int><rsub|0><rsup|\<infty\>>e<rsup|<around*|(|n-\<rho\>|)>t>u<around*|(|c<around*|(|t|)>|)>
    d t
  </equation*>

  Intertemporal budget constraint: as in the discrete time case, but treat
  <math|\<Delta\>K\<rightarrow\>0>:

  <\equation*>
    <wide|K|\<dot\>><around*|(|t|)> = w<around*|(|t|)>L<around*|(|t|)> +
    <around*|(|1 + r<around*|(|t|)>|)>K<around*|(|t|)> - C<around*|(|t|)>
  </equation*>

  Write in per-capita units:

  <\equation*>
    <wide|k|\<dot\>><around*|(|t|)> = w<around*|(|t|)> + <around*|(|1 +
    r<around*|(|t|)>|)>k<around*|(|t|)> - c<around*|(|t|)> - n
    k<around*|(|t|)>
  </equation*>

  Non-Ponzi condition:

  <\equation*>
    <below|lim|t\<rightarrow\>\<infty\>><around*|{|k<around*|(|t|)>
    exp<around*|[|-<big|int><rsub|0><rsup|t><around*|(|r<around*|(|v|)> -
    n|)> d v|]>|}> \<geq\> 0
  </equation*>

  To solve this, we define the <with|font-series|bold|Hamiltonian>:

  <\equation*>
    H<around*|(|c, k, \<mu\>|)> = e<rsup|-<around*|(|\<rho\>-n|)>t>u<around*|(|c<around*|(|t|)>|)>
    + \<mu\><around*|(|t|)><around*|[|w<around*|(|t|)> + <around*|(|1 +
    r<around*|(|t|)> - n|)>k<around*|(|t|)> - c<around*|(|t|)> |]>
  </equation*>

  optimality conditions are

  <\eqnarray*>
    <tformat|<table|<row|<cell|H<rsub|c><around*|(|c, k,
    \<mu\>|)>>|<cell|=>|<cell|0>>|<row|<cell|H<rsub|k><around*|(|c, k,
    \<mu\>|)>>|<cell|=>|<cell|-<wide|\<mu\>|\<dot\>><around*|(|t|)>>>|<row|<cell|H<rsub|\<mu\>><around*|(|c,
    k, \<mu\>|)>>|<cell|=>|<cell|<wide|k|\<dot\>><around*|(|t|)>>>|<row|<cell|<below|lim|t\<rightarrow\>\<infty\>>\<mu\><around*|(|t|)>k<around*|(|t|)>>|<cell|=>|<cell|0>>>>
  </eqnarray*>

  Hence:

  <\eqnarray*>
    <tformat|<table|<row|<cell| e<rsup|-<around*|(|\<rho\>-n|)>t>u<rprime|'><around*|(|c<around*|(|t|)>|)>
    - \<mu\><around*|(|t|)>>|<cell|=>|<cell|0>>|<row|<cell|\<mu\><around*|(|t|)><around*|(|1
    + r<around*|(|t|)> - n|)>>|<cell|=>|<cell|-<wide|\<mu\>|\<dot\>><around*|(|t|)>>>>>
  </eqnarray*>

  and we get:

  <\equation*>
    \ e<rsup|-<around*|(|\<rho\>-n|)>t>u<rprime|'><around*|(|c<around*|(|t|)>|)><around*|(|1
    + r<around*|(|t|)> - n|)> = \ -e<rsup|-<around*|(|\<rho\>-n|)>t>u<rprime|''><around*|(|c<around*|(|t|)>|)><wide|c|\<dot\>><around*|(|t|)>
    + <around*|(|\<rho\>-n|)> e<rsup|-<around*|(|\<rho\>-n|)>t>u<rprime|'><around*|(|c<around*|(|t|)>|)>
  </equation*>

  Denote <math|\<sigma\><around*|(|c|)> =
  -<frac|u<rprime|'><around*|(|c|)>|u<rprime|''><around*|(|c|)>c>>, we have
  the Euler equation in continuous time:

  <\equation*>
    \<sigma\><around*|(|c|)><around*|(|1 + r<around*|(|t|)> - \<rho\>|)> =
    <frac|<wide|c|\<dot\>><around*|(|t|)>|c<around*|(|t|)>>
  </equation*>

  <math|\<sigma\><around*|(|c|)>> is the intertemporal elasticity of
  substitution (IES).

  <section|Business Cycle Facts and RBC Model>

  <with|font-series|bold|Business Cycle Facts I>

  We'll study the <with|font-series|bold|detrended macro times series:>

  <\equation*>
    x<rsub|t> = log<around*|(|X<rsub|t>|)> -
    log<around*|(|X<rsub|t><rsup|\<ast\>>|)>
  </equation*>

  is the percentage deviation of variable <math|X> from its trend
  <math|X<rsup|\<ast\>>>.

  How's the trend?

  <\description-compact>
    <item*|>First linear,

    <item*|>more sophisticated filters: Baxter-King(Bankpass) filter,
    Hodrick-Prescott(HP) filter
  </description-compact>

  Linear: just run OLS regression and use residuals.

  \;

  <with|font-series|bold|Business Cycle Facts III:>

  Governmetn spending, not strongly correlated with level of output, main
  driver of business cycles.

  Real wage is mildly pro-cyclical: average wage evolves differently than the
  wage of a continuously employed worker

  \;

  <math|U<rsub|C><around*|(|C, 1-L|)> \<gtr\> 0, U<rsub|C C><around*|(|C,
  1-L|)> \<less\> 0> and <math|U<rsub|L><around*|(|C, 1-L|)>\<gtr\>0>,
  <math|U<rsub|L L><around*|(|C, 1-L|)> \<less\> 0>
</body>

<\initial>
  <\collection>
    <associate|font-base-size|12>
    <associate|info-flag|paper>
    <associate|page-bot|20mm>
    <associate|page-even|15mm>
    <associate|page-medium|paper>
    <associate|page-odd|15mm>
    <associate|page-right|15mm>
    <associate|page-screen-margin|false>
    <associate|page-top|20mm>
    <associate|par-first|1tab>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|3.1|<tuple|3.1|5>>
    <associate|3.2|<tuple|3.2|5>>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-2|<tuple|1|1>>
    <associate|auto-3|<tuple|1|1>>
    <associate|auto-4|<tuple|2|3>>
    <associate|auto-5|<tuple|3|3>>
    <associate|auto-6|<tuple|3.1|6>>
    <associate|auto-7|<tuple|4|7>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|2fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|font-size|<quote|1.19>|1<space|2spc>Solow
      Model & Dev Accounting> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|1fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Solow
      model> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|Reveiw
      Session> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>Development
      Accounting> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Neoclassical
      Growth Model> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5><vspace|0.5fn>

      <with|par-left|<quote|1tab>|3.1<space|2spc>NGM in continuous time
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Business
      Cycle Facts and RBC Model> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>