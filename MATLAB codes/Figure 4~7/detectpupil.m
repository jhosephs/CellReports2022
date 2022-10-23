function [pupilArea, cenx, ceny] = DetectPupil(obj, NumberOfFrames, cnt, threshold)


frame=read(obj,cnt);

if size(frame,3)==3
    frame=rgb2gray(frame);
end

rawFrame = frame+100;
frame = frame + 100;
piel = frame;
piel(1:100, :) = 255;
piel=~imbinarize(piel,threshold);
piel=bwmorph(piel,'close');
piel=bwmorph(piel,'open');
piel=bwareaopen(piel,1000);
piel=imfill(piel,'holes');

s = regionprops(piel, 'Area', 'BoundingBox');
areas = [s.Area].';
s2 = s(areas > 500);

out = false(size(piel));

for idx = 1 : numel(s2)
    bb = floor(s2(idx).BoundingBox);
    out(bb(2):bb(2)+bb(4)-1, bb(1):bb(1)+bb(3)-1) = piel(bb(2):bb(2)+bb(4)-1, bb(1):bb(1)+bb(3)-1);
end

out2 = false(size(piel));
[X,Y] = meshgrid(1:size(piel,2), 1:size(piel,1));

for idx = 1 : numel(s2)
    bb = floor(s2(idx).BoundingBox);
    cenx = bb(1) + (bb(3) / 2.0);
    ceny = bb(2) + (bb(4) / 2.0);
    radi = max(bb(3), bb(4)) / 2;
    tmp = ((X - cenx).^2 + (Y - ceny).^2) <= radi^2;
    out2 = out2 | tmp;
end

imagesc(rawFrame);
colormap gray
hold on

if isempty(s2)
    pupilArea = NaN;
    cenx = NaN;
    ceny = NaN;
    saveas(gcf, [cnt '_pupil.jpg'])
else
    centers = [ cenx ceny ];
    viscircles(centers, radi, 'Color', [0.6350 0.0780 0.1840], 'LineWidth',3);
    pupilArea = (radi)^2 * 3.14;
    cenx = cenx(1);
    ceny = ceny(1);
    
    hold on
    
    saveas(gcf, [num2str(cnt) '_pupil.jpg'])
end
drawnow;

hold off;

clear frame idx bb  radi tmp out2 out tmp piel bb2 radi2 out3 piel2 tm2 idx2 piel s3 s2 s1 s4

end

