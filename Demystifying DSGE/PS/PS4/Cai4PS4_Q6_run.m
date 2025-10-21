% Cai4PS4_Q6_run.m
% Runs shock decompositions for investment using Q4 & Q5 models cloned for Q6.
% Outputs: PDF figures saved by Dynare in each model's Output folder.

clear; clc;

% --- SW period (1965Q1–2004Q4) ---
disp('Running Q6 SW shock decomposition (inve)...');
dynare Cai4PS4_Q6_SW.mod noclearall console;

% --- Longest period (decomp from 2005Q1) ---
disp('Running Q6 Longest shock decomposition (inve, start=2005Q1)...');
dynare Cai4PS4_Q6_Longest.mod noclearall console;

disp('Q6 shock decompositions completed. Check the Output folders for PDF graphs.');
