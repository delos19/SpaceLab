rosshutdown
ipaddress = '192.168.1.3';
tbot = turtlebot(ipaddress);

for i = 1:4
    
    %Move Forward
    setVelocity(tbot, 0.3, 0.5, 'Time', 5);
  
end 

clear tbot