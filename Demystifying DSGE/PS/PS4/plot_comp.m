function plot_comp(OOPT)
% Plot IRF for different models
% Input: OOPT object with the following fields:
% OOPT.type_models={'ooA_' 'ooB_'}; List of models
% OOPT.list_endo={'DPF' 'YYF' 'IIF'}; List of endogenous variables
% OOPT.shocks_names={'E_MONF' 'E_ZF' 'E_X' 'E_MUPF'}; List of shocks names
% OOPT.MODELS.ooA_=ooA_;
% OOPT.MODELS.ooB_=ooB_; List of objects of models variables (irfs
% necessary)
%
% Alternative options:
% OOPT.plot_color={'b' 'k'};
% OOPT.NN=8;
% OOPT.label_variables={'Inflation' 'Output' 'Interest rate'};
% OOPT.tit_shocks={'Interest rate' 'Productivity' 'Unit Root' 'Mark-up'};
% OOPT.legend_models={'Model A' 'Model B'};


% Coded by David Flori�n-Hoyle and Carlos Montoro 2007



type_models=OOPT.type_models;
list_endo=OOPT.list_endo;
shocks_names=OOPT.shocks_names;
MODELS=OOPT.MODELS;

if isfield(OOPT,'legend_models');
legend_models=OOPT.legend_models;
else
    legend_models=type_models;
end

if isfield(OOPT,'label_variables');
label_variables=OOPT.label_variables;
else
    label_variables=list_endo;
end

if isfield(OOPT,'tit_shocks');
tit_shocks=OOPT.tit_shocks;
else
    tit_shocks=shocks_names;
end

if isfield(OOPT,'plot_color');
plot_color=OOPT.plot_color;
else
    plot_color={'k' 'b' 'g' 'm' 'c' 'y' '--k' '--b' '--g' '--m' '--c' '--y' 'o-k' 'o-b' 'o-g' 'o-m' 'o-c' 'o-y' 'd-k' 'd-b' 'd-g' 'd-m' 'd-c' 'd-y'};
end

if isfield(OOPT,'NN');
NN=OOPT.NN;
else
    NN=8;
end

nii=size(list_endo,2);
nkk=size(shocks_names,2);
nmm=size(type_models,2);


number_of_plots_to_draw=nii ;%number_of_plots_to_draw = size(irfs,1);
[nbplt,nr,nc,lr,lc,nstar] = pltorg(number_of_plots_to_draw);
for kk=1:nkk 
hh = figure('Name',['Orthogonalized shock to ' tit_shocks{kk}]); 
	  for ii = 1:number_of_plots_to_draw
         	    subplot(nr,nc,ii);
                for mm=1:nmm
                    clear AUX;
                    if isfield(eval(['MODELS.' deblank(type_models{mm}) '.irfs']),[list_endo{ii} '_' shocks_names{kk}]);
                        AUX=eval(['MODELS.' deblank(type_models{mm}) '.irfs.' list_endo{ii} '_' shocks_names{kk}])';
                plot(1:NN,AUX(1:NN) ,plot_color{mm},'linewidth',1.5,'MarkerSize',5.0);
                hold on
                    end
                end
                plot([1 NN],[0 0],'-r','linewidth',0.5);
                hold off
 	    xlim([1 NN]);
 	    title(deblank(label_variables{ii}),'Interpreter','none');
        grid on;
          if ii==1;%%number_of_plots_to_draw
              legend(legend_models,'Location','SouthEast');%,'Location',[0.72 0.121 0.17 0.203]
          end
      end 
end
set(gcf,'Position',[1 31 1024 664])