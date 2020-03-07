close all; 
clc; clear;
rosshutdown
ipaddress = '192.168.1.3';
rosinit(ipaddress);

% Load the SDK
fprintf( 'Loading SDK...' );
Client.LoadViconDataStreamSDK();
fprintf( 'done\n' );
HostName = 'localhost:801';

% Make a new client
MyClient = Client();

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

%Initialize the local odometer data
odomdata = receive(odom,3);
pose = odomdata.Pose.Pose;
quat = pose.Orientation;
angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
    

%Store as origin
x0 = pose.Position.X
y0 = pose.Position.Y
theta0 = rad2deg(angles(1))

waypoints = [x0+2 y0+1]; % [x y] in meters 
dx = 100;
dy = 100;
tol = 0.01; % meter
Pos = [];
Vel = [];
Velx = 0;
Vely = 0;
Angz = 0;
Kx = 0.1;
Ky = 0.1;
figure('units','normalized','outerposition',[0 0 1 1])
%Send message in loop
while abs(dx) > tol || abs(dy) > tol
    %Receive initial odometer data
    odomdata = receive(odom,3);
    pose = odomdata.Pose.Pose;
    x = pose.Position.X;
    y = pose.Position.Y; %Where we need to change to get Z axis
    
    [Post, Rotat, Tmatrix] =  ABY_Get_Measurements_mod1(HostName,MyClient, 'Turtlebot'); 
    quat = pose.Orientation;
    angles = quat2eul([quat.W quat.X quat.Y quat.Z]);
    theta = rad2deg(angles(1))
    
    odomList(i,:) = [x y];
    t1 = clock;
    velmsg.Linear.X = Velx;
    velmsg.Linear.Y = Vely;
    velmsg.Angular.Z = Angz;
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
    
    dx = (xn- waypoints(1));
    dy = (yn - waypoints(2));
    
    %As dx or dy get smaller, so does 
    Velx = Kx*dx;
    Vely = Ky*dy;
    A = atan2(Vely,Velx);
    
    Angz = sind(theta + A*dt);
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

% Disconnect and dispose
MyClient.Disconnect();

% Unload the SDK
fprintf( 'Unloading SDK...' );
Client.UnloadViconDataStreamSDK();
fprintf( 'done\n' );
