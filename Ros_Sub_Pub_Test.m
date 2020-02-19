close all; 
clc; clear;
rosshutdown
ipaddress = '192.168.1.3';
rosinit(ipaddress);

%Set velocity
velocity = 0.1;
%resetOdometry(ipaddress);

%Create publisher
robot = rospublisher('mobile_base/commands/velocity');
odom = rossubscriber('/odom');
velmsg = rosmessage(robot);

velocity = 0.25;
i = 1;

%Set forward motion
velmsg.Linear.X = velocity;
Npts = 100;
    odomdata = receive(odom,3);
    pose = odomdata.Pose.Pose;
    x0 = pose.Position.X
    y0 = pose.Position.Y
waypoints = [x0-1 y0]; % [x y] in meters 
dx = 100;
dy = 100;
tol = 0.01; % meter
Pos = [];
Vel = [];
Velx = 0;
Vely = 0;
Kx = 0.1;
Ky = 0.1;
figure('units','normalized','outerposition',[0 0 1 1])
%Send message in loop
while abs(dx) > tol || abs(dy) >tol
    odomdata = receive(odom,3);
    pose = odomdata.Pose.Pose;
    x = pose.Position.X;
    y = pose.Position.Y;
    odomList(i,:) = [x y];
    t1 = clock;
%     velmsg.Linear.X = Velx;
    velmsg.Linear.Y = Vely;
    
    send(robot,velmsg);
    dt = etime(clock, t1);
    odomdata = receive(odom,3);
    pose = odomdata.Pose.Pose;
    xn = pose.Position.X;
    yn = pose.Position.Y;
    
    Dx =  xn - x;
    Dy =  yn - y;
    Vx = Dx/dt;
    Vy = Dy/dt;

    Pos = [Pos; x y];
    Vel = [Vel; Vx Vy];
    i = i+1;
    grid on;
    plot(x,y,'-db'); hold on
    pause(0.008)
    
    dx = (xn - waypoints(1));
    dy = (yn - waypoints(2));
    
    Velx = -Kx*dx;
    Vely = -Ky*dy;
    
%     if abs(Velx)>1
%         Velx = Velx/abs(Velx);
%     end
%     if abs(Vely)>1
%         Vely = Vely/abs(Vely);
%     end
end

%Plot the data
Dx =  odomList(end,1) - odomList(1,1);
Dy =  odomList(end,2) - odomList(1,2);

Vx = Dx/Npts;
Vy = Dy/Npts;
 
speed = sqrt(Vx.^2+Vy.^2)
% figure; 
% plot(odomList(:,1),odomList(:,2));

%plot(odomList(:,1), speed)
axis equal
clear tbot


