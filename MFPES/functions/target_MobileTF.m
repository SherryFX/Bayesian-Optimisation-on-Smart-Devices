% We evaluate the target function.

function [ ret ] = target_MobileTF(xx, noise)

cd /Users/HFX/adb-fastboot/platform-tools;
cmd_devices = './adb devices';

cd /Users/HFX/Desktop/Bayesian\ Optimization\ on\ Smart\ Devices/MyApplication;
cmd_build= './gradlew assembleDebug';
cmd_install= './gradlew installDebug';
cmd_run='/Users/HFX/adb-fastboot/platform-tools/adb shell am start -n com.example.myapplication/com.example.myapplication.MainActivity';

[status,cmdout] = system(command);

% process cmdout

end

