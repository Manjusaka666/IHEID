% Based on the two sector model outlined in  "News Shocks under Financial Frictions" 
% by Christoph Gortz, John Tsoukalas and Francesco Zanetti 2021
%This version (GTZ2021_est) attempts to estimate parameters using GTZ2021 data ===> WORKS !!

var   labi labc lab kc ki kpi kpc mcc mci zcapi zcapc rki rkc pi lam phifi 
phifc c invei invec inve y pinfc pinfi w r z v b g qs ms sw ewma z_l v_l dy
dc dinve dpi dw labobs robs pinfobsc pinfobsi spreadobsc spreadobsi rrate 
epinfmac epinfmai spinfc spinfi spi spkc spki zcapif zcapcf rkcf rkif kpif 
kpcf kif kcf lamf phifif phifcf cf invef inveif invecf yf labf labif labcf 
pif wf sdfbf nucf nuif rbcf rbif z1cf z1if etaif etacf z2cf z2if lrcf lrif 
ncf nif qcf qif scf sif sdfb rbc rbi z1c z1i z2c z2i nuc nui etac etai lrc 
lri qc qi sc si nc ni spreadc spreadi snc sni psic psii cthetab dequity k
;
varexo ez ev eb em epinfc epinfi ew enc eni eg epkc epki eqs evl ezl espi ethetab;
parameters constepinfc constepinfi constebeta cmaw cmapi cmapc alfac alfai
czcapi czcapc czcap csadjcost cdeltai cdeltac csigma chabb cindw cprobw 
cindpc cprobpc cindpi cprobpi csigl cfc crpi crdy cry crr crhoz crhov crhob
crhog crhoqs crhoms crhopinf crhow crhozl crhovl crhospkc crhospki cminrho
cg cga cgv clandapaux clandawaux Lss nvalueic crhopinfc crhopinfi crhospi
cthetabss crhothetab clamb crhosnc crhosni sigmasn ctau cvarthetac 
cvarthetai psicss psiiss lridata lrcdata cbeta ga gv clandap clandaw crho
% Steady state parameters
X1aux crki crkc cpi cw KcLc KiLi Lc Li css iss Kc Ki K Kibar Kcbar yss iiss icss
% Steady state parameters resulting from financial intermediaries
z1css z1iss z2css z2iss rbcss rbiss rss lrcss lriss nucss nuiss qcss qiss sncss sniss scss siss
;
% Calibrated parameters:
cdeltai =.025;         % depreciation rate I sector capital
cdeltac =.025;         % depreciation rate C sector capital
alfac=.36;             % share of capital in C-sector production function
alfai=.36;             % share of capital in I-sector production function
constebeta = 0.2607;   % equivalent to cbeta = 0.9974, constistent with 1990Q2-2011Q1 US data
constepinfc = 0.6722;  % constistent with 1990Q2-2011Q1 US data
constepinfi = 0.0245;  % constistent with 1990Q2-2011Q1 US data
cg = 0.177;            % ss nominal government spending to nominal output ratio, constistent with 1982Q4-2011Q1 US data
nvalueic = 0.399;      % average value of nominal investment to consumption ratio, constistent with 1982Q4-2011Q1 US data
Lss = 1;               % ss of total hours (by choosing appropriate value of the weight of leisure in utility)
cmapc =    0;          % MA price mark-up
cmapi =    0;          % MA price mark-up
cmaw  =   0;           % MA wage mark-up
clandawaux = 1.1-1;    % ss wage mark up
clandapaux = 1.1-1;    % ss price mark up
csigma=1.0;           % Risk aversion parameter
cfc=1.5;                 % fixed cost share
cga = 0.1;                  % steady state-growth rate of TFP in C-sector production function
cgv = 0.4;                 % steady state-growth rate of TFP in I-sector production function
% calibrated parameters specific to financial intermediaries:
cthetabss = 0.96;       % Fraction of bankers that survive at following period (in SS)
clamb =	0.3;            % Fraction of wealth banks can divert  -  calculated in SS file
lridata = 5.47;         % Leverage ratio implied by the data for I sector
lrcdata = lridata;      % Leverage ratio implied by the data for C sector
cvarthetac = 0;         % Response of gov's credit to external spread in C sector
cvarthetai = cvarthetac;% Response of gov's credit to external spread in I sector
psicss = 0;             % Steady state fraction assets intermed by CB in C sector
psiiss = psicss;        % Steady state fraction assets intermed by CB in I sector
ctau = 0.0;             % Government's cost of providing profit
% Central bank as an intermediary is shut down for psicss = psiss = ctau = cvarthetac = cvarthetai = 0
% estimated parameters initialisation:
csadjcost= 2.18;	% intertemporal investment adj. cost parameter
chabb=    0.7;      % consumption habit 
cprobw=   0.66;     %  Calvo wage contract probability
cindw=    0.26;     % wage indexation
csigl=    1.0;      % inverse labour supply elasticity
cprobpc=   0.82;    % Calvo consumption sector price probability 
cindpc=    0.24;    % consumption sector price indexation
cprobpi=   0.77;    %  Calvo investment sector price probability 
cindpi=    0.27;    % investment sector price indexation
czcapi=    5.05;    % variable I-capital utilization 
czcapc=    4.06;    % variable C-capital utilization 
czcap =    5.75;     % unused
crpi=     2.23;     % Taylor rule inflation 
crr=      0.9;      % Taylor rule inertia  
cry=      0.2;      % Taylor rule output gap 
crdy=     0.2;      % Taylor rule output gap growth
cminrho = 0.36;     % intratemporal inv. adjustment cost, zero equals crho = -1
crhoz=    0.14;     % consumption sector productivity AR(1) --- growth shock
crhov=    0.25;     % investment sector productivity AR(1) --- growth shock
crhozl=    0.0;     % consumption sector productivity AR(1) --- stationary shock
crhovl=    0.0;     % investment sector productivity AR(1) --- stationary shock
crhob=    0.8;      % preference shock AR(1)
crhog=    0.9;      % gov spending shock AR(1)
crhoqs=   0.0;      % installation shock AR(1)
crhoms=   0.0;      % monetary policy shock AR(1)
crhopinfi= 0.2;     % price mark-up shock AR(1) in I sector
crhopinfc= 0.8;     % price mark-up shock AR(1) in C sector
crhow=    0.3;      % wage mark-up shock AR(1)
crhospkc = 0.9;     % quality of physical capital shock in C sector
crhospki = 0.2;     % quality of physical capital shock in I sector
crhospi = 0.0;      % persistence of inflation objective shock
crhosnc = 0.8;      % Persistence of shock to intermediary's equity capital in C-sector
crhosni = 0.6;      % Persistence of shock to intermediary's equity capital in I-sector
crhothetab = 0;     % Persistence of equity shock
% Parameter transformations:
cbeta = 1/(1+constebeta/100);
ga = cga/100 ;                  % steady state-growth rate (%) of TFP in C-sector production function
gv = cgv/100 ;                  % steady state-growth rate (%) of TFP in I-sector production function
clandap = 1 + clandapaux;
clandaw = 1 + clandawaux;
crho = 1/(cminrho - 1); 
model (linear); % Equation references are to Appendix C.7 in Gortz Tsoukalas Zanetti 2020 "News Shocks under Financial Frictions", CAMA Paper 94 Oct2020
%composite parameter
#cdiscf=exp(ga+(alfac/(1-alfai))*gv);
% flexible economy 
      % consumption and investment sector production functions and factor prices
          invef = clandap*(alfai*kif + (1-alfai)*labif + v_l);
          invef = (iiss^-crho + icss^-crho)^-1*iiss^-crho*inveif + (iiss^-crho + icss^-crho)^-1*icss^-crho*invecf;          
          cf + crki*Kibar/css* exp(-(1/(1-alfai))*gv)*zcapif + crkc*Kcbar/css* exp(-(1/(1-alfai))*gv)*zcapcf = clandap*(alfac*kcf + (1-alfac)*labcf + z_l);      
          z_l - alfac*labcf + alfac*kcf = wf;
          z_l + (1 - alfac)*labcf + (alfac-1)*kcf = rkcf;
          v_l - alfai*labif + alfai*kif + pif = wf;
          v_l + (1 - alfai)*labif + (alfai-1)*kif + pif = rkif;
      % Household's Marginal Utility  
        lamf = (chabb*cbeta*cdiscf/((cdiscf-chabb*cbeta)*(cdiscf-chabb)))*cf(+1)       
        - ((exp(2*(ga+(alfac/(1-alfai))*gv)) + chabb^2*cbeta)/((cdiscf-chabb*cbeta)*(cdiscf-chabb)))*cf       
        + (chabb*cdiscf/((cdiscf-chabb*cbeta)*(cdiscf-chabb)))*cf(-1)
        + ( cdiscf*chabb*cbeta*crhoz - chabb*cdiscf )/((cdiscf-chabb*cbeta)*(cdiscf-chabb))*z
        + b
        +  (alfac/(1-alfai))*( cdiscf*chabb*cbeta*crhov - chabb*cdiscf )/((cdiscf-chabb*cbeta)*(cdiscf-chabb))*v;
       % Capital utilisation in both sectors
        rkif = czcapi*zcapif;
        rkcf = czcapc*zcapcf;
       % Investment decision in I sector
        lamf = -pif + phifif + qs - exp(2*((1/(1-alfai))*gv))*csadjcost*(inveif - inveif(-1) + z + 1/(1-alfai)*v) 
        + cbeta* exp(2*((1/(1-alfai))*gv))*csadjcost*( inveif(+1) - inveif + z(+1) +  1/(1-alfai)*v(+1) ) -(1+crho)*((iiss^-crho + icss^-crho)^-1*(icss^-crho*invecf+iiss^-crho*inveif)-inveif);
       % Investment decision in C sector
        lamf = -pif + phifcf + qs - exp(2*((1/(1-alfai))*gv))*csadjcost*(invecf - invecf(-1) + z + 1/(1-alfai)*v) 
        + cbeta* exp(2*((1/(1-alfai))*gv))*csadjcost*( invecf(+1) - invecf + z(+1) +  1/(1-alfai)*v(+1) ) -(1+crho)*((iiss^-crho + icss^-crho)^-1*(icss^-crho*invecf+iiss^-crho*inveif)-invecf);
       % Capital input in both sectors
	    kif =  kpif(-1)+ zcapif + spki  - 1/(1-alfai)*v;
        kcf =  kpcf(-1)+ zcapcf + spkc  - 1/(1-alfai)*v;
       % Capital accumulation in both sectors
        kpif =  (1-cdeltai)* exp(-(1/(1-alfai))*gv)*( kpif(-1) + spki  - (1/(1-alfai))*v ) + ( 1 - (1-cdeltai)* exp(-(1/(1-alfai))*gv))*(qs + inveif);
        kpcf =  (1-cdeltac)* exp(-(1/(1-alfai))*gv)*( kpcf(-1) + spkc  - (1/(1-alfai))*v ) + ( 1 - (1-cdeltac)* exp(-(1/(1-alfai))*gv))*(qs + invecf);
       % Flexible wage
        wf =  b + csigl*labf - lamf;
       % Total output
        yf = css/yss*cf+cpi*iss/yss*(invef + pif) + g ;
       % Total hours worked
        labf = Lc/Lss*labcf + Li/Lss*labif;
   %Equations needed to implement financial intermediaries:
        % Stochastic discount factor of bank
        sdfbf = lamf-lamf(-1);
        % Definition of nu for C sector
        nucf = -cthetabss*(1-cthetabss*cbeta*z1css)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z1css)*(sdfbf(+1)-z(+1)-alfac/(1-alfai)*v(+1)) + (1-cthetabss*cbeta*z1css)/(rbcss-rss)*(rbcss*rbcf(+1) - rss*r)  +  cthetabss*cbeta*z1css*(z1cf(+1)+nucf(+1)+cthetab);
        % Definition of nu for I sector
        nuif = -cthetabss*(1-cthetabss*cbeta*z1iss)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z1iss)*(sdfbf(+1)-z(+1)-alfac/(1-alfai)*v(+1)) + (1-cthetabss*cbeta*z1iss)/(rbiss-rss)*(rbiss*rbif(+1) - rss*r)  +  cthetabss*cbeta*z1iss*(z1if(+1)+nuif(+1)+cthetab);
        % Definition of eta for C sector
        etacf = -cthetabss*(1-cthetabss*cbeta*z2css)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z2css)*(sdfbf(+1)-z(+1)-alfac/(1-alfai)*v(+1) + r)  +   cthetabss*cbeta*z2css*(z2cf(+1)+etacf(+1)+cthetab);
        % Definition of eta for I sector
        etaif = -cthetabss*(1-cthetabss*cbeta*z2iss)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z2iss)*(sdfbf(+1)-z(+1)-alfac/(1-alfai)*v(+1) + r)  +   cthetabss*cbeta*z2iss*(z2if(+1)+etaif(+1)+cthetab);
        % Definition of z1 (growth rate in assets) for C sector
		z1cf = lrcf - lrcf(-1) + z2cf;
        % Definition of z1 for I sector
		z1if = lrif - lrif(-1) + z2if;
        % Definition of z2 (growth rate of net worth) for C sector
		z2cf = 1/((rbcss-rss)*lrcss+rss) * ( rbcss*lrcss*rbcf + rss*(1-lrcss)*r(-1) + (rbcss-rss)*lrcss*lrcf(-1) );
        % Definition of z2 for I sector
		z2if = 1/((rbiss-rss)*lriss+rss) * ( rbiss*lriss*rbif + rss*(1-lriss)*r(-1) + (rbiss-rss)*lriss*lrif(-1) );
        % Leverage ratio of bank in C sector
		lrcf = etacf + nucss/(clamb-nucss)*nucf;
        % Leverage ratio of bank in I sector
		lrif = etaif + nuiss/(clamb-nuiss)*nuif;
        % Wealth accumulation equation of bank in C sector
        ncf = sncss*cthetabss* exp(-ga-alfac/(1-alfai)*gv)*((rbcss-rss)*lrcss+rss) * (ncf(-1) + cthetab(-1) - z -alfac/(1-alfai)*v + snc)
            + sncss*cthetabss* exp(-ga-alfac/(1-alfai)*gv) * ( rbcss*lrcss*rbcf - rss*lrcss*r(-1) + (rbcss-rss)*lrcss*lrcf(-1) + rss*r(-1) )
            + (1-exp(-ga-alfac/(1-alfai)*gv)*((rbcss-rss)*lrcss+rss)*cthetabss*sncss) * (qcf + scf + snc);
        % Wealth accumulation equation of bank in I sector
        nif = sniss*cthetabss* exp(-ga-alfac/(1-alfai)*gv)*((rbiss-rss)*lriss+rss) * (nif(-1) + cthetab(-1) - z -alfac/(1-alfai)*v + sni)
            + sniss*cthetabss* exp(-ga-alfac/(1-alfai)*gv) * ( rbiss*lriss*rbif - rss*lriss*r(-1) + (rbiss-rss)*lriss*lrif(-1) + rss*r(-1) )
            + (1-exp(-ga-alfac/(1-alfai)*gv)*((rbiss-rss)*lriss+rss)*cthetabss*sniss) * (qif + sif + sni);
        % Borrow in advance constraint for C sector
		kpcf = scf;
        % Borrow in advance constraint for I sector
		kpif = sif;
        % Stochastic return on assets for bank in C sector
    	rbcf = 1/(crkc+qcss*(1-cdeltac)) * ( crkc*(rkcf+zcapcf) + qcss*(1-cdeltac)*(qcf) ) -qcf(-1) +spkc + z - (1-alfac)/(1-alfai)*v;
        % Stochastic return on assets for bank in I sector
    	rbif = 1/(crki+qiss*(1-cdeltai)) * ( crki*(rkif+zcapif) + qiss*(1-cdeltai)*(qif) ) -qif(-1) +spki + z - (1-alfac)/(1-alfai)*v;
        % Price of capital in C sector
		qcf = exp(2*1/(1-alfai)*gv)*csadjcost * ( invecf-invecf(-1)+1/(1-alfai)*v) - cbeta* exp(2*1/(1-alfai)*gv)*csadjcost * (invecf(+1)-invecf+1/(1-alfai)*v(+1)) - qs + pif + (1+crho) * ( (iiss^(-crho)+icss^(-crho))^(-1) * (icss^(-crho)*invecf + iiss^(-crho)*inveif) - invecf );
        % Price of capital in I sector
		qif = exp(2*1/(1-alfai)*gv)*csadjcost * ( inveif-inveif(-1)+1/(1-alfai)*v) - cbeta* exp(2*1/(1-alfai)*gv)*csadjcost * (inveif(+1)-inveif+1/(1-alfai)*v(+1)) - qs + pif + (1+crho) * ( (iiss^(-crho)+icss^(-crho))^(-1) * (icss^(-crho)*invecf + iiss^(-crho)*inveif) - inveif );
        % Leverage equation in C sector
        qcf = lrcf + ncf - scf + psicss/(1-psicss)*psic;
        % Leverage equation in I sector
        qif = lrif + nif - sif + psiiss/(1-psiiss)*psii;
