%equal conditions i)
nx = 50;
ny = 50;

%unequal conditions viii)
% nx = 50;
% ny = 5;

V = zeros(nx,ny);
G = sparse(nx*ny,nx*ny);

% dx = 1;
% dy = 1;

for i = 1:nx
    for j = 1:ny
        n = j + (i-1)*ny; %mapping equation
        
        %messup = 1; %when ON, messes up G matrix diagonal (change to -2)
        messup = 0;
            
        if i == 1 || i == nx || j == 1 || j == ny %boundary conditions
            G(n,n) = 1; %sparse function sets everything to 0 so we don't have to explicitly say G(n,:) = 0;
                        
        elseif i > 10 && i < 20 && j > 10 && j < 20 && messup == 1 
            G(n,n) = -2;
            
        else
            nxm = j + ((i-1)-1)*ny; %(i-1,j)
            nxp = j + ((i+1)-1)*ny; %(i+1,j)
            nym = (j-1) + (i-1)*ny; %(i,j-1)
            nyp = (j+1) + (i-1)*ny; %(i,j+1)
            
            G(n,n) = -4;
            G(n,nxm) = 1;
            G(n,nxp) = 1;
            G(n,nym) = 1;
            G(n,nyp) = 1;
        end
    end
end

spy(G)
hold on

nmodes = 9;

[E,D] = eigs(G,nmodes,'SM');

figure(1)
plot(diag(D),'bo');

np = sqrt(nmodes);

figure(2) %looking at the modes one at a time
k = 1; % mode number you want to look at
L = E(:,k);
for i = 1:nx
    for j = 1:ny
        n = j + (i-1)*ny;
        V(i,j) = L(n);
    end
    surf(V)
end

figure(3) %looking at all 9 modes at once
for k = 1:nmodes
    L = E(:,k);
    for i = 1:nx
        for j = 1:ny
            n = j + (i-1)*ny;
            V(i,j) = L(n);
        end
        subplot(np,np,k), surf(V)
    end
end

