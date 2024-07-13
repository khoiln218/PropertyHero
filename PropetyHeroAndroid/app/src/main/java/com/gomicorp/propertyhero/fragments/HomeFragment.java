package com.gomicorp.propertyhero.fragments;


import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.location.Location;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.BackgroundColorSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.daimajia.slider.library.SliderLayout;
import com.daimajia.slider.library.SliderTypes.BaseSliderView;
import com.daimajia.slider.library.SliderTypes.TextSliderView;
import com.gomicorp.app.AppController;
import com.gomicorp.app.Config;
import com.gomicorp.app.GoogleApiHelper;
import com.gomicorp.helper.L;
import com.gomicorp.helper.Utils;
import com.gomicorp.propertyhero.R;
import com.gomicorp.propertyhero.activities.ListViewProductActivity;
import com.gomicorp.propertyhero.activities.ProductDetailsActivity;
import com.gomicorp.propertyhero.adapters.DistrictSuggestAdapter;
import com.gomicorp.propertyhero.adapters.ProductListHomeAdapter;
import com.gomicorp.propertyhero.callbacks.OnLoadProductListener;
import com.gomicorp.propertyhero.callbacks.OnRecyclerTouchListener;
import com.gomicorp.propertyhero.callbacks.RecyclerTouchListner;
import com.gomicorp.propertyhero.extras.EndPoints;
import com.gomicorp.propertyhero.json.Parser;
import com.gomicorp.propertyhero.json.ProductRequest;
import com.gomicorp.propertyhero.model.Advertising;
import com.gomicorp.propertyhero.model.DistrictSuggest;
import com.gomicorp.propertyhero.model.Product;
import com.gomicorp.propertyhero.model.SearchInfo;
import com.gomicorp.ui.ChildAnimation;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.maps.model.LatLng;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * A simple {@link Fragment} subclass.
 */
public class HomeFragment extends Fragment implements View.OnClickListener {

    private static final String TAG = HomeFragment.class.getSimpleName();

    private GoogleApiHelper googleApi;
    private LocationListener listener;
    private LatLng latLng;
    private List<Advertising> advList;
    private SliderLayout imageSlider;
    private List<Product> productList;
    private ProductListHomeAdapter adapter;
    private RecyclerView recyclerView;
    private DistrictSuggestAdapter adapterHCM;
    private RecyclerView rvHCM;
    private DistrictSuggestAdapter adapterHN;
    private RecyclerView rvHN;
    private SearchInfo searchInfo;

    public HomeFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        View root = inflater.inflate(R.layout.fragment_home, container, false);

        imageSlider = (SliderLayout) root.findViewById(R.id.imageSlider);

