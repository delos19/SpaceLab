rosshutdown
ipaddress = '192.168.1.3';
tbot = turtlebot(ipaddress);

for i = 1:4
    
    %Move Forward
    setVelocity(tbot, 0.3, 0, 'Time', 3);
    pause(1)
    
    %Rotate 90 degrees
    setVelocity(tbot, 0, pi/4, 'Time', 3);
    pause(1)
    
    %Iterate
    i = i+1;
  
end 

clear tbot