load_settings;

numepochs = [20 50 75 86 100];
batchsize = [50 128 256 512];
learningrate = [0.00001 0.0001 0.001];
momentum = [0 0.5 0.9 1];
weightdecay = [0.00001, 0.0001, 0.001];
res_file = [ home_dir '/MFPES/res/auxiliary_res.xlsx' ];
header = {'numepochs', 'batchsize', 'learningrate', 'momentum', 'weightdecay', 'cputime', 'realtime', 'acc'};
xlswrite(res_file, header);
row = 2;
for ne = numepochs
    for bs = batchsize
        for lr = learningrate
            for mm = momentum
                for wd = weightdecay
                    params.numepochs = ne;
                    params.batchsize = bs;
                    params.learningrate = lr;
                    params.momentum = mm;
                    params.weightdecay = wd;
                    
                    [ret, ctime, rtime, acc] = auxiliary_MobileTF(0,0,params);
                    A = {ne, bs, lr, mm, wd, ctime, rtime acc};
                    xlswrite(res_file, A, ['A' row ':G' row]);
                    row = row + 1;
                end
            end
        end
    end
end

