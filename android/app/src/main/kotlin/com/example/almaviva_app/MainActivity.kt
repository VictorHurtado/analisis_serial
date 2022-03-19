
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
            if (call.method == "sendDataWedgeCommandStringParameter")
            {
                val arguments = JSONObject(call.arguments.toString())
                val command: String = arguments.get("command") as String
                val parameter: String = arguments.get("parameter") as String
                dwUtils.sendCommandString(applicationContext, command, parameter)

            }else if (call.method == "setConfigDataWedge")
            {
                val arguments = JSONObject(call.arguments.toString())
                val numberOfCodes: Int = arguments.get("numberOfCodes") as Int
                val timerH: Int = arguments.get("timer") as Int
                val reportInstaly: Boolean = false
                val aim_type:Int = arguments.get("aim_type") as Int
                val beamWidth: Int = arguments.get("beamWidth") as Int
                //context: Context, numberOfBarcodesPerScan: Int, bReportInstantly: Boolean, timer : Int, Beam_Width:Int
                dwUtils.setConfig(applicationContext,numberOfBarcodesPerScan = numberOfCodes, timer = timerH, bReportInstantly = reportInstaly, Beam_Width = beamWidth, Aim_Type = aim_type)
                result.success(call.arguments.toString() + " Resultados de llamada " );
            }else if (call.method == "createDataWedgeProfile")
            {
                createDataWedgeProfile(call.arguments.toString())
            }else if(call.method == "version"){
                result.success(getAndroidVersion());
            }
            else {
                result.notImplemented()
            }
        }

    }


    private fun createDataWedgeProfile(profileName: String) {
        dwUtils.createProfile(context.applicationContext);
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
            var listOfCodes: ArrayList<String> = ArrayList<String>();
            val multiple_barcodes =
                intent.getSerializableExtra("com.symbol.datawedge.barcodes") as List<Bundle>?
            if (multiple_barcodes != null) {
                //output += "Multi Barcode count: " + multiple_barcodes.size() + '\n';
                for (i in multiple_barcodes.indices) {
                    val thisBarcode = multiple_barcodes[i]
                    val barcodeData = thisBarcode.getString("com.symbol.datawedge.data_string")
                    val symbology = thisBarcode.getString("com.symbol.datawedge.label_type")
                        barcodeBlock += "$barcodeData"
                    listOfCodes.add("$barcodeData");
                    if (multiple_barcodes.size != 1) barcodeBlock += ";"
                }
            }
            return JSONObject(mapOf("data" to listOfCodes)).toString();
        }else{
            var currentScan = "not scanning";
            if (intent.action.equals(PROFILE_INTENT_ACTION))
            {
                var scanData = intent.getStringExtra(dwUtils.DATAWEDGE_SCAN_EXTRA_DATA_STRING)
                var symbology = intent.getStringExtra(dwUtils.DATAWEDGE_SCAN_EXTRA_LABEL_TYPE)
                currentScan = "Barcode: $scanData [$symbology]"
            }
            return "Barcode: " + currentScan;
        }

    }


    private fun getAndroidVersion() : String {
        var sdkVersion:Int= Build.VERSION.SDK_INT;
        var release : String = Build.VERSION.RELEASE;
        return "Android Versión: " + sdkVersion + "("+ release + ")";

    }

}