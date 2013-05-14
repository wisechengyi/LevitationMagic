close all;
clear all;
%constants
CHECKTIME = 0.01;
RADIUS = 20;
BallPosition = [100;300];
v = [0;0];
oldX = -1;
oldY = -1;

%%set up
DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
    'String', 'Break', ...
    'Callback', 'delete(gcbf)');

vid = videoinput('macvideo');
set(vid, 'ReturnedColorSpace', 'RGB');
triggerconfig(vid, 'manual');
start(vid);

aviobj = avifile('example.avi','compression','None');

%%capture initial image and flip
prev = getsnapshot(vid);
prev = flipdim(prev,2);
lastValidContour = prev(:,:,1).*0;

ddd =0;
% while (ddd<100)
while (ishandle(H))
    ddd=ddd+1;
    %     get coutour
    %     img = getNormalizedGreyScaleImageFromWebCam(vid);
    
    img = getsnapshot(vid);
    img = flipdim(img,2);
    %     diff = abs(img-background);
    diff = prev-img;
    grayDiff = rgb2gray(diff);
    diffStd = std2(grayDiff)
    if diffStd>3
        prev = img;
        BWdiff = im2bw(diff,graythresh(diff));
        contour = bwareaopen(BWdiff,20);
        lastValidContour = contour;
    else
        contour = lastValidContour;
    end
    
    %     imshow(contour);
    
    
    
    dist = 80;
    threshold =20;
    contourGradient = gradient(double(contour));
    
    [meanX, meanY] = getAverageXY(contourGradient);
    
    v=[0;0];
    if ( meanX ~= -1 && meanY ~= -1)
        if (oldX~=-1 && oldY ~=-1)
            %                 if (meanX-oldX>threshold)
            %                     disp('right');
            %                     v(1) = dist;
            %                 elseif( meanX - oldX < -threshold )
            %                     disp('left')  ;
            %                     v(1) = -dist;
            %                 else
            %                     v(1) = 0;
            %                 end
            
            if (meanY-oldY>threshold)
                disp('down');
                v(2) = dist;
            elseif( meanY - oldY < -threshold )
                disp('up')      ;
                v(2) = -dist;
            else
                v(2) = 0;stop
            end
        end
        oldX = meanX;
        oldY = meanY;
    end
    
    BallPosition= BallPosition+v;
    
    
    contourWithLady = addLady(BallPosition,img);
    %     contourWithLady = addLady([100;-40],img);
    %    subplot(1,2,1), imshow(contourWithLady)
    contourWithLady = imresize(contourWithLady,[480 640]);
    imshow(contourWithLady);
    
    pause(CHECKTIME);
    %%add to video
%     F=getframe(DlgH);
%     aviobj = addframe(aviobj,F);
    
end
stop(vid);
aviobj = close(aviobj);

