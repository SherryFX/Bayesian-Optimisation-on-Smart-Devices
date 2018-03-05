package com.example.myapplication;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Debug;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.view.View;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ScrollView;
import android.widget.TextView;

import com.transferCL.TransferCLlib;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    TransferCLlib t;

    final int PHONE_TYPE = 1;
    String id;                          // Unique id identifying experiment setup

    String applicationName;
    String appDirectory;
    String storageDirectory;
    String resultsFile;
    File resFile;
    String resDir= Environment.getExternalStoragePublicDirectory(
            Environment.DIRECTORY_DOCUMENTS).toString() + "/MyApplication";

    String fileNameStoreData;           // Storage location for training data after preparation
    String fileNameStoreLabel;          // Storage location for training labels after preparation
    String fileNameStoreNormalization;  // Storage location for normalisation layer after preparation
    String trainManifest;
    String trainManifest2;               // Manifest file for training data and labels

    String storeweightsfile;            // Storage location for new weights after training
    String loadweightsfile;
    String loadweightsfile2;             // Storage location for weights of pre-trained model

    String predInputFile;
    String predInputFile2;               // Manifest file for test data and labels
    String predOutputFile;              // Output file for predictions

    // NN properties
    int nbTrainingImages = 50000;
    int nbChannels = 1;                 // Black and white => 1; color =>3
    int imageSize=28;
    String netdef ="1s8c5z-relu-mp2-1s16c5z-relu-mp3-150n-tanh-10n";  // NOT of pretrained model but of current model
    // String netdef="1s8c5z-relu-mp2-1s16c5z-relu-mp3-152n-tanh-10n";// see https://github.com/hughperkins/DeepCL/blob/master/doc/Commandline.md
    // String netdef="1s8c1z-relu-mp2-1s16c1z-relu-mp3-150n-tanh-101n";
    int numepochs=100;                   // [20, *100,500, 1000]
    int batchsize=256;                  // [64, 128, *256, 512]
    float learningRate=0.001f;          // [0.00001, 0.0001, *0.001, 0.01, 0.1]
    float momentum=0.1f;                // default: 0.0f, [0, 1]
    float weightdecay=0.0001f;             // default: 0.0f

    TextView tv;
    ScrollView logContainer;

    // Storage Permissions
    private static final int REQUEST_EXTERNAL_STORAGE = 1;
    private static String[] PERMISSIONS_STORAGE = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        t=new TransferCLlib();

        Log.d("Is storage available: ", String.valueOf(isExternalStorageWritable())); // test

        // Setup files
        applicationName = getApplicationContext().getPackageName();
        appDirectory = "/data/data/"+applicationName+"/";
        storageDirectory = (PHONE_TYPE == 2) ? "/storage/6234-3231/Data/" : "/storage/AEE2-2820/Data/";

        fileNameStoreData= appDirectory + "directoryTest/mem2Character2ManifestMapFileData2.raw";
        fileNameStoreLabel= appDirectory + "directoryTest/mem2Character2ManifestMapFileLabel2.raw";
        fileNameStoreNormalization= appDirectory + "directoryTest/normalizationTransfer.txt";

        trainManifest = "mnist/imgs/trainmanifest10.txt";
        trainManifest2 = storageDirectory + trainManifest;

        storeweightsfile= appDirectory + "directoryTest/weightsTransferred.dat";
        loadweightsfile = "EMNIST/letters_imgs/weights26.dat";
        loadweightsfile2 = storageDirectory + loadweightsfile;     // Trained task/domain weights

        predInputFile = "mnist/val_imgs/valmanifest10.txt";
        predInputFile2 =  storageDirectory + predInputFile;
        predOutputFile = "/storage/emulated/0/Android/data/com.example.myapplication/files/pred.txt";

        id = createId();

        initialiseResultsFile();


