function spc_makeRGBLifetimeMap(chan)
% translates spc.lifetimeMaps{chan} to an RGB map
% multiFLIM gy 2011116
global spc;
%Drawing
rgbimage = spc_im2rgb(spc.lifetimeMaps{chan}, [spc.switchess{chan}.lifeLimitUpper spc.switchess{chan}.lifeLimitLower] );

low = spc.switchess{chan}.LutLower;
high = spc.switchess{chan}.LutUpper;
    
if high-low > 0
    gray = (spc.projects{chan}-low)/(high - low);
else
    gray = 0;
end
gray(gray > 1) = 1;
gray(gray < 0) = 0;
rgbimage(:,:,1)=rgbimage(:,:,1).*gray;
rgbimage(:,:,2)=rgbimage(:,:,2).*gray;
rgbimage(:,:,3)=rgbimage(:,:,3).*gray;

spc.rgbLifetimes{chan} = rgbimage;
