package com.example.almaviva_app

import org.json.JSONObject;

class Scan(val data: String, val symbology: String)
{
    fun toJson(): String{
        return JSONObject(mapOf(
            "scanData" to this.data,
            "symbology" to this.symbology
        )).toString();
    }
}

