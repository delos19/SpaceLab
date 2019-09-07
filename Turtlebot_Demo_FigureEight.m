rosshutdown
ipaddress = '192.168.1.3';
tbot = turtlebot(ipaddress);

for i = 1:4
    
    setVelocity(tbot, 0.2,  0.4, 'Time', 2);
    setVelocity(tbot, 0.2,  0.8, 'Time', 4);
    setVelocity(tbot, 0.2, -0.4, 'Time', 4);
    setVelocity(tbot, 0.2, -0.8, 'Time', 2);
    
    i = i+1;
  
end 

clear tbot