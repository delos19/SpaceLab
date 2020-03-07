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
%velmsg.Linear.X = velocity;
Npts = 100;

   
waypoints = [0 2]; % [x y] in meters 
dx = 100;
dy = 100;
dth = 100;
tol = 0.1; % meter
tol_th = 0.75; %radians
Pos = [];
Vel = [];
Velx = 0;
Vely = 0;
Angz = 0;
Kx = .1;
Ky = .1;
Kth = .5;
figure('units','normalized','outerposition',[0 0 1 1])
%Send message in loop
% while abs(dx) > tol || abs(dy) > tol || abs(dth) > tol_th
while abs(dth) > tol_th

    %Receive initial odometer data
    
    [post, Rotat, Tmatrix] =  ABY_Get_Measurements_mod1(HostName,MyClient, 'Turtlebot'); 
    x = post(1)/1000;
    y = post(2)/1000;
    theta = Rotat(3);
    odomList(i,:) = [x y];
    
    t1 = clock;
    
    %velmsg.Linear.X = Velx;
    %velmsg.Linear.Y = Vely;
    velmsg.Angular.Z = Angz;
    send(robot,velmsg);
    
    dt = etime(clock, t1);
    [post, Rotat, Tmatrix] =  ABY_Get_Measurements_mod1(HostName,MyClient, 'Turtlebot'); 
    xn = post(1)/1000;
    yn = post(2)/1000;
    thetan = Rotat(3);
    
    Dx =  xn - x;
    Dy =  yn - y;
    Dth = thetan - theta;
    Vx = Dx/dt;
    Vy = Dy/dt;
    Vth = Dth/dt;

    Pos = [Pos; x y];
    Vel = [Vel; Vx Vy];
    i = i+1;
    grid on;
    plot(x,y,'-db'); hold on
    pause(0.008)
    
    dx = (xn- waypoints(1));
    dy = (yn - waypoints(2));
    dth = thetan - 0
    
%               pos_x = Xpos0;
%             pos_y = Ypos0;
%             errx = Target(tp,1) - pos_x;
%             erry = Target(tp,2) - pos_y;
            
            Inert=[dx;dy];
%             R_b =  Tmatrix;
            R_b=[cos(Rotat(3)),sin(Rotat(3)); -sin(Rotat(3)),cos(Rotat(3))];
            err_b=R_b*Inert;
    
    %As dx or dy get smaller, so does 
    Velx = Kx*err_b(1);
    Vely = Ky*err_b(2);
    Velth = Kth * dth;
    
    A = atan2(Vely,Velx);
%     Angz = sind(theta + A*dt);
    Angz =Velth;
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