        imageSlider.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, Utils.getScreenWidth() / 2));

        productList = new ArrayList<>();

        root.findViewById(R.id.btnViewAll).setOnClickListener(this);
        root.findViewById(R.id.btnApartment).setOnClickListener(this);
        root.findViewById(R.id.btnRoom).setOnClickListener(this);
        root.findViewById(R.id.hot_view_all).setOnClickListener(this);

        recyclerView = root.findViewById(R.id.recycleView);
        adapter = new ProductListHomeAdapter(productList);
        recyclerView.setAdapter(adapter);
        recyclerView.addOnItemTouchListener(new RecyclerTouchListner(requireContext(), recyclerView, new OnRecyclerTouchListener() {
            @Override
            public void onClick(View view, int position) {
                Intent intent = new Intent(requireContext(), ProductDetailsActivity.class);
                intent.putExtra(Config.DATA_EXTRA, productList.get(position).getId());
                startActivity(intent);
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));

        rvHCM = root.findViewById(R.id.rv_hcm);
        List<DistrictSuggest> hcmSuggest = createDistrictHCMSuggests();
        adapterHCM = new DistrictSuggestAdapter(hcmSuggest);
        rvHCM.setAdapter(adapterHCM);
        rvHCM.addOnItemTouchListener(new RecyclerTouchListner(requireContext(), rvHCM, new OnRecyclerTouchListener() {
            @Override
            public void onClick(View view, int position) {
                DistrictSuggest suggest = hcmSuggest.get(position);
                Utils.launchMapView(getActivity(), suggest.getTitle() + ", TP. Hồ Chí Minh", suggest.getLatLng(), Config.UNDEFINED);
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));


        rvHN = root.findViewById(R.id.rv_hn);
        List<DistrictSuggest> hnSuggest = createDistrictHNSuggests();
        adapterHN = new DistrictSuggestAdapter(hnSuggest);
        rvHN.setAdapter(adapterHN);
        rvHN.addOnItemTouchListener(new RecyclerTouchListner(requireContext(), rvHN, new OnRecyclerTouchListener() {
            @Override
            public void onClick(View view, int position) {
                DistrictSuggest suggest = hnSuggest.get(position);
                Utils.launchMapView(getActivity(), suggest.getTitle() + ", Hà Nội", suggest.getLatLng(), Config.UNDEFINED);
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));

        TextView textView = root.findViewById(R.id.suggest_title);
        String string1 = "Nhận ngay thông tin\nbất động sản";
        String string2 = " HOT tại PHR ";
        SpannableString spannableString = new SpannableString(string1 + string2);
        spannableString.setSpan(new BackgroundColorSpan(Color.parseColor("#FEEDCC")), string1.length(), string1.length() + string2.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannableString.setSpan(new ForegroundColorSpan(Color.parseColor("#0077D5")), string1.length(), string1.length() + 4, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannableString.setSpan(new StyleSpan(Typeface.BOLD | Typeface.ITALIC), string1.length(), string1.length() + 4, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannableString.setSpan(new ForegroundColorSpan(Color.parseColor("#0077D5")), string1.length() + 8, string1.length() + string2.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannableString.setSpan(new StyleSpan(Typeface.BOLD | Typeface.ITALIC), string1.length() + 8, string1.length() + string2.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        textView.setText(spannableString, TextView.BufferType.SPANNABLE);

        TextView aiTxt = root.findViewById(R.id.ai_title);
        String text = "PHR đề xuất theo khu vực bằng AI";
        SpannableString spannableAi = new SpannableString(text);
        spannableAi.setSpan(new ForegroundColorSpan(Color.parseColor("#0077D5")), text.length() - 8, text.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        spannableString.setSpan(new StyleSpan(Typeface.BOLD | Typeface.ITALIC), text.length() - 8, text.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        aiTxt.setText(spannableAi, TextView.BufferType.SPANNABLE);

        return root;
    }

    private List<DistrictSuggest> createDistrictHNSuggests() {
        List<DistrictSuggest> hn = new ArrayList<>();
        hn.add(new DistrictSuggest(0, "Quận Ba Đình", R.drawable.q_bdinh, new LatLng(21.033825600, 105.814392200)));
        hn.add(new DistrictSuggest(1, "Quận Cầu Giấy", R.drawable.q_cgiay, new LatLng(21.030955600, 105.801087700)));
        hn.add(new DistrictSuggest(2, "Quận Đống Đa", R.drawable.q_dda, new LatLng(21.020009300, 105.830622200)));
        hn.add(new DistrictSuggest(3, "Quận Hai Bà Trưng", R.drawable.q_hbtrung, new LatLng(21.009990600, 105.849707500)));
        hn.add(new DistrictSuggest(4, "Quận Hoàng Kiếm", R.drawable.q_hkiem, new LatLng(21.028745000, 105.850717000)));
        hn.add(new DistrictSuggest(5, "Quận Hoàng Mai", R.drawable.q_hmai, new LatLng(20.968109300, 105.848415300)));
        hn.add(new DistrictSuggest(6, "Quận Thanh Xuân", R.drawable.q_txuan, new LatLng(20.994643000, 105.799816400)));
        return hn;
    }

    private List<DistrictSuggest> createDistrictHCMSuggests() {
        List<DistrictSuggest> hcm = new ArrayList<>();
        hcm.add(new DistrictSuggest(0, "Quận 1", R.drawable.q1, new LatLng(10.780640700, 106.699092600)));
        hcm.add(new DistrictSuggest(1, "Quận 3", R.drawable.q3, new LatLng(10.782868900, 106.686425100)));
        hcm.add(new DistrictSuggest(2, "Quận 4", R.drawable.q4, new LatLng(10.766533400, 106.706003300)));
        hcm.add(new DistrictSuggest(3, "Quận 5", R.drawable.q5, new LatLng(10.755863600, 106.667370800)));
        hcm.add(new DistrictSuggest(4, "Quận 7", R.drawable.q7, new LatLng(10.732338400, 106.726505200)));
        hcm.add(new DistrictSuggest(5, "Quận 10", R.drawable.q10, new LatLng(10.767627200, 106.666413500)));
        hcm.add(new DistrictSuggest(6, "Quận Bình Thạnh", R.drawable.q_bthanh, new LatLng(10.803239000, 106.696714500)));
        hcm.add(new DistrictSuggest(7, "Quận Gò Vấp", R.drawable.q_gvap, new LatLng(10.831512900, 106.669296700)));
        hcm.add(new DistrictSuggest(8, "Quận Phú Nhuận", R.drawable.q_pn, new LatLng(10.795046400, 106.676008200)));
        hcm.add(new DistrictSuggest(9, "TP Thủ Đức", R.drawable.q_tduc, new LatLng(10.848243600, 106.772226000)));
        return hcm;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        latLng = AppController.getInstance().getPrefManager().getLastLatLng();
        googleApi = new GoogleApiHelper(requireActivity());
        listener = new LocationListener() {
            @Override
            public void onLocationChanged(@NonNull Location location) {
                if (latLng != null && location.getLatitude() == latLng.latitude && location.getLongitude() == latLng.longitude)
                    return;

                latLng = new LatLng(location.getLatitude(), location.getLongitude());
            }
        };

        searchInfo = new SearchInfo(latLng.latitude, latLng.longitude, 0, Config.UNDEFINED);
        fetchProductList();

        fetchImageSliderData();
    }

    private void fetchProductList() {
        searchInfo.setPropertyID("1000");
        searchInfo.setStartLat("10.619674722094736");
        searchInfo.setStartLng("106.57988257706165");
        searchInfo.setEndLat("10.965413634575896");
        searchInfo.setEndLng("106.7968474701047");

        Map<String, String> filterSet = AppController.getInstance().getPrefManager().getFilterSet();
        searchInfo.setMinPrice(filterSet.get(Config.KEY_MIN_PRICE));
        searchInfo.setMaxPrice(filterSet.get(Config.KEY_MAX_PRICE));
        searchInfo.setMinArea(filterSet.get(Config.KEY_MIN_AREA));
        searchInfo.setMaxArea(filterSet.get(Config.KEY_MAX_AREA));
        searchInfo.setBed(filterSet.get(Config.KEY_BED));
        searchInfo.setBath(filterSet.get(Config.KEY_BATH));
        searchInfo.setStatus(String.valueOf(Config.UNDEFINED));

        ProductRequest.search(searchInfo, new OnLoadProductListener() {
            @Override
            public void onSuccess(List<Product> products, int totalItems) {
                productList.addAll(products);
                if (totalItems > 4) {
                    productList = products.subList(0, 4);
                }
                adapter.addProductList(productList);
            }

            @Override
            public void onError(VolleyError error) {
                Log.e(TAG, "Error at fetchProductList()");
                L.showToast(getString(R.string.request_time_out));
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        googleApi.registerListener(listener);
        googleApi.checkLocationSettings();
    }

    @Override
    public void onStop() {
        super.onStop();
        googleApi.removeListener(listener);
        imageSlider.stopAutoCycle();
        AppController.getInstance().cancelPedingRequesrs(TAG);
    }

    @SuppressLint("NonConstantResourceId")
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btnViewAll:
                Utils.launchMapView(getActivity(), getString(R.string.text_view_all), latLng, Config.UNDEFINED);
                break;
            case R.id.btnApartment:
                Utils.launchMapView(getActivity(), getString(R.string.text_apartment), latLng, Config.PROPERTY_APARTMENT);
                break;
            case R.id.btnRoom:
                Utils.launchMapView(getActivity(), getString(R.string.text_room), latLng, Config.PROPERTY_ROOM);
                break;
            case R.id.hot_view_all:
                Intent intent = new Intent(requireContext(), ListViewProductActivity.class);
                Bundle bundle = new Bundle();
                bundle.putString(Config.STRING_DATA, "Bất động sản HOT");
                bundle.putParcelable(Config.PARCELABLE_DATA, searchInfo);
                intent.putExtra(Config.DATA_EXTRA, bundle);
                startActivity(intent);
                break;
        }
    }

    private void fetchImageSliderData() {
        advList = new ArrayList<>();
        JsonObjectRequest reqAdv = new JsonObjectRequest(Request.Method.GET, EndPoints.URL_LIST_ADV_MAIN, null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                advList.addAll(Parser.advList(response));
                addImageSlider();
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e(TAG, "Error at fetchImageSliderData()");
            }
        });

        AppController.getInstance().addToRequestQueue(reqAdv, TAG);
    }

    private void addImageSlider() {
        imageSlider.removeAllSliders();
        for (Advertising adv : advList) {
            TextSliderView textSliderView = new TextSliderView(getActivity());
            textSliderView
                    .description(null)
                    .image(adv.getThumbnail())
                    .setScaleType(BaseSliderView.ScaleType.CenterCrop);

            imageSlider.addSlider(textSliderView);
        }

        imageSlider.setPresetTransformer(SliderLayout.Transformer.Accordion);
        imageSlider.setPresetIndicator(SliderLayout.PresetIndicators.Center_Bottom);
        imageSlider.setCustomAnimation(new ChildAnimation());
        imageSlider.setDuration(4000);
    }
}
