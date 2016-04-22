function viewimage(d,i)

figure;
if min(size(d)) == 1
    imagesc(reshape(d(:,i),28,28)); colormap(gray)
else
    imagesc(d); colormap(gray)
end