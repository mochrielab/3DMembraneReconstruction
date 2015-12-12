function [ obj ] = PreProcessImage( obj )
%preprocess the raw image 
% 3/12/2015 Yao Zhao

wimg3 = obj.rawimage;
wimg3=wimg3-ImgTh(wimg3,obj.preprocessth(3));
wimg3(wimg3<0)=0;
extsize=5;
wimg3_ext=zeros(size(wimg3)+2*extsize);
wimg3_ext(1+extsize:end-extsize,1+extsize:end-extsize,1+extsize:end-extsize)=wimg3;
wimg3=wimg3_ext;
wimg3=bpass3(wimg3,obj.preprocessth(1),obj.preprocessth(2),obj.zxr);
wimg3=wimg3/max(wimg3(:));
obj.image=wimg3;


end

