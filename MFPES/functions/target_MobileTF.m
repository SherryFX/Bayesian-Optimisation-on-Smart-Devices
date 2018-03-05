% We evaluate the target function.

function [ ret ] = target_MobileTF(xx, noise)

% cd /Users/HFX/adb-fastboot/platform-tools;
% cmd_devices = '/Users/HFX/adb-fastboot/platform-tools/adb devices';

% cd '/Users/HFX/Desktop/Bayesian\ Optimization\ on\ Smart\ Devices/MyApplication';
cmd_install= '/Users/HFX/Desktop/Bayesian\ Optimization\ on\ Smart\ Devices/MyApplication/gradlew installDebug';

[status,cmdout] = system(cmd_install);

if status == 0
    cmd_run='/Users/HFX/adb-fastboot/platform-tools/adb shell am start -n com.example.myapplication/com.example.myapplication.MainActivity';
    [status,cmdout] = system(cmd_run);
end

% process cmdout
cmdout


end

