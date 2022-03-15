package com.example.almaviva_app

import android.content.Context
import android.content.Intent
import android.os.Bundle
import java.util.*

object DWUtilities {
    const val PROFILE_INTENT_ACTION = "com.zebra.dwmultibarcode"
    const val PROFILE_NAME = "DataWedge MultiBarcode"
    private const val EXTRA_GET_VERSION_INFO = "com.symbol.datawedge.api.GET_VERSION_INFO"
    private const val EXTRA_KEY_NOTIFICATION_TYPE = "com.symbol.datawedge.api.NOTIFICATION_TYPE"
    private const val EXTRA_KEY_APPLICATION_NAME = "com.symbol.datawedge.api.APPLICATION_NAME"
    private const val EXTRA_REGISTER_NOTIFICATION =
        "com.symbol.datawedge.api.REGISTER_FOR_NOTIFICATION"
    private const val EXTRA_UNREGISTER_NOTIFICATION =
        "com.symbol.datawedge.api.UNREGISTER_FOR_NOTIFICATION"
    private const val EXTRA_GET_CONFIG = "com.symbol.datawedge.api.GET_CONFIG"
    private const val EXTRA_GET_ACTIVE_PROFILE = "com.symbol.datawedge.api.GET_ACTIVE_PROFILE"
    private const val EXTRA_CREATE_PROFILE = "com.symbol.datawedge.api.CREATE_PROFILE"
    private const val EXTRA_SET_CONFIG = "com.symbol.datawedge.api.SET_CONFIG"
    private const val ACTION_DATAWEDGE = "com.symbol.datawedge.api.ACTION"
    private const val EXTRA_EMPTY = ""

