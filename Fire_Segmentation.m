img = 2;

fire1_RGB = imread('fire_1.jpg');
fire2_RGB = imread('fire_2.jpg');

fire1_Ycbcr = double(rgb2ycbcr(fire1_RGB));
fire2_Ycbcr = double(rgb2ycbcr(fire2_RGB));

% Calculating the properties and normalize it
fire1_Y  = fire1_Ycbcr(:,:,1)./max(max(max(fire1_Ycbcr)));
fire1_cb = fire1_Ycbcr(:,:,2)./max(max(max(fire1_Ycbcr)));
fire1_cr = fire1_Ycbcr(:,:,3)./max(max(max(fire1_Ycbcr)));

% we will focus our coding on image 2
% Calculating the properties and normalize it
fire2_Y  = fire2_Ycbcr(:,:,1)./max(max(max(fire2_Ycbcr)));
fire2_cb = fire2_Ycbcr(:,:,2)./max(max(max(fire2_Ycbcr)));
fire2_cr = fire2_Ycbcr(:,:,3)./max(max(max(fire2_Ycbcr)));

if img == 1
    Ip1 = fire1_Y - fire1_cb;
    Ip2 = fire1_cr - fire1_cb;
else
    Ip1 = fire2_Y - fire2_cb;
    Ip2 = fire2_cr - fire2_cb;
end
% We should define the fuzzy control rules
% I will use threshold for the regions of the fuzzy controller
NS = 0;
PS = .4;
PM = .8;
PB = 1;

% We will create the output 2-D output matrix as we will give 1 to high
% probabilty pixels, 0.5 for Meduim probabilty, and 0 for Low probabilty

%All in High Case now
if img == 1
    Output = ones(size(fire1_Y));
else
    Output = ones(size(fire2_Y));
end
% Low cases
Output( (Ip1 <= NS) | (Ip2 <= NS) ) = 0;  % LO  (7 cases)
Output( (Ip1 <= PS) & (Ip2 <= PS) ) = 0;  % LO  (1 case)
% Medium cases
Output( (Ip1 >= PM) & (Ip1 <= PB) ) = .6;  % ME  (3 cases)
Output( ((Ip1 >= PS) & (Ip1 <= PM)) & ((Ip2 >= PM) & (Ip2 <= PB)) ) = .6;  % ME (1 case)


Output = uint8(Output .* 255);

if img == 1
    subplot(1,2,1)
    imshow(fire1_RGB)
    subplot(1,2,2)
    imshow(Output)
else
    subplot(1,2,1)
    imshow(fire2_RGB)
    subplot(1,2,2)
    imshow(Output)
end