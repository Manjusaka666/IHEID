% This constructs the comparison of results 
%for SW2007 model with fiscal and varying g

load 'J:\MyCourseDSGEs2023\Tests\SW2007original_4HW3Q7a\Output\SW2007original_4HW3Q7a_results'; %  SW2007 with fiscal [g = eg]
OOPT.MODELS.oo_EHL = oo_;
load 'J:\MyCourseDSGEs2023\Tests\SW2007original_4HW3Q7c\Output\SW2007original_4HW3Q7c_results'; %  SW2007 with fiscal [g = crhog*(g(-1)) + eg + cgy*ea; [= original SW2007]]
OOPT.MODELS.oo_EHL1 = oo_;


OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'ea'};
OOPT.tit_shocks={'TFP shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'eb'};
OOPT.tit_shocks={'Risk premium shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'eg'};
OOPT.tit_shocks={'Exogenous spending shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'em'};
OOPT.tit_shocks={'MonPol shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'ew'};
OOPT.tit_shocks={'Wage Markup shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'epinf'};
OOPT.tit_shocks={'Price Markup shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);

OOPT.NN=40;
OOPT.plot_color={'b' '--r'}
OOPT.shocks_names={'eqs'};
OOPT.tit_shocks={'Investment-specific shock'};
OOPT.type_models={'oo_EHL' 'oo_EHL1'};
OOPT.legend_models={'Q7' 'Q8'}
OOPT.list_endo={'y' 'c_nlc' 'c_lc' 'inve' 'k' 'w' 'lab' 'r' 'pinf' };
OOPT.label_variables={'Output' 'Ricardian Cons' 'Non-Ricardian Cons' 'Investment' 'Capital Services'  'Wage Rate' 'Hours' 'Interest Rate'  'Inflation' };
plot_comp(OOPT);
