function V = BurningNeighbors(M)
%BURNINGNEIGHBOURS Compute number of burning neighbours
%
%   V = BURNINGNEIGHBOURS(M) Computes for every element in state matrix M
%   the number of burning neigbours (state 5)
%
%   Original version: Sonia Kefi
%   2014 revision: Patrick Bogaart
%   (c) Utrecht university

[nrow, ncol] = size(M);

% Initialize V as empty matrix (0 burning nbrs)
V = zeros(nrow,ncol);

% For every grid cell, count the number of burning nbrs
for i = 2 : nrow-1
    for j = 2 : ncol-1
        % lower nbr burning?
        if M(i-1,j) == 5
            V(i,j) = V(i,j)+1 ;
        end
        % Upper nbr burning?
        if M(i+1,j) == 5
            V(i,j) = V(i,j)+1 ;
        end
        % Left nbr burning?
        if M(i,j-1) == 5
            V(i,j) = V(i,j)+1 ;
        end
        % Right nbr burning?
        if M(i,j+1) == 5
            V(i,j) = V(i,j)+1 ;
        end
    end
end
