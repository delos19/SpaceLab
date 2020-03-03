close all; 
clc; clear;
rosshutdown
ipaddress = '192.168.1.3';
rosinit(ipaddress);
robot = rospublisher('/mobile_base/commands/velocity');
velmsg = rosmessage(robot);
laser = rossubscriber('/scan');

spinVelocity = 0.6;       % Angular velocity (rad/s)
forwardVelocity = 0.1;    % Linear velocity (m/s)
backwardVelocity = -0.02; % Linear velocity (reverse) (m/s)
distanceThreshold = 0.6;  % Distance threshold (m) for turning

  tic;
  while toc < 20
      % Collect information from laser scan
      scan = receive(laser);
      plot(scan);
      data = readCartesian(scan);
      x = data(:,1);
      y = data(:,2);
      % Compute distance of the closest obstacle
      dist = sqrt(x.^2 + y.^2);
      minDist = min(dist);     
      % Command robot action
      if minDist < distanceThreshold
          % If close to obstacle, back up slightly and spin
          velmsg.Angular.Z = spinVelocity;
          velmsg.Linear.X = backwardVelocity;
      else
          % Continue on forward path
          velmsg.Linear.X = forwardVelocity;
          velmsg.Angular.Z = 0;
      end   
      send(robot,velmsg);
  end