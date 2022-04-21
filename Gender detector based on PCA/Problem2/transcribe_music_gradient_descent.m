function [T, E, transMatT, smagMusicProj] = transcribe_music_gradient_descent(M, N, lr, num_iter, threshold)
% Input: 
%   M: (smagMusic) 1025 x K matrix containing the spectrum magnitueds of the music after STFT.
%   N: (smagNote) 1025 x 11 matrix containing the spectrum magnitudes of the notes.
%   lr: learning rate, i.e. eta as in the assignment instructions
%   num_iter: number of iterations
%   threshold: threshold
% Output:
%   T: (transMat) 11 x K matrix containing the transcribe coefficients.
%   E: num_iter x 1 matrix, error (Frobenius norm) from each iteration
%   transMatT: 11 x K matrix, threholded version of T (transMat) using threshold
%   smagMusicProj: 1025 x K matrix, reconstructed version of smagMusic (M) using transMatT
a=size(M);
d=a(1)*a(2);
W=ones(15,a(2));
E=[];
T=[];
transMatT=[];
for i=1:num_iter
    error=norm(M-N*W,'fro');
    E=[E;error];
    %der=-2/d*N'*(M-N*W);
    der=-N'*(M-N*W);
    W=W-lr*der;
    T=W;
    W(W<0)=0;
end
transMatT=W;
smagMusicProj=N*W;

    
