% We evaluate the target function.

function [ ret, ctime, rtime, acc ] = target_MobileTF(params, noise)
    global is_fx id home_dir phone_dir

    disp('Evaluating Target Function');
    
    numepochs = params.numepochs;
    batchsize = params.batchsize;
    learningrate = params.learningrate;
    momentum = params.momentum;
    weightdecay = params.weightdecay;

    res_dir = [home_dir '/MFPES/res'];
    mkdir(res_dir, id);     %res_dir/id/ is the directory storing all the results from the android app for this run

    iter = 1;   % Determine from results folder 

    if (is_fx)
        cmd_install= [home_dir '/MyApplication/gradlew installDebug'];
    else
        cmd_install= ['cd ' home_dir '/MyApplication & ' home_dir '/MyApplication/gradlew installDebug'];
    end

    [status,cmdout] = system(cmd_install);

    if status == 0
        if (is_fx)
            cmd_adb='/Users/HFX/adb-fastboot/platform-tools/adb';
        else
            cmd_adb='adb';
        end

        cmd_run=[cmd_adb ' shell am start -n com.example.myapplication/com.example.myapplication.MainActivity'];
        cmd_run = [cmd_run ' --ei numepochs ' num2str(numepochs)];
        cmd_run = [cmd_run ' --ei batchsize ' num2str(batchsize)];
        cmd_run = [cmd_run ' --ef learningrate ' num2str(learningrate)];
        cmd_run = [cmd_run ' --ef momentum ' num2str(momentum)];
        cmd_run = [cmd_run ' --ef weightdecay ' num2str(weightdecay)];
        cmd_run = [cmd_run ' --ei iter ' num2str(iter)];
        cmd_run = [cmd_run ' --es id ' id];

        [status,cmdout] = system(cmd_run)

        cmd_pull = [cmd_adb ' pull ' ...
            phone_dir '/' id '/iter_' num2str(iter) '_results.csv ' ...
            res_dir '/' id '/iter_' num2str(iter) '_results.csv'];

        % Poll every few seconds until app finishes running 
        while(true) 
            pause(5);
            [pull_status, ~] = system(cmd_pull);
            if (pull_status == 0)
                [num, text, raw] = xlsread([res_dir '/' id '/iter_' num2str(iter) '_results.csv']);
                ctime = num(1);
                rtime = num(2);
                acc = num(3);
                break;
            end
        end
    end

    %threshold to be set accordingly later
    if acc < 0.75
        penalty = 1;
    else
        penalty = acc;
    end
    
    ret = ctime/penalty + noise; 
end

