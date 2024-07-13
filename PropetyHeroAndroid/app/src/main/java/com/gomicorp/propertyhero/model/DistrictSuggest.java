package com.gomicorp.propertyhero.model;

import com.google.android.gms.maps.model.LatLng;

public class DistrictSuggest {
    private int id;
    private String title;
    private int imgRes;
    private LatLng latLng;

    public DistrictSuggest(int id, String title, int imgRes, LatLng latLng) {
        this.id = id;
        this.title = title;
        this.imgRes = imgRes;
        this.latLng = latLng;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getImgRes() {
        return imgRes;
    }

    public void setImgRes(int imgRes) {
        this.imgRes = imgRes;
    }

    public LatLng getLatLng() {
        return latLng;
    }

    public void setLatLng(LatLng latLng) {
        this.latLng = latLng;
    }
}
