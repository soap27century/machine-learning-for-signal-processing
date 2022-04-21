%% Load Notes and Music
% You may reuse your 'load_data' function from prob 1
[smagNote, smagMusic, sphaseMusic] = load_data();
%% Compute The Transcribe Matrix: non-negative projection with gradient descent
% Use the 'transcribe_music_gradient_descent' function here
num_iter=250;
threshold=0;
%%
lr=0.1;
[T1, E1, transMatT1, smagMusicProj1] = transcribe_music_gradient_descent(smagMusic,smagNote, lr, num_iter, threshold);
%plot(E1);
% Store final W for each eta value in a text file called "problem3b_eta_xxx.dat"
% where xxx is the actual eta value. E.g. for eta = 0.01, xxx will be "0.01".
save('problem3b_eta_0.1.dat','transMatT1');
% Print the plot of E vs. iterations for each eta in a file called
% "problem3b_eta_xxx_errorplot.png", where xxx is the eta value.
%%
lr=0.01;
[T2, E2, transMatT2, smagMusicProj2] = transcribe_music_gradient_descent(smagMusic,smagNote, lr, num_iter, threshold);
%plot(E2);
save('problem3b_eta_0.01.dat','transMatT2');
%%
lr=0.001;
[T3, E3, transMatT3, smagMusicProj3] = transcribe_music_gradient_descent(smagMusic,smagNote, lr, num_iter, threshold);
%plot(E3);
save('problem3b_eta_0.001.dat','transMatT3');
%%
lr=0.0001;
[T4, E4, transMatT4, smagMusicProj4] = transcribe_music_gradient_descent(smagMusic,smagNote, lr, num_iter, threshold);
%plot(E4);
save('problem3b_eta_0.0001.dat','transMatT4');
%Print the eta vs. E as a bar plot stored in "problem3b_eta_vs_E.png".
%%
E=[E1(250,1),E2(250,1),E3(250,1),E4(250,1)];
bar(E)
set(gca,'XTickLabel',{'0.1','0.01','0.001','0.0001'}) 
%% Synthesize Music
% You may reuse the 'synthesize_music' function from prob 1.
% write the synthesized music as 'polyushka_syn.wav' to the 'results' folder.
synMusicf=synthesize_music(sphaseMusic,smagMusicProj1);
audiowrite('results/polyushka_syn.wav',synMusicf,22050);