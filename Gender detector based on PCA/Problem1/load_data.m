function [smagNote, smagMusic, sphaseMusic] = load_data()
%% Argument Descriptions
% Required Input Arguments:
% None

% Required Output Arguments:
% smagNote: 1025 x 11 matrix containing the mean spectrum magnitudes of the notes. A correct sequence of the notes is REQUIRED. (From left to right: e f g a b c d e2 f2 g2 a2)
% smagMusic: 1025 x K matrix containing the spectrum magnitueds of the music after STFT.
% sphaseMusic: 1025 x K matrix containing the spectrum phases of the music after STFT.

%% Load Spectrum Magnitudes of Notes
% Fill your code here to return 'smagNote'
notesfolder = '/Users/youzhedou/Desktop/Code_samples/Machine-Learning-for-Signal-Processing/HW1/data/notes_15/';
listname = dir([notesfolder '*.wav']);
notes = [];
for k =1:length(listname)
    [s,fs] = audioread([notesfolder listname(k).name]); 
    s = resample(s,16000,fs);
    spectrum = stft(s(:,1)',2048,256,0,hann(2048));
    % Find the central frame
    middle = ceil(size(spectrum,2)/2);
    note = abs(spectrum(:,middle));
    % Clean up everything more than 40db below the peak
    note(find(note < max(note(:))/100)) = 0;
    note = note/norm(note); %normalize the note to unit length

    notes = [notes,note];
    
end
smagNote=notes;

%% Load Spectrum Magnitues and Phases of The Provided Music
% Fill your code here to return 'smagMusic' and 'sphaseMusic'
[s,fs] = audioread('/Users/youzhedou/Desktop/Code_samples/Machine-Learning-for-Signal-Processing/HW1/data/polyushka.wav');
% resample the signal to std sampling rate for convenience
s = resample(s,16000,fs);
spectrum = stft(s',2048,256,0,hann(2048));
music = abs(spectrum);
sphase = spectrum ./(abs(spectrum)+eps);
smagMusic=music;
sphaseMusic=sphase;