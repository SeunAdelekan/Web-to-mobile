package com.iyanuadelekan.web_to_mobile;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.webkit.WebView;
import android.webkit.WebViewClient;

import org.json.JSONException;
import org.json.JSONObject;
import java.io.IOException;
import java.io.InputStream;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        WebView webView = (WebView) findViewById(R.id.webview_main);

        InputStream inputStream;
        JSONObject jsonObject;
        String jsonString = null;
        try {
            inputStream = getAssets().open("init.json");
            int size = inputStream.available();
            byte[] buffer = new byte[size];
            inputStream.read(buffer);
            jsonString = new String(buffer);
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            jsonObject = new JSONObject(jsonString);
            getSupportActionBar().setTitle(jsonObject.getString("AppName"));
            webView.setWebViewClient(new WebViewClient());
            webView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
            webView.getSettings().setJavaScriptEnabled(true);
            webView.loadUrl(jsonObject.getString("URL"));
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

}
