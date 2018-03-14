% We evaluate the target function.

function [ ret ] = target_MobileTF(xx, noise)

init;
numepochs = 100;
batchsize = 256;
learningrate = 0.0005;
momentum = 0.2;
weightdecay = 0.0002;

% cd /Users/HFX/adb-fastboot/platform-tools;
% cmd_devices = '/Users/HFX/adb-fastboot/platform-tools/adb devices';

% cd '/Users/HFX/Desktop/Bayesian\ Optimization\ on\ Smart\ Devices/MyApplication';
if (is_fx)
    cmd_install= '/Users/HFX/Desktop/Bayesian\ Optimization\ on\ Smart\ Devices/MyApplication/gradlew installDebug';
else
    cmd_install= 'cd C:\Users\leona\Downloads\Bayesian-Optimisation-on-Smart-Devices\MyApplication & C:\Users\leona\Downloads\Bayesian-Optimisation-on-Smart-Devices\MyApplication\gradlew installDebug';
end
      
[status,cmdout] = system(cmd_install)

if status == 0
    
    
    if (is_fx)
        cmd_run='/Users/HFX/adb-fastboot/platform-tools/adb shell am start -n com.example.myapplication/com.example.myapplication.MainActivity';
    else
        cmd_run='adb shell am start -n com.example.myapplication/com.example.myapplication.MainActivity';
    end
    
    cmd_run = [cmd_run ' --ei numepochs ' num2str(numepochs)];
    cmd_run = [cmd_run ' --ei batchsize ' num2str(batchsize)];
    cmd_run = [cmd_run ' --ef learningrate ' num2str(learningrate)];
    cmd_run = [cmd_run ' --ef momentum ' num2str(momentum)];
    cmd_run = [cmd_run ' --ef weightdecay ' num2str(weightdecay)];
    
    cmd_run
    
    [status,cmdout] = system(cmd_run)
end

% process cmdout

% unique id
% polling  
end

