package com.example.myapplication;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
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
        }.execute();



    }

    public void prepareTrainingFiles(View v) {
        //this method prepares the training files (the training file and their labels are respectively stored in one binary file) and the mean And stdDev are stored in one file

        Runnable runnable = new Runnable() {
            public void run() {

                String fileNameStoreData="/data/data/"+applicationName+"/directoryTest/mem2Character2ManifestMapFileData2.raw";
                String fileNameStoreLabel= "/data/data/"+applicationName+"/directoryTest/mem2Character2ManifestMapFileLabel2.raw";
                String fileNameStoreNormalization="/data/data/"+applicationName+"/directoryTest/normalizationTransfer.txt";

                t.prepareFiles(
                        "/data/data/"+applicationName+"/",
                        fileNameStoreData,
                        fileNameStoreLabel,
                        fileNameStoreNormalization,
                        "/storage/6234-3231/Data/manifestSMALL.txt",
                        515,
                        3);

            }
        };
        Thread mythread = new Thread(runnable);
        mythread.start();



    }

    public void trainingModel(View v) {
        // this method trains our neural network at the native level

        Runnable runnable = new Runnable() {
            public void run() {


                String filename_label="/data/data/"+applicationName+"/directoryTest/mem2Character2ManifestMapFileLabel2.raw";
                String filename_data="/data/data/"+applicationName+"/directoryTest/mem2Character2ManifestMapFileData2.raw";
                int imageSize=28;
                int numOfChannel=3;//black and white => 1; color =>3
                String storeweightsfile="/data/data/"+applicationName+"/directoryTest/weightsTransferred.dat";
                String loadweightsfile="/storage/6234-3231/Data/weights4.dat";
                String loadnormalizationfile="/data/data/"+applicationName+"/directoryTest/normalizationTransfer.txt";
                // String networkDefinition="1s8c5z-relu-mp2-1s16c5z-relu-mp3-152n-tanh-10n";// see https://github.com/hughperkins/DeepCL/blob/master/doc/Commandline.md
                String networkDefinition="1s8c1z-relu-mp2-1s16c1z-relu-mp3-150n-tanh-101n";
                // String networkDefinition="8c5z-relu-mp2-16c5z-relu-mp3-150n-tanh-10n";
                int numepochs=100;
                int batchsize=128;
                int numtrain=515;
                float learningRate=0.01f;

                String cmdString="train filename_label="+filename_label;
                cmdString=cmdString+" filename_data="+filename_data;
                cmdString=cmdString+" imageSize="+Integer.toString(imageSize);
                cmdString=cmdString+" numPlanes="+Integer.toString(numOfChannel);
                cmdString=cmdString+" storeweightsfile="+storeweightsfile;
                cmdString=cmdString+" loadweightsfile="+loadweightsfile;
                cmdString=cmdString+" loadnormalizationfile="+loadnormalizationfile;
                cmdString=cmdString+" netdef="+networkDefinition;
                cmdString=cmdString+" numepochs="+Integer.toString(numepochs);
                cmdString=cmdString+" batchsize="+Integer.toString(batchsize);
                cmdString=cmdString+" numtrain="+Integer.toString(numtrain);
                cmdString=cmdString+" learningrate="+Float.toString(learningRate);

                String appDirctory ="/data/data/"+applicationName+"/";

                t.training(appDirctory,cmdString);
            }
        };
        Thread mythread = new Thread(runnable);
        Log.d("Thread ID: ", String.valueOf(mythread.getId())); // test
        mythread.start();


    }

    public void predictImages(View v) {
        // this method performs the prediction and sore the result in a file

        Runnable runnable = new Runnable() {
            public void run() {
                String appDirctory ="/data/data/"+applicationName+"/";
                String cmdString ="./predict weightsfile=/data/data/"
                        +applicationName
                        +"/directoryTest/weightsTransferred.dat"
                        +"  inputfile=/storage/6234-3231/Data/manifestTEST.txt"
                        +"  outputfile=/storage/emulated/0/Android/data/com.example.myapplication/files/pred.txt";
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
