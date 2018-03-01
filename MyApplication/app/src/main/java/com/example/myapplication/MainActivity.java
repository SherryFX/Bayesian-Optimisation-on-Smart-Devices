package com.example.myapplication;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Debug;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.view.View;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.ScrollView;
import android.widget.TextView;

import com.transferCL.TransferCLlib;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    TransferCLlib t;

    String applicationName;
    String appDirctory;
    String fileNameStoreData;           // Storage location for training data after preparation
    String fileNameStoreLabel;          // Storage location for training labels after preparation
    String fileNameStoreNormalization;  // Storage location for normalisation layer after preparation
    String trainManifest;               // Manifest file for training data and labels

    String storeweightsfile;            // Storage location for new weights after training
    String loadweightsfile;             // Storage location for weights of pre-trained model

    String predInputFile;               // Manifest file for test data and labels
    String predOutputFile;              // Output file for predictions

    // NN properties
    int nbTrainingImages = 50000;
    int nbChannels = 1;                 // Black and white => 1; color =>3
    int imageSize=28;
    String netdef ="1s8c5z-relu-mp2-1s16c5z-relu-mp3-150n-tanh-10n";
    // String netdef="1s8c5z-relu-mp2-1s16c5z-relu-mp3-152n-tanh-10n";// see https://github.com/hughperkins/DeepCL/blob/master/doc/Commandline.md
    // String netdef="1s8c1z-relu-mp2-1s16c1z-relu-mp3-150n-tanh-101n";
    int numepochs=20;
    int batchsize=128;
    float learningRate=0.002f;

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


        applicationName = getApplicationContext().getPackageName();
        appDirctory ="/data/data/"+applicationName+"/";

        fileNameStoreData="/data/data/"+applicationName+"/directoryTest/mem2Character2ManifestMapFileData2.raw";
        fileNameStoreLabel= "/data/data/"+applicationName+"/directoryTest/mem2Character2ManifestMapFileLabel2.raw";
        fileNameStoreNormalization="/data/data/"+applicationName+"/directoryTest/normalizationTransfer.txt";

        // Phone 1: /storage/6234-3231/; Phone 2: /storage/AEE2-2820/

        trainManifest = "/storage/6234-3231/Data/mnist/imgs/trainmanifest10.txt";

        storeweightsfile="/data/data/"+applicationName+"/directoryTest/weightsTransferred.dat";
        loadweightsfile="/storage/AEE2-2820/Data/mnist/weights10.dat";     // Trained task/domain weights

        predInputFile = "/storage/6234-3231/Data/mnist/imgs/trainmanifest10small.txt";
        predOutputFile = "/storage/emulated/0/Android/data/com.example.myapplication/files/pred.txt";


        tv = (TextView)findViewById(R.id.textView4);

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
    }

    public void prepareTrainingFiles(View v) {
        //this method prepares the training files (the training file and their labels are respectively stored in one binary file) and the mean And stdDev are stored in one file

        Runnable runnable = new Runnable() {
            public void run() {
                t.prepareFiles(
                        "/data/data/"+applicationName+"/",
                        fileNameStoreData,
                        fileNameStoreLabel,
                        fileNameStoreNormalization,
                        trainManifest,       // new task/domain info
                        nbTrainingImages,
                        nbChannels);
            }
        };
        Thread mythread = new Thread(runnable);
        mythread.start();



    }

    public void trainingModel(View v) {
        // this method trains our neural network at the native level

        Runnable runnable = new Runnable() {
            public void run() {
                String cmdString="train filename_label="+fileNameStoreLabel;
                cmdString=cmdString+" filename_data="+fileNameStoreData;
                cmdString=cmdString+" imageSize="+Integer.toString(imageSize);
                cmdString=cmdString+" numPlanes="+Integer.toString(nbChannels);
                cmdString=cmdString+" storeweightsfile="+storeweightsfile;
                cmdString=cmdString+" loadweightsfile="+loadweightsfile;
                cmdString=cmdString+" loadnormalizationfile="+fileNameStoreNormalization;
                cmdString=cmdString+" netdef="+ netdef;
                cmdString=cmdString+" numepochs="+Integer.toString(numepochs);
                cmdString=cmdString+" batchsize="+Integer.toString(batchsize);
                cmdString=cmdString+" numtrain="+Integer.toString(nbTrainingImages);
                cmdString=cmdString+" learningrate="+Float.toString(learningRate);

                long start = Debug.threadCpuTimeNanos();

                t.training(appDirctory,cmdString);

                long elapsed = Debug.threadCpuTimeNanos() - start;
                Log.d("CPU time for training: ", String.valueOf(elapsed)); // test
            }
        };
        Thread mythread = new Thread(runnable);
        mythread.start();


    }

    public void predictImages(View v) {
        // this method performs the prediction and sore the result in a file

        Runnable runnable = new Runnable() {
            public void run() {
                String cmdString ="./predict weightsfile="
                        + storeweightsfile
                        +"  inputfile="
                        + predInputFile // New task/domain
                        +"  outputfile="
                        + predOutputFile;
//                        +"  outputfile=/storage/6234-3231/Data/pred.txt";
//                        +" outputfile=/data/data/"
//                        +applicationName
//                        +"/preloadingData/pred2.txt";
                t.prediction(appDirctory,cmdString);

            }
        };
        Thread mythread = new Thread(runnable);
        mythread.start();

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
}