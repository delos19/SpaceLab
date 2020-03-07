% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Copyright (C) Ahmad Bani Younes 2016
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     **  This code returns position and orientation for the object
%                         July 12th, 2016  
%========================================================================== 
% clear; clc;
function [Post, Rotat, Tmatrix] =  ABY_Get_Measurements_mod1(HostName,MyClient, SubjectName)
% A dialog to stop the loop
% MessageBox = msgbox( 'Stop DataStream Client', 'Vicon DataStream SDK' );
% Load the SDK
% fprintf( 'Loading SDK...' );
% Client.LoadViconDataStreamSDK();
% fprintf( 'done\n' );
% % Program options
% HostName = 'localhost:801';
% % Make a new client
% MyClient = Client();
% % Connect to a server
% fprintf( 'Connecting to %s ...', HostName );
while ~MyClient.IsConnected().Connected; MyClient.Connect( HostName );  fprintf( '.' );end
fprintf( '\n' );
% Enable some different data types
MyClient.EnableSegmentData();MyClient.EnableMarkerData();MyClient.EnableUnlabeledMarkerData();MyClient.EnableDeviceData();
% Set the streaming mode
MyClient.SetStreamMode( StreamMode.ClientPull );
% Set the global up axis
MyClient.SetAxisMapping( Direction.Forward, Direction.Left, Direction.Up );    % Z-up
% Output_GetAxisMapping = MyClient.GetAxisMapping();
  MyClient.GetFrame().Result.Value;
  MyClient.GetFrame().Result.Value;
% Get the global segment translation
 Output_GetSegmentGlobalTranslation      = MyClient.GetSegmentGlobalTranslation( SubjectName, SubjectName );
 Output_GetSegmentGlobalRotationEulerXYZ = MyClient.GetSegmentGlobalRotationEulerXYZ( SubjectName, SubjectName );
 Output_GetSegmentGlobalRotationMatrix   = MyClient.GetSegmentGlobalRotationMatrix( SubjectName, SubjectName );

% % Disconnect and dispose
% MyClient.Disconnect();
% % Unload the SDK
% fprintf( 'Unloading SDK...' );
% Client.UnloadViconDataStreamSDK();
% fprintf( 'done\n' );
Post     =  Output_GetSegmentGlobalTranslation.Translation';
Rotat    =  Output_GetSegmentGlobalRotationEulerXYZ.Rotation';
Tmatrix  =  reshape(Output_GetSegmentGlobalRotationMatrix.Rotation,3,3)  ;


