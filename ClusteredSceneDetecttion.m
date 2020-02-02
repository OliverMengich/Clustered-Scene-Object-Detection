phoneImage=imread('images (1).jpeg');
% staplerImage = imread('8.jpg');


phoneImage = rgb2gray(phoneImage);
% staplerImage = rgb2gray(staplerImage);

phonepoints = detectSURFFeatures(phoneImage);
figure;
imshow(phoneImage);
hold on 
plot(selectStrongest(phonepoints,90));

hold off

% staplerpoints = detectSURFFeatures(staplerImage);
% figure;
% imshow(staplerImage);
% hold on 
% plot(selectStrongest(staplerpoints,100));
% 
% hold off
% 


sceneImage = imread('scene1.jpg');
 sceneImage = rgb2gray(sceneImage);
scenepoints = detectSURFFeatures(sceneImage);
 
 figure;
 imshow(sceneImage);
 hold on
 plot(selectStrongest(scenepoints,300))
 hold off
 
 % now to extract the features between the images
 [phoneFeatures, mugPoints] = extractFeatures(phoneImage,phonepoints);
%  [staplerFeatures,staplerpoints] = extractFeatures(staplerImage,staplerpoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenepoints);


% to find the putative matches points
% matched features using their descriptors

PhonePairs = matchFeatures(phoneFeatures, sceneFeatures);
% StaplerPairs = matchFeatures(staplerFeatures,sceneFeatures);
% Display putatively matched features.
matchedPhonePoints = phonepoints(PhonePairs(:, 1), :);
matchedScenePoints = scenepoints(PhonePairs(:, 2), :);

matchedBoxPoints1 = staplerpoints(StaplerPairs(:, 1), :);
matchedScenePoints1 = scenepoints(StaplerPairs(:, 2), :);
 

figure;
showMatchedFeatures(phoneImage, sceneImage, matchedPhonePoints, ...
matchedScenePoints, 'montage');
% showMatchedFeatures(staplerImage, sceneImage, matchedBoxPoints1, ...
% matchedScenePoints1, 'montage');
title('Putatively Matched Points (Including Outliers)');




[tform, inlierBoxPoints, inlierScenePoints] = ...
estimateGeometricTransform(matchedBoxPoints1, matchedScenePoints2,...
'affine');

figure;
showMatchedFeatures(phoneImage, sceneImage, inlierBoxPoints, ...
inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');


boxPolygon = [1, 1;... % top-left
size(boxImage, 2), 1;... % top-right
size(boxImage, 2), size(boxImage, 1);... % bottom-right
1, size(boxImage, 1);... % bottom-left
1, 1];


newBoxPolygon = transformPointsForward(tform, boxPolygon);

figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');