//        Log.d("Test", "onCreate: " + getApplicationContext().getApplicationInfo().dataDir); // test
//        Log.d("Test", "onCreate: " + getExternalFilesDir(null)); // test
//        Log.d("Test", "onCreate: " + applicationName); // test

        verifyStoragePermissions(this);
        try {
            Process process = Runtime.getRuntime().exec("logcat -c"); // we clear the logcat
        } catch (IOException e) {
            e.printStackTrace();
        }
        //////////////////

        tv = (TextView)findViewById(R.id.textView4);
        tv = (TextView)findViewById(R.id.textView4);
        logContainer = (ScrollView)findViewById(R.id.SCROLLER_ID);


        new AsyncTask<Void, String, Void>() {

            @Override
            protected Void doInBackground(Void... params) {
                try {
                    Process process = Runtime.getRuntime().exec("logcat ActivityManager:I TransferCL:D *:S");
                    BufferedReader bufferedReader = new BufferedReader(
                            new InputStreamReader(process.getInputStream()));

                    String line = "";
                    while ((line = bufferedReader.readLine()) != null) {
                        line=line+"\n";
                        if (line.contains(":"))
                            line=line.substring(line.indexOf(":")+1);
                        publishProgress(line);
                    }
                }
                catch (IOException e) {
                }
                return null;
            }

            @Override
            protected void onProgressUpdate(String... values) {
                tv.append(values[0] + "\n");
                logContainer.post(new Runnable() {
                    @Override
                    public void run() {
                        logContainer.fullScroll(View.FOCUS_DOWN);
                    }
                });
            }
        }/*.execute()*/;

        /**
         * Run experiment
         */

        runExperiment();
    }

    private Runnable createPreparationRunnable() {
        Runnable runnable = new Runnable() {
            public void run() {
                t.prepareFiles(
                        "/data/data/"+applicationName+"/",
                        fileNameStoreData,
                        fileNameStoreLabel,
                        fileNameStoreNormalization,
                        trainManifest2,       // new task/domain info
                        nbTrainingImages,
                        nbChannels);


                Log.d("Run exp", "Preparation done for id " + id);
            }
        };

        return runnable;
    }

    private Runnable createTrainingRunnable() {
        Runnable runnable = new Runnable() {
            public void run() {
                String cmdString="train filename_label="+fileNameStoreLabel;
                cmdString=cmdString+" filename_data="+fileNameStoreData;
                cmdString=cmdString+" imageSize="+Integer.toString(imageSize);
                cmdString=cmdString+" numPlanes="+Integer.toString(nbChannels);
                cmdString=cmdString+" storeweightsfile="+storeweightsfile;
                cmdString=cmdString+" loadweightsfile="+ loadweightsfile2;
                cmdString=cmdString+" loadnormalizationfile="+fileNameStoreNormalization;
                cmdString=cmdString+" netdef="+ netdef;
                cmdString=cmdString+" numepochs="+Integer.toString(numepochs);
                cmdString=cmdString+" batchsize="+Integer.toString(batchsize);
                cmdString=cmdString+" numtrain="+Integer.toString(nbTrainingImages);
                cmdString=cmdString+" learningrate="+Float.toString(learningRate);
                cmdString = cmdString + " momentum=" + Float.toString(momentum);
                cmdString = cmdString + " weightdecay=" + Float.toString(weightdecay);

                long start = Debug.threadCpuTimeNanos();
                long start_real = System.nanoTime();
                t.training(appDirectory,cmdString);

                long elapsed = Debug.threadCpuTimeNanos() - start;
                long elapsed_real= System.nanoTime() - start_real;
                Log.d("CPU time for training: ", String.valueOf(elapsed)); // test
                Log.d("Realtime for training: ", String.valueOf(elapsed_real)); // test

                writeTrainResults(String.valueOf(elapsed), String.valueOf(elapsed_real));

                Log.d("Run exp", "Training done for id " + id);
            }
        };

        return runnable;
    }

    private Runnable createPredictRunnable() {
        Runnable runnable = new Runnable() {
            public void run() {
                String cmdString ="./predict weightsfile="
                        + storeweightsfile
                        +"  inputfile="
                        + predInputFile2 // New task/domain
                        +"  outputfile="
                        + predOutputFile;
//                        +"  outputfile=/storage/6234-3231/Data/pred.txt";
//                        +" outputfile=/data/data/"
//                        +applicationName
//                        +"/preloadingData/pred2.txt";
                t.prediction(appDirectory,cmdString);

                writePredResults();

                Log.d("Run exp", "Prediction done for id " + id);
            }
        };

        return runnable;
    }
    public void prepareTrainingFiles(View v) {
        //this method prepares the training files (the training file and their labels are respectively stored in one binary file) and the mean And stdDev are stored in one file
        Runnable runnable = createPreparationRunnable();
        Thread mythread = new Thread(runnable);
        mythread.start();
    }

    public void trainingModel(View v) {
        // this method trains our neural network at the native level
        Runnable runnable = createTrainingRunnable();
        Thread mythread = new Thread(runnable);
        mythread.start();
    }

    public void predictImages(View v) {
        // this method performs the prediction and sore the result in a file
        Runnable runnable = createPredictRunnable();
        Thread mythread = new Thread(runnable);
        mythread.start();
    }

    public class ExperimentRunnable implements Runnable {
        public void run()
        {
            Runnable r1 = createPreparationRunnable();
            Runnable r2 = createTrainingRunnable();
            Runnable r3 = createPredictRunnable();
            r1.run();
            r2.run();
            r3.run();
        }
    }

    public void runExperiment() {
        Runnable runnable = new ExperimentRunnable();
        new Thread(runnable).start();
    }

    @Override
    public void onClick(View v) {}
    /**
     * Checks if the app has permission to write to device storage
     *
     * If the app does not has permission then the user will be prompted to grant permissions
     *
     * @param activity
     */
    public static void verifyStoragePermissions(Activity activity) {
        if (Build.VERSION.SDK_INT >= 23) {
            if (ActivityCompat.checkSelfPermission(activity, Manifest.permission.READ_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED) {
                Log.v("Permissions", "Read permission is granted");
            } else {
                Log.v("Permissions", "Read permission is revoked");
                ActivityCompat.requestPermissions(activity,
                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                        REQUEST_EXTERNAL_STORAGE);
            }
            if (ActivityCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED) {
                Log.v("Permissions", "Write permission is granted");
            } else {
                Log.v("Permissions", "Write permission is revoked");
                ActivityCompat.requestPermissions(activity,
                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                        REQUEST_EXTERNAL_STORAGE);
            }
        } else {
            //permission is automatically granted on sdk<23 upon installation
            Log.v("Permissions","Permissions are granted");
        }
    }

    private void writeTrainResults(String elapsed, String elapsed_real) {
        FileWriter out = null;
        try {
            out = new FileWriter(resFile, true);
            out.write("************\n");
            out.write("* Training * \n");
            out.write("************\n");
            out.write("Elapsed CPU time: " + elapsed + "\n");
            out.write("Elapsed Real time: " + elapsed_real + "\n");

            out.write("\n");
            out.close();
        } catch (IOException e) {
            Log.e("Writing", "File not found");
        }
    }

    private void writeGeneral() {
        FileWriter out = null;
        try {
            out = new FileWriter(resFile,true);
            out.write("****************\n");
            out.write("* General Info * \n");
            out.write("****************\n");
            out.write("netdef: " + netdef + "\n");
            out.write("numEpochs: " + numepochs + "\n");
            out.write("batchSize: " + batchsize+ "\n");
            out.write("learningRate: " + learningRate + "\n");
            out.write("momentum: " + momentum+ "\n");
            out.write("weightdecay: " + weightdecay + "\n");
            out.write("nbTrainingImages: " + nbTrainingImages+ "\n");
            out.write("trainManifest: " + trainManifest + "\n");
        //    out.write("predInputFile: " + predInputFile+ "\n");
            out.write("weightsFile: " + loadweightsfile + "\n");
            out.write("\n");

            out.close();
        } catch (IOException e) {
            Log.e("Writing", "File not found");
        }
    }

    private void writePredResults() {
        FileWriter out = null;
        try {
            out = new FileWriter(resFile, true);
            out.write("**************\n");
            out.write("* Prediction *\n");
            out.write("**************\n");
            out.write("Accuracy: " + calculateAccuracy() + "\n");

            out.write("\n");
            out.close();
        } catch (IOException e) {
            Log.e("Writing", "File not found");
        }
    }
    private void initialiseResultsFile() {
        resultsFile = "res_" + id + ".txt";
        new File(resDir).mkdirs();
        resFile = new File(resDir, resultsFile);
        try {
            if (!resFile.exists()) {
                Log.d("initialiseResultsFile", "File does not exist");
                resFile.createNewFile();
                writeGeneral();
            } else {
                Log.d("initialiseResultsFile", "File already exists");
            }
        } catch (IOException e) {
            Log.e("initialiseResultsFile", e.toString());
        }
    }

    private boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        }
        return false;
    }

    private String createId() {
        String fullDef = netdef+numepochs+batchsize+learningRate+momentum+weightdecay+nbTrainingImages+trainManifest+loadweightsfile;
        return String.valueOf(longHash(fullDef));
    }

    private static long longHash(String string) {
        long h = 98764321261L;
        int l = string.length();
        char[] chars = string.toCharArray();

        for (int i = 0; i < l; i++) {
            h = 31*h + chars[i];
        }
        return h;
    }

    private float calculateAccuracy() {
        File input = new File(predInputFile2);
        File output = new File(predOutputFile);
        BufferedReader inReader = null;
        BufferedReader outReader = null;
        int N = 0;
        int nCorrect = 0;
        try {
            inReader = new BufferedReader(new FileReader(input));
            outReader = new BufferedReader(new FileReader(output));
        } catch (IOException e) {
            Log.e("calculateAccuracy", e.toString());
        }
        try {
            inReader.readLine();        // Read format
            String inLine = ""; String outLine = "";
            while ((inLine = inReader.readLine()) != null) {
                outLine = outReader.readLine();
                if (outLine == null) {
                    Log.e("calculateAccuracy read", "Mismatch!");
                    return -1;
                }
                String[] split = inLine.split("\\s+");
                int trueVal = Integer.valueOf(split[split.length - 1]);
                int predVal = Integer.valueOf(outLine);

                if (trueVal == predVal) {
                    nCorrect++;
                }
                N++;
            }

            if ((outLine = outReader.readLine()) != null) {
                Log.e("calculateAccuracy read", "Mismatch!");
                return -1;
            }


        } catch (IOException e) {
            Log.e("calculateAccuracy read", e.toString());
        }
        return ((float) nCorrect) / N;
    }

}