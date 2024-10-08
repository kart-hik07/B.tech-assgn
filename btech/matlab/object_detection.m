vid = videoinput('winvideo');
set(vid,'FramesPerTrigger',Inf);
set(vid,'Returnedcolorspace','rgb')
vid.FrameGrabInterval=5;
start(vid)
while(vid.FramesAcquired<=200)
    data=getsnapshot(vid);
    diff_im=imsubtract(data(:,:,1),rgb2gray(data));
    diff_im=medfilt2(diff_im,[3 3]);
    diff_im=im2bw(diff_im,0.18);
    diff_im=bwareaopen(diff_im,300);
    bw=bwlabel(diff_im,8);
    stats=regionprops(bw,'BoundingBox','Centroid');
    imshow(data)
    hold on
    for object=1:length(stats)
        bb=stats(object).BoundingBox;
        bc=stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2),'-m+')
        a=text(bc(1)+15,bc(2),strcat('X:',num2str(round(bc(1))),'y:',num2str(round(bc(2)))));
        set(a,'FontName','Arial','FontWeight','bold','FontSize',12,'color','yellow');
    end
hold off
end
stop(vid)
fiushdata(vid);
clear all
sprintf('%s','ImageTrackingcompleted')