% sticky price - wage economy  
          % consumption and investment sector production functions
          inve = clandap*(alfai*ki + (1-alfai)*labi + v_l);
          c  + crki*Kibar/css* exp(-(1/(1-alfai))*gv)*zcapi + crkc*Kcbar/css* exp(-(1/(1-alfai))*gv)*zcapc = clandap*(alfac*kc + (1-alfac)*labc + z_l);
          % sectoral investment aggregation
          inve = (iiss^-crho + icss^-crho)^-1*iiss^-crho*invei + (iiss^-crho + icss^-crho)^-1*icss^-crho*invec;
          % marginal costs for C and I sector - eq.C.45
	      mcc =  alfac*rkc+(1-alfac)*w - z_l;
          mci =  alfai*rki+(1-alfai)*w - pi - v_l;
          % capital-to-labour ratios for C and I sector - eq.C.44
          rkc - w = labc - kc;
          rki - w = labi - ki;
         % consumption and investment sector optimal pricing --- Philips curves - eq.C.46
           pinfc -spi =  (cbeta/(1+cindpc*cbeta))*(pinfc(+1)-spi) + (cindpc/(1+cindpc*cbeta))*(pinfc(-1)-spi) 
               +( (1-cprobpc)*(1-cbeta*cprobpc)/((1+cindpc*cbeta)*cprobpc) )* mcc  +  spinfc ;
           pinfi -spi =  (cbeta/(1+cindpi*cbeta))*(pinfi(+1)-spi) + (cindpi/(1+cindpi*cbeta))*(pinfi(-1)-spi) 
               +( (1-cprobpi)*(1-cbeta*cprobpi)/((1+cindpi*cbeta)*cprobpi) )* mci  + spinfi ; 
        % Household's Marginal Utility - eq.C.47        
        lam = (chabb*cbeta*cdiscf/((cdiscf-chabb*cbeta)*(cdiscf-chabb)))*c(+1)
        - ((exp(2*(ga+(alfac/(1-alfai))*gv)) + chabb^2*cbeta)/((cdiscf-chabb*cbeta)*(cdiscf-chabb)))*c
        + (chabb*cdiscf/((cdiscf-chabb*cbeta)*(cdiscf-chabb)))*c(-1)
        + ( cdiscf*chabb*cbeta*crhoz - chabb*cdiscf )/((cdiscf-chabb*cbeta)*(cdiscf-chabb))*z
	    + b
        +  (alfac/(1-alfai))*( cdiscf*chabb*cbeta*crhov - chabb*cdiscf )/((cdiscf-chabb*cbeta)*(cdiscf-chabb))*v;
        % Euler Equation - eq.C.48
        lam = r + lam(+1) - z(+1) - v(+1)*alfac/(1-alfai) - pinfc(+1);
        % Capital utilisation in both sectors - eq.C.50
        rki = czcapi*zcapi;
        rkc = czcapc*zcapc;
        % Choice of investment in I sector - eq.C.52
        lam = -pi + phifi + qs - exp(2*((1/(1-alfai))*gv))*csadjcost*(invei - invei(-1) + 1/(1-alfai)*v) 
        + cbeta* exp(2*((1/(1-alfai))*gv))*csadjcost*( invei(+1) - invei +  1/(1-alfai)*v(+1) ) -(1+crho)*((iiss^-crho + icss^-crho)^-1* (icss^-crho*invec+iiss^-crho*invei)-invei);
        % Choice of investment in C sector - eq.C.51
        lam = -pi + phifc + qs - exp(2*((1/(1-alfai))*gv))*csadjcost*(invec - invec(-1) + 1/(1-alfai)*v) 
        + cbeta* exp(2*((1/(1-alfai))*gv))*csadjcost*( invec(+1) - invec +  1/(1-alfai)*v(+1) ) -(1+crho)*((iiss^-crho + icss^-crho)^-1* (icss^-crho*invec+iiss^-crho*invei)-invec);
        % Capital input in both sectors - eq.C.53
	    ki =  kpi(-1)+ zcapi + spki - 1/(1-alfai)*v;
        kc =  kpc(-1)+ zcapc + spkc - 1/(1-alfai)*v;
        % Capital accumulation in both sectors - eq.C.54,55
        kpi =  (1-cdeltai)* exp(-(1/(1-alfai))*gv)*( kpi(-1) + spki - (1/(1-alfai))*v ) + ( 1 - (1-cdeltai)* exp(-(1/(1-alfai))*gv))*(qs + invei);
        kpc =  (1-cdeltac)* exp(-(1/(1-alfai))*gv)*( kpc(-1) + spkc - (1/(1-alfai))*v ) + ( 1 - (1-cdeltac)* exp(-(1/(1-alfai))*gv))*(qs + invec);
        % Wage Phillips curve - eq.C.63
	      w =  (1/(1+cbeta))*w(-1)
               +(cbeta/(1+cbeta))*w(+1)
               - ( (1-cprobw*cbeta)*(1-cprobw)/(cprobw*(1+cbeta)*(1+csigl*(1+1/(clandawaux)))))* (w - csigl*lab - b + lam)
               + (cindw/(1+cbeta))*(pinfc(-1)-spi)
               - ((1+cbeta*cindw)/(1+cbeta))*(pinfc-spi)
               + (cbeta/(1+cbeta))*(pinfc(+1)-spi)
               + (cindw/(1+cbeta))*( z(-1) + alfac/(1-alfai)*v(-1) )
               - (1+cbeta*cindw-crhoz*cbeta)/(1+cbeta)*z
               - ((1+cbeta*cindw-crhov*cbeta)/(1+cbeta))*(alfac/(1-alfai))*v
               + sw ;
        % Labour market aggregation - eq.C.78
            lab = Lc/Lss*labc + Li/Lss*labi;
        % Total output - eq.C.77
            y = (css/yss)*c+(cpi*iss/yss)*(inve+ pi) + g ;
        % Taylor rule - eq.C.74         
            r =  crpi*(1-crr)*pinfc
               +cry*(1-crr)*(pinfc - pinfc(-1))
               +crdy*(1-crr)*(y-y(-1))
               +crr*r(-1)
               +ms  ;
        pinfi - pinfc  = pi - pi(-1); 
  % Equations needed to implement financial intermediaries:
        % Stochastic discount factor of bank - eq.C.64
        sdfb = lam-lam(-1);
        % Definition of nu for C sector - eq.C.65
        nuc = -cthetabss*(1-cthetabss*cbeta*z1css)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z1css)*(sdfb(+1)-z(+1)-alfac/(1-alfai)*v(+1)) + (1-cthetabss*cbeta*z1css)/(rbcss-rss)*(rbcss*rbc(+1) - rss*r)  +  cthetabss*cbeta*z1css*(z1c(+1)+nuc(+1)+cthetab);
        % Definition of nu for I sector - eq.C.65
        nui = -cthetabss*(1-cthetabss*cbeta*z1iss)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z1iss)*(sdfb(+1)-z(+1)-alfac/(1-alfai)*v(+1)) + (1-cthetabss*cbeta*z1iss)/(rbiss-rss)*(rbiss*rbi(+1) - rss*r)  +  cthetabss*cbeta*z1iss*(z1i(+1)+nui(+1)+cthetab);
        % Definition of eta for C sector - eq.C.66
        etac = -cthetabss*(1-cthetabss*cbeta*z2css)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z2css)*(sdfb(+1)-z(+1)-alfac/(1-alfai)*v(+1) + r)  +   cthetabss*cbeta*z2css*(z2c(+1)+etac(+1)+cthetab);
        % Definition of eta for I sector - eq.C.66
        etai = -cthetabss*(1-cthetabss*cbeta*z2iss)/(1-cthetabss) * cthetab + (1-cthetabss*cbeta*z2iss)*(sdfb(+1)-z(+1)-alfac/(1-alfai)*v(+1) + r)  +   cthetabss*cbeta*z2iss*(z2i(+1)+etai(+1)+cthetab);
        % Definition of z1 for C sector - eq.C.67
		z1c = lrc - lrc(-1) + z2c;
        % Definition of z1 for I sector - eq.C.67
		z1i = lri - lri(-1) + z2i;
        % Definition of z2 for C sector - eq.C.68
		z2c = 1/((rbcss-rss)*lrcss+rss) * ( rbcss*lrcss*rbc + rss*(1-lrcss)*r(-1) + (rbcss-rss)*lrcss*lrc(-1) );
        % Definition of z2 for I sector - eq.C.68
		z2i = 1/((rbiss-rss)*lriss+rss) * ( rbiss*lriss*rbi + rss*(1-lriss)*r(-1) + (rbiss-rss)*lriss*lri(-1) );
        % Leverage ratio of bank in C sector - eq.C.69
		lrc = etac + nucss/(clamb-nucss)*nuc;
        % Leverage ratio of bank in I sector - eq.C.69
		lri = etai + nuiss/(clamb-nuiss)*nui;
        % Wealth accumulation equation of bank in C sector - eq.C.71
        nc = sncss*cthetabss*exp(-ga-alfac/(1-alfai)*gv)*((rbcss-rss)*lrcss+rss) * (nc(-1) + cthetab(-1) - z -alfac/(1-alfai)*v + snc)
            + sncss*cthetabss*exp(-ga-alfac/(1-alfai)*gv) * ( rbcss*lrcss*rbc - rss*lrcss*r(-1) + (rbcss-rss)*lrcss*lrc(-1) + rss*r(-1) )
            + (1-exp(-ga-alfac/(1-alfai)*gv)*((rbcss-rss)*lrcss+rss)*cthetabss*sncss) * (qc + sc + snc);
        % Wealth accumulation equation of bank in I sector - eq.C.71
        ni = sniss*cthetabss*exp(-ga-alfac/(1-alfai)*gv)*((rbiss-rss)*lriss+rss) * (ni(-1) + cthetab(-1) - z -alfac/(1-alfai)*v + sni)
            + sniss*cthetabss*exp(-ga-alfac/(1-alfai)*gv) * ( rbiss*lriss*rbi - rss*lriss*r(-1) + (rbiss-rss)*lriss*lri(-1) + rss*r(-1) )
            + (1-exp(-ga-alfac/(1-alfai)*gv)*((rbiss-rss)*lriss+rss)*cthetabss*sniss) * (qi + si + sni);
        % Borrow in advance constraint for C sector
		kpc = sc;
        % Borrow in advance constraint for I sector
		kpi = si;
        % Leverage equation in C sector - eq.C.70
        qc = lrc + nc - sc + psicss/(1-psicss)*psic;
        % Leverage equation in I sector - eq.C.70
        qi = lri + ni - si + psiiss/(1-psiiss)*psii;
        % Stochastic return on assets for bank in C sector - eq.C.72
    	rbc = 1/(crkc+qcss*(1-cdeltac)) * ( crkc*(rkc+zcapc) + qcss*(1-cdeltac)*(qc) ) -qc(-1) +spkc + z - (1-alfac)/(1-alfai)*v;
        % Stochastic return on assets for bank in I sector - eq.C.72
    	rbi = 1/(crki+qiss*(1-cdeltai)) * ( crki*(rki+zcapi) + qiss*(1-cdeltai)*(qi) ) -qi(-1) +spki + z - (1-alfac)/(1-alfai)*v;
        % Price of capital in C sector - eq.C.51
		qc = exp(2*1/(1-alfai)*gv)*csadjcost * ( invec-invec(-1)+1/(1-alfai)*v) - cbeta*exp(2*1/(1-alfai)*gv)*csadjcost * (invec(+1)-invec+1/(1-alfai)*v(+1)) - qs + pi + (1+crho) * ( (iiss^(-crho)+icss^(-crho))^(-1) * (icss^(-crho)*invec + iiss^(-crho)*invei) - invec );
        % Price of capital in I sector - eq.C.52
		qi = exp(2*1/(1-alfai)*gv)*csadjcost * ( invei-invei(-1)+1/(1-alfai)*v) - cbeta*exp(2*1/(1-alfai)*gv)*csadjcost * (invei(+1)-invei+1/(1-alfai)*v(+1)) - qs + pi + (1+crho) * ( (iiss^(-crho)+icss^(-crho))^(-1) * (icss^(-crho)*invec + iiss^(-crho)*invei) - invei );
        % External finance premium in C sector
		spreadc = rbc(+1)-r;
        % External finance premium in I sector
		spreadi = rbi(+1)-r;
        % Central Bank's feedback rule for C sector
        psic = cvarthetac*(rbc(+1)-r);
        % Central Bank's feedback rule for I sector
        psii = cvarthetai*(rbi(+1)-r);
        % Capital aggregation - for comparison with SW2007
            k = (KcLc*Lc/Lss)*kc + (KiLi*Li/Lss)*ki;
