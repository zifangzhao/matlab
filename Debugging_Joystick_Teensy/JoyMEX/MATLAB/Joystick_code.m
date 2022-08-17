function Joystick_code
running = 1;
addpath('./JoyMEX/');
addpath('./JoyMEX/MATLAB/');
JoyMEX('init',1);

% Create figure and attach close function
figure('CloseRequestFcn',@onClose);
% Create plots
subplot(2,1,1)
p4=plot([0],[0],'mo','MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10); hold on;
p5=plot([0],[0],'+r');
title(sprintf('Device 1\nAxis'))
set(gca,'xlim',[-1 1],'ylim',[-1 1]); axis square

subplot(2,1,2)
b2=bar(zeros(1,100));
title('Button States')
set(gca,'xlim',[0 12],'ylim',[0 1]); axis square

while(running)
    [b,bb] = JoyMEX(1);
    button =find(double(bb))
    stick = b
    set(p4,'Xdata',b(1),'Ydata',-b(2));
    set(b2,'Ydata',double(bb));
    drawnow;
    
end

clear JoyMEX

    function onClose(src,evt)
        % When user tries to close the figure, end the while loop and
        % dispose of the figure
        running = 0;
        delete(src);
    end
end