rosshutdown
ipaddress = '192.168.1.3';
rosinit(ipaddress);

velocity = 0.1; %set velocity

%Create publisher
robot = rospublisher('mobile_base/commands/velocity');
velmsg = rosmessage(robot);

%Set the forward motion
velmsg.Linear.X = velocity;