% Shock processes %%%%%%%%%%%%%%%%%%%%%%%%%%%%/
    % TFP growth shock to cons sector - eq.C.80
        z = crhoz*z(-1)  + ez;
    % TFP stationary shock to cons sector - eq.C.87
      z_l = crhozl*z_l(-1)  + ezl;
   % Investment-specific sector growth shock - eq.C.81
        v = crhov*v(-1)  + ev;  
    % Investment-specific stationary shock - eq.C.88      
         v_l = crhovl*v_l(-1)  + evl;
	%  Preference shock - eq.C.83       
        b = crhob*b(-1) + eb;
	% GDP measurement error - eq.C.85      
        g = crhog*g(-1) + eg;
    % installation shock     
        qs = crhoqs*qs(-1) + eqs;
	% monetary policy shock     
        ms = crhoms*ms(-1) + em;
	% C-Sector Price Markup Shock   
        spinfc = crhopinfc*spinfc(-1) + epinfmac - cmapc*epinfmac(-1);
	          epinfmac=epinfc;
    % I-Sector Price Markup Shock   
        spinfi = crhopinfi*spinfi(-1) + epinfmai - cmapi*epinfmai(-1);
	          epinfmai=epinfi;
	% Wage Markup Shock       
        sw = crhow*sw(-1) + ewma - cmaw*ewma(-1) ;
	          ewma=ew; 
    % Shock to inflation objective
	      spi = crhospi*spi(-1) + espi;
    % Shock to bank's equity capital in C and I sector - eq.C.89
       	snc = crhosnc*snc(-1) + enc;		
        sni = crhosni*sni(-1) + eni;
    % Shock to the quality of physical capital in C and I sector (valuation shock)
        spkc = crhospkc*spkc(-1) + epkc;
        spki = crhospki*spki(-1) + epki;
    % Shock to fraction of bankers that survive
       cthetab = crhothetab*cthetab(-1) + ethetab;
