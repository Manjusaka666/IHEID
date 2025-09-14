function dyngraph(str)
% function dyngraph('name.pdf')
%   'name.pdf' is by default the model's name
%   '.pdf' est facultative

% Created Gilles Bélanger
% Ministère des Finances du Québec
% Released under GPL 2

N = length(get(0,'Children'));
if N == 0
    return
end
if nargin == 0
    str = get(0,'DiaryFile');
    strroot = str(1:length(str)-4);
    str = [ strroot '.pdf' ];
elseif length(str) > 5
	if strcmp('.pdf',str(length(str)-3:length(str))) == 0
		str = [ str '.pdf' ];
    end
end
for k=1:N
    figure(k)
    suptitle(get(k,'Name'))
    if k > 1
        print('-dpsc2','input.ps','-append')
    else
        print('-dpsc2','input.ps')
    end
end
strdel = [ 'del ' strroot '_IRF_*.pdf ' strroot '_IRF_*.fig ' strroot '_IRF_*.eps ' ];
system(strdel);
strdel = [ 'del ' strroot '_Priors*.pdf ' strroot '_Priors*.fig ' strroot '_Priors*.eps ' ];
system(strdel);
strdel = [ 'del ' strroot '_CheckPlots*.pdf ' strroot '_CheckPlots*.fig ' strroot '_CheckPlots*.eps ' ];
system(strdel);
strdel = [ 'del ' strroot '_HistoricalAndSmoothedVariables*.pdf ' strroot '_HistoricalAndSmoothedVariables*.fig ' strroot '_HistoricalAndSmoothedVariables*.eps ' ];
system(strdel);
strdel = [ 'del ' strroot '_SmoothedShocks*.pdf ' strroot '_SmoothedShocks*.fig ' strroot '_SmoothedShocks*.eps ' ];
system(strdel);
ps2pdf('psfile', 'input.ps', 'pdffile', str, 'gspapersize', 'a4', 'deletepsfile', 1, 'gscommand', 'C:\Program Files\gs\gs9.26\bin\gswin64c.exe', 'gsfontpath', 'C:\Program Files\gs\gs9.26\lib', 'gslibpath', 'C:\Program Files\gs\gs9.26\lib')
end
