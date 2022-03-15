
package com.example.almaviva_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle

import com.example.almaviva_app.DWUtilities.getConfig

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject


class MainActivity: FlutterActivity() {

    private val COMMAND_CHANNEL = "com.compunet.almaviva/command";
    private val SCAN_CHANNEL = "com.compunet.almaviva/scan";
    private val PROFILE_INTENT_ACTION = "com.compunet.almaviva.SCAN";
    private val PROFILE_INTENT_BROADCAST = "2";

//    private val dwInterface = DWInterface()

    //MultiBarcodes
    private val dwUtils = DWUtilities
    var m_bUiInitialised = false
    var m_bReportInstantly = false



    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {


        m_bUiInitialised = false
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        EventChannel(flutterEngine.dartExecutor, SCAN_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var dataWedgeBroadcastReceiver: BroadcastReceiver? = null
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    dataWedgeBroadcastReceiver = createDataWedgeBroadcastReceiver(events)
                    val intentFilter = IntentFilter()
                    intentFilter.addAction(dwUtils.ACTION_RESULT_DATAWEDGE)
                    intentFilter.addCategory(Intent.CATEGORY_DEFAULT)
                    intentFilter.addAction(dwUtils.PROFILE_INTENT_ACTION)


                    registerReceiver(
                        dataWedgeBroadcastReceiver, intentFilter)
                    DWUtilities.getDWVersion(applicationContext)
                }

                override fun onCancel(arguments: Any?) {
                    unregisterReceiver(dataWedgeBroadcastReceiver)
                    dataWedgeBroadcastReceiver = null
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor, COMMAND_CHANNEL).setMethodCallHandler { call, result ->
           if (call.method == "createDataWedgeProfile")
            {
                createDataWedgeProfile(call.arguments.toString())
            }
            else {
                result.notImplemented()
            }
        }

    }


    private fun createDataWedgeProfile(profileName: String) {
        dwUtils.createProfile(context);
    }
    private fun createDataWedgeBroadcastReceiver(events: EventChannel.EventSink?): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action.equals(PROFILE_INTENT_ACTION))
                {


                    events?.success(displayScanResult(intent));
                }else{
                    events?.error("0","no se logro emitir","algo ocurrio")
                }
                //  Could handle return values from DW here such as RETURN_GET_ACTIVE_PROFILE
                //  or RETURN_ENUMERATE_SCANNERS
            }
        }
    }

    private fun profileIsApplied() {
        if (!m_bUiInitialised) {
            m_bUiInitialised = true

            getConfig(applicationContext)
        }
    }

    private fun instantReportUpdate(){
        m_bReportInstantly = m_bReportInstantly != true
    }

    private fun displayScanResult(intent: Intent) : String {


        val decoded_mode = intent.getStringExtra("com.symbol.datawedge.decoded_mode")
        if (decoded_mode.equals("multiple_decode", ignoreCase = true)) {
            var barcodeBlock = ""
            val multiple_barcodes =
                intent.getSerializableExtra("com.symbol.datawedge.barcodes") as List<Bundle>?
            if (multiple_barcodes != null) {
                //output += "Multi Barcode count: " + multiple_barcodes.size() + '\n';
                for (i in multiple_barcodes.indices) {
                    val thisBarcode = multiple_barcodes[i]
                    val barcodeData = thisBarcode.getString("com.symbol.datawedge.data_string")
                    val symbology = thisBarcode.getString("com.symbol.datawedge.label_type")
                    barcodeBlock += "Barcode: $barcodeData [$symbology]"
                    if (multiple_barcodes.size != 1) barcodeBlock += "\n"
                }
            }
            return barcodeBlock;
        }
        return "Barcode: " + decoded_mode;
    }


    private fun getAndroidVersion() : String {
        var sdkVersion:Int= Build.VERSION.SDK_INT;
        var release : String = Build.VERSION.RELEASE;
        return "Android Versión: " + sdkVersion + "("+ release + ")";

    }

}