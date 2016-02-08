package com.ecotomsk.loyaltyapp;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

public class MainActivity extends Activity implements LocationListener {

    private LocationManager locationManager;
    private String provider;

    public static final String APP_PREFERENCES = "mysettings";
    public static final String APP_PREFERENCES_TIMER = "timer";
    public static final String APP_PREFERENCES_SERVER = "server";
    private SharedPreferences mSettings;

    /**************************************************
     *      Activity methods
     ****************************************************/


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Getting access to stored preferences
        mSettings = getSharedPreferences(APP_PREFERENCES, Context.MODE_PRIVATE);

        // Getting LocationManager object
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        // Creating an empty criteria object
        Criteria criteria = new Criteria();

        // Getting the name of the provider that meets the criteria
        //provider = locationManager.getProvider(LocationManager.GPS_PROVIDER);

        int timer = mSettings.getInt(APP_PREFERENCES_TIMER, 10);

        if (provider != null && !provider.equals("")) {
            // Get the location from the given provider
            Location location = locationManager.getLastKnownLocation(provider);

            locationManager.requestLocationUpdates(provider, timer, 1, this);
            if (location != null)
                onLocationChanged(location);
            else
                Toast.makeText(getBaseContext(), "Location can't be retrieved", Toast.LENGTH_SHORT).show();

        } else {
            Toast.makeText(getBaseContext(), "No Provider Found", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        //Timer preferences
        int timer = mSettings.getInt(APP_PREFERENCES_TIMER, 10);

        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, timer, 1, this);

        //Getting current location
        Location location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);

        processLocation(location);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.menu_settings) {
            Intent intent = new Intent(MainActivity.this, SettingsActivity.class);
            startActivity(intent);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void onClick(View view) {

        Location location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);

        processLocation(location);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return true;
    }

    /*******************************************************
     *      Location listener methods
     *******************************************************/

    @Override
    public void onLocationChanged(Location location) {

        processLocation(location);
    }

    @Override
    public void onProviderDisabled(String provider) {
        // TODO Auto-generated method stub
    }

    @Override
    public void onProviderEnabled(String provider) {
        // TODO Auto-generated method stub
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
        // TODO Auto-generated method stub
    }



    /*******************************************************
     *     Application methods
     *******************************************************/

    /**
     * Display current location and create request to service.
     * @param location
     */
    private void processLocation(Location location) {

        //Server preferences
        String serverName = mSettings.getString(APP_PREFERENCES_SERVER, "192.168.0.47:9080");

        TextView tvLongitude = (TextView) findViewById(R.id.tv_longitude);
        TextView tvLatitude = (TextView) findViewById(R.id.tv_latitude);

        String longitude = location.getLongitude() + "";
        String latitude = location.getLatitude() + "";

        // Setting Current Longitude
        tvLongitude.setText("Longitude:" + longitude);

        // Setting Current Latitude
        tvLatitude.setText("Latitude:" + latitude);

        //Queue for service requests
        createRequest(serverName, longitude, latitude);
    }

    private void createRequest(String serverName, String longitude, String latitude) {

        final TextView checkText = (TextView) findViewById(R.id.checkText);
        RequestQueue queue = Volley.newRequestQueue(this);

        String url = "http://" + serverName + "/find-offer?lat=" + latitude + "&lon=" + longitude;

        JsonObjectRequest jsObjRequest = new JsonObjectRequest
                (Request.Method.GET, url, null, new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            checkText.setText(response.getString("desc"));
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {

                    @Override
                    public void onErrorResponse(VolleyError error) {
                        checkText.setText("Error: " + error.getMessage());

                    }
                });

        queue.add(jsObjRequest);
    }




}