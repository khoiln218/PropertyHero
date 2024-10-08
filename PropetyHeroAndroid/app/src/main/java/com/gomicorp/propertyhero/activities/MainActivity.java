package com.gomicorp.propertyhero.activities;

import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.TypedArray;
import android.net.ConnectivityManager;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.ViewGroup;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.gomicorp.app.AppController;
import com.gomicorp.app.Config;
import com.gomicorp.helper.NetworkChangeReceiver;
import com.gomicorp.propertyhero.R;
import com.gomicorp.propertyhero.adapters.ViewPagerAdapter;
import com.gomicorp.propertyhero.extras.EndPoints;
import com.gomicorp.propertyhero.fragments.CollectionFragment;
import com.gomicorp.propertyhero.fragments.HomeFragment;
import com.gomicorp.propertyhero.fragments.MoreFragment;
import com.gomicorp.propertyhero.fragments.NotificationFragment;
import com.gomicorp.propertyhero.fragments.SearchFragment;
import com.gomicorp.propertyhero.json.Parser;
import com.gomicorp.propertyhero.model.Notify;
import com.gomicorp.ui.NonSwipeableViewPager;
import com.gomicorp.ui.NotifyDialog;
import com.google.android.material.tabs.TabLayout;

import org.json.JSONObject;

import java.util.List;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = MainActivity.class.getSimpleName();

    private TypedArray tabIcons;
    private TypedArray tabActiveIcons;
    private TabLayout tabMain;
    private NonSwipeableViewPager pagerMain;
    private ViewPagerAdapter pagerMainAdapter;

    private NetworkChangeReceiver networkChangeReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        networkChangeReceiver = new NetworkChangeReceiver(this, (ViewGroup) findViewById(R.id.mainLayout));
        registerReceiver(networkChangeReceiver, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));

        // TabLayout icons from resources
        tabIcons = getResources().obtainTypedArray(R.array.tab_icons);
        tabActiveIcons = getResources().obtainTypedArray(R.array.tab_active_icons);
        setupViewPager();
        setupTabLayout();

        fetchNotify();
    }

    private void handleDeepLink(Uri uri) {
        // Parse the URI and take action based on its content
        Log.e(TAG, "handleDeepLink: " + uri.toString());
        String scheme = uri.getScheme(); // "yourapp"
        String host = uri.getHost(); // "example.com"
        List<String> pathSegments = uri.getPathSegments();

        if ("propertyhero".equals(host)) {
            // Handle deep link based on the path or query parameters
            if (!pathSegments.isEmpty()) {
                String firstSegment = pathSegments.get(0);
                switch (firstSegment) {
                    case "home":
                        navigateToHome();
                        break;
                    case "profile":
                        navigateToProfile();
                        break;
                    default:
                        Log.e(TAG, "handleDeepLink: " + firstSegment);
                        break;
                }
            }
        }
    }

    private void navigateToHome() {
        // Implementation for navigating to the home screen
        Log.e(TAG, "navigateToHome");
    }

    private void navigateToProfile() {
        // Implementation for navigating to the profile screen
        Log.e(TAG, "navigateToProfile");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Config.REQUEST_FIND_MARKER) {
            if (resultCode == RESULT_OK)
                pagerMain.setCurrentItem(1);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(networkChangeReceiver);
    }

    private void setupViewPager() {
        pagerMain = (NonSwipeableViewPager) findViewById(R.id.pagerMain);
        pagerMain.setOffscreenPageLimit(5);
        pagerMainAdapter = new ViewPagerAdapter(getSupportFragmentManager());
        pagerMainAdapter.addFragment(new HomeFragment(), "");
        pagerMainAdapter.addFragment(new SearchFragment(), "");
        pagerMainAdapter.addFragment(new CollectionFragment(), "");
        pagerMainAdapter.addFragment(new NotificationFragment(), "");
        pagerMainAdapter.addFragment(new MoreFragment(), "");

        pagerMain.setAdapter(pagerMainAdapter);
    }

    private void setupTabLayout() {
        tabMain = (TabLayout) findViewById(R.id.tabMain);
        tabMain.post(new Runnable() {
            @Override
            public void run() {
                tabMain.setupWithViewPager(pagerMain);
                // Add Tab Icons
                tabMain.getTabAt(0).setIcon(tabActiveIcons.getResourceId(0, -1));
                tabMain.getTabAt(0).setTag(0);
                for (int i = 1; i < tabIcons.length(); i++) {
                    tabMain.getTabAt(i).setIcon(tabIcons.getResourceId(i, -1));
                    tabMain.getTabAt(i).setTag(i);
                }
            }
        });

        tabMain.addOnTabSelectedListener(
                new TabLayout.ViewPagerOnTabSelectedListener(pagerMain) {

                    @Override
                    public void onTabSelected(TabLayout.Tab tab) {
                        super.onTabSelected(tab);
                        if (tab.getTag() == null) return;
                        tab.setIcon(tabActiveIcons.getResourceId((Integer) tab.getTag(), -1));
                    }

                    @Override
                    public void onTabUnselected(TabLayout.Tab tab) {
                        super.onTabUnselected(tab);
                        if (tab.getTag() == null) return;
                        tab.setIcon(tabIcons.getResourceId((Integer) tab.getTag(), -1));
                    }

                    @Override
                    public void onTabReselected(TabLayout.Tab tab) {
                        super.onTabReselected(tab);
                    }
                }
        );
    }

    private void fetchNotify() {
        JsonObjectRequest reqNotify = new JsonObjectRequest(Request.Method.GET, EndPoints.URL_NOTIFY_LAUNCHER, null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                List<Notify> list = Parser.notifyList(response);
                if (list.size() > 0) {
                    NotifyDialog dialog = NotifyDialog.instance(list.get(0));
                    dialog.show(getSupportFragmentManager(), TAG);
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e(TAG, "Error at fetchNotify()");
            }
        });

        AppController.getInstance().addToRequestQueue(reqNotify, TAG);
    }
}
