load_settings;

numepochs = [20 50 75 86 100];
batchsize = [50 128 256 512];
learningrate = [0.00001 0.0001 0.001];
momentum = [0 0.5 0.9 1];
weightdecay = [0.00001, 0.0001, 0.001];
res_file = [ home_dir '/MFPES/res/auxiliary_res_reruns.xlsx' ];
header = {'numepochs', 'batchsize', 'learningrate', 'momentum', 'weightdecay', 'cputime', 'realtime', 'acc','index'};
xlswrite(res_file, header);
vals = zeros(length(numepochs) * length(batchsize) * length(learningrate) * length(momentum) * length(weightdecay), 8);
i = 1;
for ne = numepochs
    for bs = batchsize
        for lr = learningrate
            for mm = momentum
                for wd = weightdecay
                    vals(i,1) = ne;
                    vals(i,2) = bs;
                    vals(i,3) = lr;
                    vals(i,4) = mm;
                    vals(i,5) = wd;
                    i = i+1;
                end
            end
        end
    end
end
[l,w] = size(vals);

reruns = [ 23 24 35 36 72 107 108 167 168 179 180 202 204 215 216 251 252 288 300 311 312 322 323 324 348 359 360 395 396 432 444 455 456 466 467 468 491 492 502 503 504 538 539 540 576 588 598 599 600 610 611 612 635 636 646 647 648 672 682 683 684 718 719 720 34 95 154 310 442 624 634 658 671 708 59 132 454 514 22 70 190 203 346 372 382 443 463 562 659 12 47 94 106 226 240 336 527 46 130 155 166 227 276 526 586 131 143 192 250 298 371 383 384 418 515 516 587 670 60 239 275 334 358 431 479 623 48 71 228 274 420 480 528 660 706 96 178 238 299 335 490 695 10 11 58 142 144 156 175 176 191 214 286 287 319 320 347 370 394 419 430 464 478 563 564 574 575 607 608 622 707 694 550 551];
row = 175;
for i = 174:length(reruns)
    pack;
    params.numepochs = vals(i,1);
    params.batchsize = vals(i,2);
    params.learningrate = vals(i,3);
    params.momentum = vals(i,4);
    params.weightdecay = vals(i,5);

    [ret, ctime, rtime, acc] = auxiliary_MobileTF(0,0,params);
    A = {params.numepochs, params.batchsize, params.learningrate, params.momentum, params.weightdecay, ctime, rtime, acc, i};
    xlswrite(res_file, A, ['A' num2str(row) ':I' num2str(row)]);
    row = row + 1;
end

