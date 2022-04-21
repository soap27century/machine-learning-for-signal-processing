clear all; clc;
%% Load Notes and Music
% Use the 'load_data' function here
[smagNote, smagMusic, sphaseMusic] = load_data();
%% Solution for Problem 1a here
% Place all the 15 scores W_i (for the 15 notes) into a single matrix W. 
% Place % the score for the i-th note in the i-th row of W.
% W will be a 15xT matrix, where T is the number of frames in the music.
% Store W in a text file called "problem1a.dat"
for i=1:15
    W(i,:)=pinv(smagNote(:,i))*smagMusic;  
end
save('problem1a.dat','W');


%% Solution to Problem 1b here: Synthesize Music
% Use the 'synthesize_music' function here.
% Use 'wavwrite' function to write the synthesized music as 'problem1b_synthesis.wav' to the 'results' folder.

synMusics=[];
for i=1:15
    Mi=smagNote(:,i)*W(i,:);
    synMusic=synthesize_music(sphaseMusic,Mi);
    synMusics=[synMusics;synMusic];
end;
synMusicf=zeros(1,length(synMusic));
for i=1:15
    synMusicf=synMusicf+synMusics(i,:);
end

audiowrite('results/problem1b_synthesis.wav',synMusicf,16000);


%% Solution for Problem 2a here
% Store W in a text file called "problem2a.dat"
W2=pinv(smagNote)*smagMusic;
save('problem2a.dat','W2');
%% Solution to Problem 2b here:  Synthesize Music
% Use the 'synthesize_music' function here.
% Use 'wavwrite' function to write the synthesized music as 'problem2b_synthesis.wav' to the 'results' folder.
M2=smagNote*W2;
synMusic=synthesize_music(sphaseMusic,M2);
audiowrite('results/problem2b_synthesis.wav',synMusicf,16000);