    //  Receiving
    const val ACTION_RESULT_DATAWEDGE = "com.symbol.datawedge.api.RESULT_ACTION"
    const val EXTRA_RESULT_GET_ACTIVE_PROFILE = "com.symbol.datawedge.api.RESULT_GET_ACTIVE_PROFILE"
    const val EXTRA_RESULT_GET_VERSION_INFO = "com.symbol.datawedge.api.RESULT_GET_VERSION_INFO"
    const val EXTRA_RESULT_GET_CONFIG = "com.symbol.datawedge.api.RESULT_GET_CONFIG"
    const val ACTION_RESULT_NOTIFICATION = "com.symbol.datawedge.api.NOTIFICATION_ACTION"
    const val EXTRA_RESULT_NOTIFICATION = "com.symbol.datawedge.api.NOTIFICATION"
    const val EXTRA_RESULT_NOTIFICATION_TYPE = "NOTIFICATION_TYPE"
    const val EXTRA_KEY_VALUE_SCANNER_STATUS = "SCANNER_STATUS"
    const val EXTRA_KEY_VALUE_NOTIFICATION_STATUS = "STATUS"
    const val EXTRA_KEY_VALUE_PROFILE_SWITCH = "PROFILE_SWITCH"
    fun getDWVersion(context: Context) {
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_GET_VERSION_INFO, EXTRA_EMPTY)
    }

    fun registerForProfileSwitch(context: Context) {
        val extras = Bundle()
        extras.putString(EXTRA_KEY_APPLICATION_NAME, context.packageName)
        extras.putString(EXTRA_KEY_NOTIFICATION_TYPE, EXTRA_KEY_VALUE_SCANNER_STATUS)
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_REGISTER_NOTIFICATION, extras)
    }

    fun deregisterProfileSwitch(context: Context) {
        val extras = Bundle()
        extras.putString(EXTRA_KEY_APPLICATION_NAME, context.packageName)
        extras.putString(EXTRA_KEY_NOTIFICATION_TYPE, EXTRA_KEY_VALUE_SCANNER_STATUS)
        sendDataWedgeIntentWithExtra(
            context,
            ACTION_DATAWEDGE,
            EXTRA_UNREGISTER_NOTIFICATION,
            extras
        )
    }

    fun getActiveProfile(context: Context) {
        sendDataWedgeIntentWithExtra(
            context,
            ACTION_DATAWEDGE,
            EXTRA_GET_ACTIVE_PROFILE,
            EXTRA_EMPTY
        )
    }

    fun getConfig(context: Context) {
        val bMain = Bundle()
        bMain.putString("PROFILE_NAME", PROFILE_NAME)
        val bConfig = Bundle()
        val pluginName = ArrayList<String>()
        pluginName.add("BARCODE")
        bConfig.putStringArrayList("PLUGIN_NAME", pluginName)
        bMain.putBundle("PLUGIN_CONFIG", bConfig)
        //  This is one example of a config that can be obtained.  The documentation details how
        //  to obtain the associated applications with a profile or the current scanner status
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_GET_CONFIG, bMain)
    }

    fun createProfile(context: Context) {
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_CREATE_PROFILE, PROFILE_NAME)

        //  Now configure that created profile to apply to our application
        val profileConfig = Bundle()
        profileConfig.putString("PROFILE_NAME", PROFILE_NAME)
        profileConfig.putString("PROFILE_ENABLED", "true") //  Seems these are all strings
        profileConfig.putString("CONFIG_MODE", "UPDATE")
        val barcodeConfig = Bundle()
        barcodeConfig.putString("PLUGIN_NAME", "BARCODE")
        val barcodeProps = Bundle()
        //  Note: configure_all_scanners does not work here, I guess because not all DW scanners (Camera?) support multi barcode
        //barcodeProps.putString("configure_all_scanners", "true");
        barcodeProps.putString("scanner_selection_by_identifier", "INTERNAL_IMAGER")
        barcodeProps.putString("scanner_input_enabled", "true")
        barcodeProps.putString("scanning_mode", "3")
        barcodeConfig.putBundle("PARAM_LIST", barcodeProps)
        profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig)
        val appConfig = Bundle()
        appConfig.putString(
            "PACKAGE_NAME",
            context.packageName
        ) //  Associate the profile with this app
        appConfig.putStringArray("ACTIVITY_LIST", arrayOf("*"))
        profileConfig.putParcelableArray("APP_LIST", arrayOf(appConfig))
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_SET_CONFIG, profileConfig)

        //  You can only configure one plugin at a time, we have done the barcode input, now do the intent output
        profileConfig.remove("PLUGIN_CONFIG")
        val intentConfig = Bundle()
        intentConfig.putString("PLUGIN_NAME", "INTENT")
        intentConfig.putString("RESET_CONFIG", "true")
        val intentProps = Bundle()
        intentProps.putString("intent_output_enabled", "true")
        intentProps.putString("intent_action", PROFILE_INTENT_ACTION)
        intentProps.putString("intent_delivery", "2")
        intentConfig.putBundle("PARAM_LIST", intentProps)
        profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_SET_CONFIG, profileConfig)

        //  Disable keyboard output
        profileConfig.remove("PLUGIN_CONFIG")
        val keystrokeConfig = Bundle()
        keystrokeConfig.putString("PLUGIN_NAME", "KEYSTROKE")
        keystrokeConfig.putString("RESET_CONFIG", "true")
        val keystrokeProps = Bundle()
        keystrokeProps.putString("keystroke_output_enabled", "false")
        keystrokeConfig.putBundle("PARAM_LIST", keystrokeProps)
        profileConfig.putBundle("PLUGIN_CONFIG", keystrokeConfig)
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_SET_CONFIG, profileConfig)
    }

    fun setConfig(context: Context, numberOfBarcodesPerScan: Int, bReportInstantly: Boolean) {
        val profileConfig = Bundle()
        profileConfig.putString("PROFILE_NAME", PROFILE_NAME)
        profileConfig.putString("PROFILE_ENABLED", "true") //  Seems these are all strings
        profileConfig.putString("CONFIG_MODE", "UPDATE")
        val barcodeConfig = Bundle()
        barcodeConfig.putString("PLUGIN_NAME", "BARCODE")
        barcodeConfig.putString("RESET_CONFIG", "true")
        val barcodeProps = Bundle()
        //  Note: configure_all_scanners does not work here, I guess because not all DW scanners (Camera?) support multi barcode
        barcodeProps.putString("scanner_selection_by_identifier", "INTERNAL_IMAGER")
        barcodeProps.putString("scanning_mode", "3")
        if (bReportInstantly) barcodeProps.putString(
            "instant_reporting_enable",
            "true"
        ) else barcodeProps.putString("instant_reporting_enable", "false")
        barcodeProps.putString("multi_barcode_count", "" + numberOfBarcodesPerScan)
        barcodeConfig.putBundle("PARAM_LIST", barcodeProps)
        profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig)
        sendDataWedgeIntentWithExtra(context, ACTION_DATAWEDGE, EXTRA_SET_CONFIG, profileConfig)
    }

    private fun sendDataWedgeIntentWithExtra(
        context: Context,
        action: String,
        extraKey: String,
        extraValue: String
    ) {
        val dwIntent = Intent()
        dwIntent.action = action
        dwIntent.putExtra(extraKey, extraValue)
        context.sendBroadcast(dwIntent)
    }

    private fun sendDataWedgeIntentWithExtra(
        context: Context,
        action: String,
        extraKey: String,
        extras: Bundle
    ) {
        val dwIntent = Intent()
        dwIntent.action = action
        dwIntent.putExtra(extraKey, extras)
        context.sendBroadcast(dwIntent)
    }
}