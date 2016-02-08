package com.ecotomsk.loyaltyapp;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

public class SettingsActivity extends Activity {

    private EditText etTimer;
    private EditText etServer;
    private SharedPreferences mSettings;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_settings);

        //Getting preferences
        mSettings = getSharedPreferences(MainActivity.APP_PREFERENCES, Context.MODE_PRIVATE);
        int timer = mSettings.getInt(MainActivity.APP_PREFERENCES_TIMER, 10000);
        String serverName = mSettings.getString(MainActivity.APP_PREFERENCES_SERVER, "192.168.0.47:9080");

        etTimer = (EditText) findViewById(R.id.timerEdit);
        etTimer.setText(String.valueOf(timer));
        etServer = (EditText) findViewById(R.id.serverEdit);
        etServer.setText(serverName);

    }

    public void onClick(View view) {
        SharedPreferences.Editor editor = mSettings.edit();

        //Updating preferences
        editor.putInt(MainActivity.APP_PREFERENCES_TIMER, Integer.parseInt(etTimer.getText().toString()));
        editor.putString(MainActivity.APP_PREFERENCES_SERVER, etServer.getText().toString());
        editor.apply();
    }
}
