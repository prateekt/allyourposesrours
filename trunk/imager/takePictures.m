function takePictures(n)

for i=1:n
    useCamera(strcat('test', num2str(i)));
end