% measurement equations (using demeaned data) %%%%%%%%%%%%%%
dy=y-y(-1) + z + alfac/(1-alfai)*v   ;
dc=c-c(-1) + z + alfac/(1-alfai)*v   ;
dinve=inve-inve(-1) + 1/(1-alfai)*v  ;
dpi = pi - pi(-1) + z + (alfac-1)/(1-alfai)*v  ;
dw=w-w(-1) + z + alfac/(1-alfai)*v   ;
pinfobsc = 1*(pinfc)  ;
pinfobsi = 1*(pinfi)  ;
robs =    r  ;
labobs = lab + log(Lss) ;
rrate = r - pinfc(+1); 
spreadobsi = rbi(+1) -robs;
spreadobsc = rbc(+1) -robs;
dequity = exp(ga + alfac/(1-alfai)*gv) * ( ( (qcss*scss/lrcss)/(qcss*scss/lrcss+qiss*siss/lriss) ) *(nc-nc(-1)) 
+ (1- ( (qcss*scss/lrcss)/(qcss*scss/lrcss+qiss*siss/lriss) ) )*(ni-ni(-1)) + z + alfac/(1-alfai)*v );
end; 

%********************************************************************
% Below is link to separate part dealing with computation of steady-state, necessary as underlying model is highly non-linear
@#include "GTZ2021_SS.mod"
%********************************************************************

