
%% Getting US output through db.nomics
% quarterly real output
[my_mat,~,T] = call_dbnomics('OECD/QNA/USA.B1_GE.CQRSA.Q','OECD/QNA/USA.B1_GE.DOBSA.Q','OECD/KEI/IR3TIB01.USA.ST.Q');

% remove nan:
id_no_nan	= find(sum(isnan(my_mat),2)==0);
my_mat		= my_mat(id_no_nan,:);
T			= T(id_no_nan);

% selecting gross series
gross_y = my_mat (:,2);
def_y 	= my_mat (:,3);
r 		= my_mat (:,4);

% growth rate of real output
y_obs  =  100*diff(log(gross_y./def_y));
% inflation rate
pi_obs = 100*diff(log(def_y));
% quarterly rate
r_obs  = r(2:end)/4;

figure;
subplot(3,1,1)
plot(T(2:end),y_obs)
title('output growth')
subplot(3,1,2)
plot(T(2:end),pi_obs)
title('inflation rate')
subplot(3,1,3)
plot(T(2:end),r_obs)
title('interbank rate')

save mydata.mat y_obs pi_obs r_obs T;
