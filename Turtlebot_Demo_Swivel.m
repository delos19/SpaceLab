rosshutdown
ipaddress = '192.168.1.3';
tbot = turtlebot(ipaddress);

for i = 1:6
    
    setVelocity(tbot, 0.2, 0.6, 'Time', 2);
    setVelocity(tbot, 0.2, -0.6, 'Time', 2);
    i = i+1;
  
end 

clear tbot