
package com.example.almaviva_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.widget.TextView
import com.example.almaviva_app.DWUtilities.EXTRA_RESULT_GET_ACTIVE_PROFILE
import com.example.almaviva_app.DWUtilities.createProfile
import com.example.almaviva_app.DWUtilities.getActiveProfile
import com.example.almaviva_app.DWUtilities.getConfig
import com.example.almaviva_app.DWUtilities.registerForProfileSwitch
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

    private val dwInterface = DWInterface()

    //MultiBarcodes
    private val dwUtils = DWUtilities
    var m_bUiInitialised = false
    var m_bReportInstantly = false
    var m_iBarcodeCount = 5


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
                dwInterface.sendCommandString(applicationContext, command, parameter)
                //  result.success(0);  //  DataWedge does not return responses
            }
            else if (call.method == "createDataWedgeProfile")
            {
                createDataWedgeProfile(call.arguments.toString())
            }
            else {
                result.notImplemented()
            }
        }

    }


    private fun createDataWedgeProfile(profileName: String) {
        //  Create and configure the DataWedge profile associated with this application
        //  For readability's sake, I have not defined each of the keys in the DWInterface file
        dwInterface.sendCommandString(this, DWInterface.DATAWEDGE_SEND_CREATE_PROFILE, profileName)
        val profileConfig = Bundle()
        profileConfig.putString("PROFILE_NAME", profileName)
        profileConfig.putString("PROFILE_ENABLED", "true") //  These are all strings
        profileConfig.putString("CONFIG_MODE", "UPDATE")
        val barcodeConfig = Bundle()
        barcodeConfig.putString("PLUGIN_NAME", "BARCODE")
        barcodeConfig.putString("RESET_CONFIG", "true") //  This is the default but never hurts to specify
        val barcodeProps = Bundle()
        barcodeConfig.putBundle("PARAM_LIST", barcodeProps)
        profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig)
        val appConfig = Bundle()
        appConfig.putString("PACKAGE_NAME", packageName)      //  Associate the profile with this app
        appConfig.putStringArray("ACTIVITY_LIST", arrayOf("*"))
        profileConfig.putParcelableArray("APP_LIST", arrayOf(appConfig))
        dwInterface.sendCommandBundle(this, DWInterface.DATAWEDGE_SEND_SET_CONFIG, profileConfig)
        //  You can only configure one plugin at a time in some versions of DW, now do the intent output
        profileConfig.remove("PLUGIN_CONFIG")
        val intentConfig = Bundle()
        intentConfig.putString("PLUGIN_NAME", "INTENT")
        intentConfig.putString("RESET_CONFIG", "true")
        val intentProps = Bundle()
        intentProps.putString("intent_output_enabled", "true")
        intentProps.putString("intent_action", PROFILE_INTENT_ACTION)
        intentProps.putString("intent_delivery", PROFILE_INTENT_BROADCAST)  //  "2"
        intentConfig.putBundle("PARAM_LIST", intentProps)
        profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)
        dwInterface.sendCommandBundle(this, DWInterface.DATAWEDGE_SEND_SET_CONFIG, profileConfig)
    }
    private fun createDataWedgeBroadcastReceiver(events: EventChannel.EventSink?): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action.equals(PROFILE_INTENT_ACTION))
                {
                  displayScanResult(intent);
                }else if(intent.equals(dwUtils.ACTION_RESULT_DATAWEDGE)){
                    if (intent.hasExtra(EXTRA_RESULT_GET_ACTIVE_PROFILE)) {
                        val activeProfile = intent.getStringExtra(EXTRA_RESULT_GET_ACTIVE_PROFILE)
                        if (DWUtilities.PROFILE_NAME.equals(activeProfile, ignoreCase = true)) {
                            //  The correct DataWedge profile is now in effect
                            profileIsApplied()
                        }
                    } else if (intent.hasExtra(DWUtilities.EXTRA_RESULT_GET_VERSION_INFO)) {
                        //  6.3 API for GetVersionInfo
                        val versionInformation =
                            intent.getBundleExtra(DWUtilities.EXTRA_RESULT_GET_VERSION_INFO)
                        val DWVersion = versionInformation!!.getString("DATAWEDGE")

                        if (DWVersion!!.compareTo("7.3.0") >= 1) {
                            //  Register for profile change - want to update the UI based on the profile
                            createProfile(applicationContext)
                            registerForProfileSwitch(applicationContext)
                            getActiveProfile(applicationContext)
                        }
                    }
                }else if (intent.action == DWUtilities.ACTION_RESULT_NOTIFICATION) {
                    //  6.3 API for RegisterForNotification
                    if (intent.hasExtra(DWUtilities.EXTRA_RESULT_NOTIFICATION)) {
                        val extras = intent.getBundleExtra(DWUtilities.EXTRA_RESULT_NOTIFICATION)
                        val notificationType =
                            extras!!.getString(DWUtilities.EXTRA_RESULT_NOTIFICATION_TYPE)
                        if (notificationType != null && notificationType == DWUtilities.EXTRA_KEY_VALUE_PROFILE_SWITCH) {
                            //  The profile has changed
                            if (dwUtils.PROFILE_NAME.equals(extras!!.getString("PROFILE_NAME"), ignoreCase = true)) {
                                //  The correct DataWedge profile is now in effect
                                profileIsApplied()
                            }
                        }

                    }
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
        return "";
    }


    private fun getAndroidVersion() : String {
        var sdkVersion:Int= Build.VERSION.SDK_INT;
        var release : String = Build.VERSION.RELEASE;
        return "Android Versión: " + sdkVersion + "("+ release + ")";

    }

}