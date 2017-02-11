[background, backgroundMap] = imread('background.png');
[compassN, compassNMap, compassNAlpha] = imread('compass_N.png');
[compassNNE, compassNNEMap, compassNNEAlpha] = imread('compass_NNE.png');
[compassENE, compassENEMap, compassENEAlpha] = imread('compass_ENE.png');
[compassE, compassEMap, compassEAlpha] = imread('compass_E.png');
figure();
strengths = (1:4)';
backgroundImage = imshow(background);
hold on
compassNImage = imshow(compassN);
compassNNEImage = imshow(compassNNE);
compassENEImage = imshow(compassENE);
compassEImage = imshow(compassE);
hold off
for i = 1:100
set(compassNImage,'AlphaData',compassNAlpha * strengths(4));
set(compassNNEImage,'AlphaData',compassNNEAlpha * strengths(3));
set(compassENEImage,'AlphaData',compassENEAlpha * strengths(2));
set(compassEImage,'AlphaData',compassEAlpha * strengths(1));
drawnow;
strengths = circshift(strengths,[1,0]);
pause(0.1);
end
