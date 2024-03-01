function states = autocalibrationVelocity(acceleration,Fs)
% acceleration should be normalized to unit of g, Fs unit is sps.
% Implementation of Veltink, IEEE, 2004
% Zifang Zhao, 01/2024

% Modelling: Eq1. yt=at-gt+bt+va_t: sensor data = acc + gravity + offset + noise

% Pre-definitions
dt = 1/Fs;

% can we model this problem by combining two kalman filters? one tracking
% gravity, one tracking acceleration

bias = 0;
angle = 0;

angle = [0,1,0]; %Angle vector
W = [0,0.1,0]; %angular velocity
Y = [0,0,0]; % reading from accelerometer
% Sa = acceleration(:,1); %device acc (in device axis)
Sa = [0.5,0.2,0]; %device acc (in device axis)
Sg = [0,1,0]; %gravity acc (in device axis)
Ga = [0,0,0]; %device acc (global axis)
Gg = [0,0,0]; %gravity acc (global axis)

Sa_ = [0,0,0]; %Corrected device acc (in device axis)
Sg_ = [0,0,0]; %Corrected gravity acc (in device axis)
Ga_ = [0,0,0]; %Corrected device acc (global axis)
Gg_ = [0,0,0]; %Corrected gravity acc (global axis)

X = [Sa; Sg; W]; %State Varibles
% A = [0] % State Transition Matrix
P = ones(3); %initial Covariance matrix
% YE ;%Error
% Q ; %Noise covariance matrix
R = 0.1; %Process Noise matrix

states = zeros(length(Sa)+length(Sg)+length(W),size(acceleration,2));
% state update
h_vnorm = @(v) v./norm(v,2);
for idx=1:size(acceleration,2)
    % Prediction
%     X = A*X;
%     P = A*P*A'+Q;
    % Measurement update
    H = [1,1,0]; % Observation matrix,  relates the state variables to the measurements
    y = acceleration(:,idx)'- H * X; % Error between(measurement and model)= measured - Estimated from state
    S = H*P*H' + R;
    K = (P*H')/S; %Kalman gain
%     X = X + K*y; %State update
    P = (eye(size(P))-K*H) * P; %Covariance Update

    % update states
    
    % Acceleration update
%     Sa = X(1,:);
    % angular velocity update
    
    %LPF to reduce error
    Sa = X(1,:);
    % gravity rescale to 1: Eq4: sg = g_c * sg_(t-1)
    Sg = h_vnorm(X(2,:));
    W = X(3,:);
    % axis rotation: Eq5: s=s_ -Tw * S_
    Sa_new = Sa-cross(dt*W,Sa);
    Sg_new = Sg-cross(dt*W,Sg);
    
    W_new = cross(h_vnorm(Sa_new),h_vnorm(Sa))./dt;
%     Sa=Sa_new; %replace sensor data temp
    X_est = [Sa_new;Sg_new;W_new];
    X = X_est + K*y;
    states(:,idx)=X;
end

