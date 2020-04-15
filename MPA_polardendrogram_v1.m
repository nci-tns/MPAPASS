function [h,T,perm] = MPA_polardendrogram_v1(Z,varargin)
%POLARDENDROGRAM plots a polar dendrogram plot, taking same options as
%dendrogram and giving same outputs.
% Example:
% X= rand(100,2);
% Y= pdist(X,'cityblock');
% Z= linkage(Y,'average');
% [H,T] = polardendrogram(Z,'colorthreshold','default');

%Plot a normal dendrogram

[h,T,perm] = dendrogram(Z,varargin{:});
set(h,'Color','k','LineWidth',1)

%Get x and y ranges
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
minx = xlim(1);
maxx = xlim(2);
miny = ylim(1);
maxy = ylim(2);
xrange = (maxx-minx)-1;
yrange = maxy-miny;

line_detail = 1000; % higher equal more detail;

%Reshape into a polar plot
for i=1:size(h)
    xdata = get(h(i),'XData');
    ydata = get(h(i),'YData');
    
    %Rescale xdata to go from pi/12 to 2pi - pi/12
    startpos = deg2rad(0-(360/xrange/2));
    span = deg2rad(270);
    xdata = (((xdata-minx)/xrange)*(span)+startpos);
    
    %Rescale ydata to go from 1 to 0, cutting off lines
    %which drop below the axis limit
    ydata = max(ydata,miny);
    ydata = 1-((ydata-miny)/yrange);
    
    %To make horizontal lines look more circular,
    %insert ten points into the middle of the line before
    %polar transform
    newxdata = [xdata(1), linspace(xdata(2),xdata(3),line_detail), xdata(4)];
    newydata = [ydata(1), repmat(ydata(2),1,line_detail), ydata(4)];
    
    %Transform to polar coordinates
    [xdata,ydata]=pol2cart(newxdata,newydata);
    
    %Reset line positions to new polar positions
    set(h(i),'XData',xdata);
    set(h(i),'YData',ydata);
end


hold on
% scale axis
lineh(1) = polar([0,0],[0,1],'-');
set(lineh,'Color','none');


%Prettier
Scale = 2;
set(gca,'XLim',[-Scale,Scale],'YLim',[-Scale,Scale],'Visible','off');
daspect([1,1,100]);
zoom(2.8);





