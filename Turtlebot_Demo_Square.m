tb = turtlebot('192.168.1.3');
odom = getOdometry(tb);
odomList = zeros(20,2);
resetOdometry(tb);

for i = 1:5
   
    %Collection location
    odom = getOdometry(tb);
    odomList(i,:) = [odom.Position(1) odom.Position(2)];
    
    %Move Forward
    setVelocity(tb, 0.3, 0, 'Time', 3);
    pause(1)
    
    %Rotate 90 degrees
    setVelocity(tb, 0, pi/4, 'Time', 3);
    pause(1)
    
    %Iterate
    i = i+1;
  
end 
pause(1);

plot(odomList(:,1), odomList(:,2))
clear tbot