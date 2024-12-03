function first_order_print2f(filename,fx,fxp,fy,fyp,f,ETASHOCK,statevar,controlvar,sourcename,varme)
%first_order_print2f.m
%first_order_print2f(filename,fx,fxp,fy,fyp,f,ETASHOCK,statevar,controlvar)
% Writes symbolic derivatives of the equilibrium conditions of a DSGE model  to an m-file for numeric evaluation.
% inputs: 
%         filename: ' ...' name of the file to append to '_num_eval'
%  fx,fxp,fy,fyp,f:   symbolic matrices   of the model equations and its first-order derivatives.   They are the  output of the program anal_deriv.m
%        ETASHOCK: symbolic matrix scaling std dev of shocks (the evolution of the state  is: x_t+1 = hx x_t + ETASHOCK epsilon_t+1, where epsilon_t+1 has an identity var/cov matrix)
%sourcename is the name of the .M file where the equilibrium conditions are written.
% output: m-file "filename_num_eval.m" 
%© Martín Uribe, October 2016.

%Note. This program uses an approach based on the Matlab function  'diary'. See the script anal_deriv_print2f.m by Andrea Pescatori  for a program that accomplishes the same task using an approach based on the Matlab function fprint

format compact

fname = [ filename '_num_eval.m'];

if nargin<11
varme = [];
end

if exist(fname)>0
delete(fname)
end

diary(fname)

disp(['%' fname ' was created by running  '  sourcename '.m']);

disp('nfx = [');
disp(fx);disp('];');

disp('nfxp = [');
disp(fxp);disp('];');



disp('nfy = [');
disp(fy);disp('];');

disp('nfyp = [');
disp(fyp);disp('];');

disp('nf = [');
disp(transpose(f));disp('];');

disp('nf=transpose(nf);');

disp('nETASHOCK = [');
disp(ETASHOCK);disp('];');

disp('nvarshock = [');
disp(ETASHOCK*ETASHOCK');disp('];');


disp('nvarme = [');
disp(varme);disp('];');

%Positions of variables in state and control vectors
nstate = length(statevar);
for i=1:nstate
disp(['n' char(statevar(i)) ' = ' num2str(i) ';']);
end;
disp(['nstate = ' num2str(nstate) ';']);

ncontrol = length(controlvar);
for i=1:ncontrol
disp(['n' char(controlvar(i)) ' = ' num2str(i) ';']);
end;
disp(['ncontrol = ' num2str(ncontrol) ';']);

diary off
clc