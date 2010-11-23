function Z = useCamera(fileName)

%uses wacaw utility from command line
command = strcat('./wacaw i', fileName); 
Z = dos(command);