shocks;
var ez;     % C-sector TFP
stderr 0.01;
var ev;     % I-sector TFP
stderr 0.01;
var eb;     % Preference Shock
stderr 0.01;
var eg;     % GDP measurement error
stderr 0.01;
var eqs;
stderr 0.01;
var em;     % Monetary Policy shock
stderr 0.01;
var epinfc; % C-sector price markup shock
stderr 0.01;
var epinfi; % I-sector price markup shock
stderr 0.01;
var ew;     % wage markup shock
stderr 0.01;
var espi;
stderr 0.01;
var enc;    % C-sector bank equity capital shock
stderr 0.01;
var eni;    % I-sector bank equity capital shock
stderr 0.01;
var ezl;
stderr 0.01;
var evl;
stderr 0.01;
var epki;   % I-sector contemporaneous valuation shock
stderr 0.01;
var epkc;   % C-sector contemporaneous valuation shock
stderr 0.01;
var ethetab;
stderr 0.01;
end;

estimated_params;
stderr ez,0.42,0.01,100,INV_GAMMA_PDF,0.5,2.0;
stderr ev,1.46,0.001,100,INV_GAMMA_PDF,0.5,2.0;
stderr eb,1.87,0.025,150,INV_GAMMA_PDF,0.1,2.0;
stderr eg,0.45,0.01,100,INV_GAMMA_PDF,0.5,2.0;
stderr em,0.13,0.01,80,INV_GAMMA_PDF,0.1,2.0;
stderr epinfc,0.28,0.01,80,INV_GAMMA_PDF,0.1,2.0;
stderr epinfi,0.122,0.01,80,INV_GAMMA_PDF,0.1,2.0;
stderr ew,0.33,0.01,20,INV_GAMMA_PDF,0.1,2.0;
stderr enc,0.260,0.01,100,INV_GAMMA_PDF,0.1,2.0;
stderr eni,0.19,0.01,100,INV_GAMMA_PDF,0.1,2.0;
stderr epkc,0.060,0.01,100,INV_GAMMA_PDF,0.1,2.0;
stderr epki,1.70,0.01,100,INV_GAMMA_PDF,0.1,2.0;
%stderr epkc4,0.06,0.01,100,INV_GAMMA_PDF,0.1/sqrt(2),2.0;
%stderr epkc8,0.205,0.01,100,INV_GAMMA_PDF,0.1/sqrt(2),2.0;
%stderr epki4,0.12,0.01,100,INV_GAMMA_PDF,0.1/sqrt(2),2.0;
%stderr epki8,0.15,0.01,100,INV_GAMMA_PDF,0.1/sqrt(2),2.0;
crhoz,0.16 ,.01,.9999,BETA_PDF,0.4,0.20;
crhov,.29 ,.01,.9999,BETA_PDF,0.4,0.20;
crhob,.97,.01,.9999,BETA_PDF,0.6,0.20;
crhog,.97,.01,.9999,BETA_PDF,0.6,0.20;
crhopinfc,.43,.01,.9999,BETA_PDF,0.6,0.20;
crhopinfi,.8,.01,.9999,BETA_PDF,0.6,0.20;
crhow,.29,.001,.9999,BETA_PDF,0.6,0.20;
crhosnc,0.82 ,.01,.9999,BETA_PDF,0.5,0.20;
crhosni,0.55 ,.01,.9999,BETA_PDF,0.5,0.20;
crhospkc,0.90 ,.01,.9999,BETA_PDF,0.6,0.20;
crhospki,0.48 ,.01,.9999,BETA_PDF,0.6,0.20;
csadjcost,2.81,0.2,50,GAMMA_PDF,4,1.0;
chabb,0.67,0.001,0.99,BETA_PDF,0.5,0.1;
cprobw,0.64,0.01,0.99,BETA_PDF,0.66,0.1;
csigl,1.6,0.025,10,GAMMA_PDF,2,0.75;
cprobpc,0.82,0.01,0.99,BETA_PDF,0.66,0.10;
cprobpi,0.6,0.01,0.99,BETA_PDF,0.66,0.10;
cindw,0.24,0.000000001,0.99,BETA_PDF,0.5,0.15;
cindpc,0.25,0.000000001,0.99,BETA_PDF,0.5,0.15;
cindpi,0.23,0.000000001,0.99,BETA_PDF,0.5,0.15;
czcapi,4.92,0.000001,50,GAMMA_PDF,5.0,1.0;
czcapc,4.50,0.000001,50,GAMMA_PDF,5.0,1.0;
crpi,2.054,1.0,5,NORMAL_PDF,1.7,0.30;
crr,0.88,0.1,0.99,BETA_PDF,0.60,0.20;
crdy,0.25,0.000001,0.9,NORMAL_PDF,0.125,0.05;
cry,0.16,0.0000000001,0.8,NORMAL_PDF,0.25,0.1;
cminrho,0.1,0.00000000001,0.999999,BETA_PDF,0.5,0.20;
end;
varobs dc dinve dy labobs dw  pinfobsc pinfobsi robs spreadobsc spreadobsi dequity; 
% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/
% For Estimation
% Data from 1990Q2-2011Q1
% NB: "USdata_9" is a Matlab file containing GTZ data 
estimation(datafile= USdata_9, mode_compute=1,prior_trunc=1e-50, first_obs=1, presample=1, lik_init=1, prefilter=0, mh_replic=0,mh_nblocks=2,mh_jscale=0.25,mh_drop=0.2, nodiagnostic) dc;
stoch_simul(Tex,irf = 40) y c r inve invec invei lab labc labi w k; % SW: y c inve pinf r w k lab
%stoch_simul(conditional_variance_decomposition = 8, irf = 0) dy dinve dc labobs dw  pinfobsc pinfobsi robs spreadobsc spreadobsi dequity ;
%stoch_simul(Tex,irf = 40) y c inve pinf r w k lab;
%----------------------------------------------------------------
% generate LaTeX output
%----------------------------------------------------------------
write_latex_dynamic_model;
write_latex_parameter_table;
write_latex_definitions;
write_latex_prior_table;
collect_latex_files;
% delete the next command if you do not have a Tex app installed
if system(['pdflatex -halt-on-error -interaction=batchmode ' M_.fname '_TeX_binder.tex'])
    error('TeX-File did not compile.')
end
disp(' ');
disp('STARTING DYNGRAPH');
% delete the next command if you do not have dyngraph installed
dyngraph;