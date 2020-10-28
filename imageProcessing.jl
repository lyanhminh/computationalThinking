

K = [
    0   0  0
    1/2 0  1/2
    0   0  0
]  

M = reshape(1:50, 5, 10)  

function extend_mat(M::AbstractMatrix, i, j)
height, width = size(M)
vertical = i < 1 ? 1 : i > height ? height : i
side = j < 1 ? 1 : j > width ? width : j
return M[vertical, side]
end

function convolve_image(M::AbstractMatrix, K::AbstractMatrix)
height, width = size(M)
Ky, Kx = size(K) 
halfY, halfX = div(Ky, 2), div(Kx, 2)
Mprime = zeros(height, width)
for i in 1:height
 for j in 1:width
     window = reshape([extend_mat(M, i + y, j +x) for  y in -halfY:halfY, x in -halfX:halfX ] , Ky, Kx)
     Mprime[i,j] = sum(window .* K)
 end
end
return Mprime
end

function with_sobel_edge_detect(image)
S = ones(size(image))
height, width = size(image)
Gx = [1 0 -1; 2 0 -2; 1 0 -1]
Gy = transpose(Gx)
for i in 1:height, j in 1:width
 window = reshape([extend_mat(image,i + x, j + y) for x in -1:1, y in -1:1], size(Gx))
 gx, gy = sum(Gx .* window), sum(Gy .* window)
 S[i,j] = sqrt(gx^2 + gy^2)
end
return S
