package com.gomicorp.propertyhero.activities;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.android.volley.VolleyError;
import com.gomicorp.app.AppController;
import com.gomicorp.app.Config;
import com.gomicorp.helper.L;
import com.gomicorp.helper.Utils;
import com.gomicorp.propertyhero.R;
import com.gomicorp.propertyhero.adapters.FeatureRecyclerAdapter;
import com.gomicorp.propertyhero.adapters.ImageSlideAdapter;
import com.gomicorp.propertyhero.callbacks.OnLoadProductListener;
import com.gomicorp.propertyhero.callbacks.OnResponseListener;
import com.gomicorp.propertyhero.json.ProductRequest;
import com.gomicorp.propertyhero.model.Feature;
import com.gomicorp.propertyhero.model.Product;
import com.gomicorp.propertyhero.model.ResponseInfo;
import com.gomicorp.ui.WorkaroundMapFragment;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ProductDetailsActivity extends AppCompatActivity implements OnMapReadyCallback, View.OnClickListener {

    private static final String TAG = ProductDetailsActivity.class.getSimpleName();

    private long id;
    private GoogleMap googleMap;
    private Product product;
    private String phone;

    private RelativeLayout imageLayout;
    private ViewPager pagerImage;
    private LinearLayout mapLayout;
    private TextView idProperty, tvPrice, tvTitle, tvArea, tvFloor, tvServiceFee, tvAddress, tvPropertyInfo, tvDepositInfo, tvPriceInfo,
            tvFloorInfo, tvFloorCount, tvGFArea, tvBedroom, tvBathroom, tvDirection, tvElevator, tvPet, tvNumPerson, tvContent, tvContactName, tvContactPhone, tvImage;

    private List<Feature> featureList;
    private FeatureRecyclerAdapter featureAdapter;
    private RecyclerView recyclerFeature;

    private List<Feature> furnitureList;
    private FeatureRecyclerAdapter furnitureAdapter;
    private RecyclerView recyclerFurniture;
    private Menu menu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_product_details);

        id = getIntent().getLongExtra(Config.DATA_EXTRA, 0);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitleTextColor(Color.WHITE);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setTitle("");


        int height = (int) (Utils.getScreenWidth() / 1.5);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, height);

        imageLayout = (RelativeLayout) findViewById(R.id.imageLayout);
        imageLayout.setLayoutParams(layoutParams);
        mapLayout = (LinearLayout) findViewById(R.id.mapLayout);
        mapLayout.setLayoutParams(layoutParams);

        pagerImage = (ViewPager) findViewById(R.id.pagerImage);

        idProperty = (TextView) findViewById(R.id.idProperty);
        tvPrice = (TextView) findViewById(R.id.tvPrice);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvArea = (TextView) findViewById(R.id.tvArea);
        tvFloor = (TextView) findViewById(R.id.tvFloor);
        tvServiceFee = (TextView) findViewById(R.id.tvServiceFee);

        tvAddress = (TextView) findViewById(R.id.tvAddress);
        tvPropertyInfo = (TextView) findViewById(R.id.tvPropertyInfo);
        tvDepositInfo = (TextView) findViewById(R.id.tvDepositInfo);
        tvPriceInfo = (TextView) findViewById(R.id.tvPriceInfo);
        tvFloorInfo = (TextView) findViewById(R.id.tvFloorInfo);
        tvFloorCount = (TextView) findViewById(R.id.tvFloorCount);
        tvGFArea = (TextView) findViewById(R.id.tvGFArea);
        tvBedroom = (TextView) findViewById(R.id.tvBedroom);
        tvBathroom = (TextView) findViewById(R.id.tvBathroom);
        tvDirection = (TextView) findViewById(R.id.tvDirection);
        tvElevator = (TextView) findViewById(R.id.tvElevator);
        tvPet = (TextView) findViewById(R.id.tvPet);
        tvNumPerson = (TextView) findViewById(R.id.tvNumPerson);
        tvContent = (TextView) findViewById(R.id.tvContent);
        tvContactName = (TextView) findViewById(R.id.tvContactName);
        tvContactPhone = (TextView) findViewById(R.id.tvContactPhone);
        tvImage = (TextView) findViewById(R.id.tvImage);

        setupRecyclerFeature();
        setupRecyclerFurniture();

        WorkaroundMapFragment mapFragment = (WorkaroundMapFragment) getSupportFragmentManager().findFragmentById(R.id.mapProductLocation);
        mapFragment.getMapAsync(this);
        mapFragment.setListener(new WorkaroundMapFragment.OnTouchListener() {
            @Override
            public void onTouch() {
                ((NestedScrollView) findViewById(R.id.scrollProductDetails)).requestDisallowInterceptTouchEvent(true);
            }
        });

        findViewById(R.id.btnContact).setOnClickListener(this);
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (id == 0)
            finish();

        fetchProductDetails();
    }

    @Override
    protected void onStop() {
        super.onStop();
        ProductRequest.cancelRequest();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_product, menu);
        this.menu = menu;
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return true;
            case R.id.action_favorite:
                if (product != null)
                    handleFavorite();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Config.REQUEST_PRODUCT && resultCode == Config.SUCCESS_RESULT)
            handleFavorite();
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        this.googleMap = googleMap;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btnContact:
                if (phone != null) {
                    Intent callIntent = new Intent(Intent.ACTION_DIAL);
                    callIntent.setData(Uri.parse("tel:" + phone));
                    startActivity(callIntent);
                }
                break;
            default:
                break;
        }
    }

    private void setupRecyclerFeature() {
        recyclerFeature = (RecyclerView) findViewById(R.id.recyclerFeature);
        featureList = new ArrayList<>();
        featureAdapter = new FeatureRecyclerAdapter(featureList);

        recyclerFeature.setHasFixedSize(true);
        recyclerFeature.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        recyclerFeature.setAdapter(featureAdapter);
    }

    private void setupRecyclerFurniture() {
        recyclerFurniture = (RecyclerView) findViewById(R.id.recyclerFurniture);
        furnitureList = new ArrayList<>();
        furnitureAdapter = new FeatureRecyclerAdapter(furnitureList);

        recyclerFurniture.setHasFixedSize(true);
        recyclerFurniture.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        recyclerFurniture.setAdapter(furnitureAdapter);
    }

    private void fetchProductDetails() {
        ProductRequest.getProduct(id, 0, new OnLoadProductListener() {
            @Override
            public void onSuccess(List<Product> products, int totalItems) {
                if (products.size() > 0) {
                    product = products.get(0);
                } else {
                    L.showToast(getString(R.string.product_expire));
                    requestDeleteFavorite_V2();
                }

                updateUI();
            }

            @Override
            public void onError(VolleyError error) {
                Log.e(TAG, "Error at fetchProductDetails()");
            }
        });
    }

    @SuppressLint("SetTextI18n")
    private void updateUI() {
        if (product != null) {
            findViewById(R.id.progressLayout).setVisibility(View.GONE);

            this.phone = product.getContactPhone();
            setupIsFavorite();
            setupSliderImage();

            idProperty.setText(String.format(getString(R.string.title_product).replace("...", String.valueOf(product.getId()))));
            tvPrice.setText(Utils.numberToString(product.getPrice()));
            tvTitle.setText(product.getTitle());
            L.getString(product.getTitle(), text -> tvTitle.setText(text));
            tvArea.setText(Utils.numberToString(product.getGrossFloorArea()));
            tvFloor.setText((product.getFloor() > 0 ? product.getFloor() : " - ") + (product.getFloorCount() > 0 ? "/" + product.getFloorCount() : ""));

            double serviceFee = product.getServiceFee();
            if (serviceFee > 0)
                tvServiceFee.setText(Utils.numberToString(serviceFee));
            else {
                tvServiceFee.setText("-");
                findViewById(R.id.tvServiceFeeUnit).setVisibility(View.GONE);
            }

            if (this.googleMap != null) {
                LatLng center = new LatLng(product.getLatitude(), product.getLongitude());

                this.googleMap.addCircle(new CircleOptions().center(center)
                        .radius(80)
                        .strokeColor(Color.WHITE)
                        .strokeWidth(3)
                        .fillColor(Color.parseColor("#FFC000")));
                this.googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(center, 15));
            }

            tvAddress.setText(product.getAddresss());
            tvPropertyInfo.setText(product.getPropertyName());

            double deposit = product.getDeposit();
            if (deposit > 0)
                tvDepositInfo.setText(Utils.numberToString(deposit));
            else {
                tvDepositInfo.setText("-");
                findViewById(R.id.tvDepositUnit).setVisibility(View.GONE);
            }

            tvPriceInfo.setText(Utils.numberToString(product.getPrice()));
            tvFloorInfo.setText(product.getFloor() > 0 ? String.valueOf(product.getFloor()) : "-");
            tvFloorCount.setText(product.getFloorCount() > 0 ? String.valueOf(product.getFloorCount()) : "-");
            tvGFArea.setText(Utils.numberToString(product.getGrossFloorArea()));
            tvBedroom.setText(product.getBedroom() > 0 ? String.valueOf(product.getBedroom()) : "-");
            tvBathroom.setText(product.getBathroom() > 0 ? String.valueOf(product.getBathroom()) : "-");
            tvDirection.setText(product.getDirectionName());
            tvElevator.setText(product.getElevator() > 0 ? getString(R.string.text_on) : getString(R.string.text_off));
            tvPet.setText(product.getPets() > 0 ? getString(R.string.text_on) : getString(R.string.text_off));
            tvNumPerson.setText(product.getNumPerson() > 0 ? String.valueOf(product.getNumPerson()) : "-");
            tvContent.setText(product.getContent());
            L.getString(product.getContent(), text -> tvContent.setText(text));
            tvContactName.setText(product.getContactName());
            tvContactPhone.setText(Utils.phoneFormatter(product.getContactPhone()));

            featureList = product.getFeatures();
            if (featureList.size() > 0)
                featureAdapter.setFeatureList(featureList);
            else
                findViewById(R.id.featureLayout).setVisibility(View.GONE);

            furnitureList = product.getFurnitures();
            if (furnitureList.size() > 0)
                furnitureAdapter.setFeatureList(furnitureList);
            else
                findViewById(R.id.furnitureLayout).setVisibility(View.GONE);

        } else {
            Log.e(TAG, "updateUI: ");
        }
    }

    private void setupIsFavorite() {
        if (menu == null)
            return;

        if (product.getIsLikeThis() == 0)
            menu.findItem(R.id.action_favorite).setIcon(R.drawable.vector_action_favorite);
        else
            menu.findItem(R.id.action_favorite).setIcon(R.drawable.vector_action_unfavorite);
    }

    private void setupSliderImage() {
        final List<String> imageList = new ArrayList<>(Arrays.asList(product.getThumbnail().split(",")));
        tvImage.setText(imageList.size() + getString(R.string.unit_image));

        ImageSlideAdapter imageAdapter = new ImageSlideAdapter(this, imageList, product.getStatus(), false, new ImageSlideAdapter.OnPagerItemSelected() {
            @Override
            public void pagerItemSelected() {
                Intent intent = new Intent(ProductDetailsActivity.this, ImageSliderActivity.class);
                Bundle bundle = new Bundle();
                bundle.putStringArrayList(Config.STRING_DATA, (ArrayList<String>) imageList);
                bundle.putInt(Config.STATUS_DATA, product.getStatus());
                bundle.putInt(Config.RESULT_DATA, pagerImage.getCurrentItem());
                intent.putExtra(Config.DATA_EXTRA, bundle);
                startActivity(intent);
            }
        });
        pagerImage.setAdapter(imageAdapter);
    }

    private void launchWarning() {
        if (AppController.getInstance().getPrefManager().getUserID() == 0) {
            Intent intentLogin = new Intent(this, LoginActivity.class);
            Bundle bundle = new Bundle();
            bundle.putString(Config.STRING_DATA, WarningActivity.class.getSimpleName());
            bundle.putLong(Config.PRODUCT_ID, product.getId());
            intentLogin.putExtra(Config.DATA_EXTRA, bundle);
            startActivity(intentLogin);
        } else {
            Intent intent = new Intent(this, WarningActivity.class);
            intent.putExtra(Config.PRODUCT_ID, product.getId());
            startActivity(intent);
        }
    }

    private void handleFavorite() {
        if (AppController.getInstance().getPrefManager().getUserID() == 0) {
            Intent intentLogin = new Intent(this, LoginActivity.class);
            ActivityCompat.startActivityForResult(this, intentLogin, Config.REQUEST_PRODUCT, null);
        } else
            requestFavorite();
    }

    private void requestFavorite() {
        if (Config.USE_V2) {
            if (product.getIsLikeThis() == 0) {
                requestFavorite_V2();
            } else {
                requestDeleteFavorite_V2();
            }

            setupIsFavorite();
            return;
        }
        ProductRequest.favorite(product.getId(), new OnResponseListener() {
            @Override
            public void onSuccess(ResponseInfo info) {
                if (info != null && info.isSuccess()) {
                    if (product.getIsLikeThis() == 0)
                        product.setIsLikeThis(1);
                    else
                        product.setIsLikeThis(0);
                } else
                    L.showToast(getString(R.string.err_request_api));

                setupIsFavorite();
            }

            @Override
            public void onError(VolleyError error) {
                L.showToast(getString(R.string.request_time_out));
                Log.e(TAG, "Error at handleFavorite()");
            }
        });
    }

    private void requestFavorite_V2() {
        ProductRequest.favorite_V2(product.getId(), new OnResponseListener() {
            @Override
            public void onSuccess(ResponseInfo info) {
                if (info != null && info.isSuccess()) {
                    if (product.getIsLikeThis() == 0)
                        product.setIsLikeThis(1);
                    else
                        product.setIsLikeThis(0);
                } else
                    L.showToast(getString(R.string.err_request_api));

                setupIsFavorite();
            }

            @Override
            public void onError(VolleyError error) {
                L.showToast(getString(R.string.request_time_out));
                Log.e(TAG, "Error at requestFavorite_V2()");
            }
        });
    }

    private void requestDeleteFavorite_V2() {
        ProductRequest.favoriteDelete_V2(id, new OnResponseListener() {
            @Override
            public void onSuccess(ResponseInfo info) {
                if (product == null) {
                    finish();
                    return;
                }
                if (info != null && info.isSuccess()) {
                    if (product.getIsLikeThis() == 0)
                        product.setIsLikeThis(1);
                    else
                        product.setIsLikeThis(0);
                } else
                    L.showToast(getString(R.string.err_request_api));

                setupIsFavorite();
            }

            @Override
            public void onError(VolleyError error) {
                L.showToast(getString(R.string.request_time_out));
                Log.e(TAG, "Error at requestFavorite_V2()");
            }
        });
    }
}
