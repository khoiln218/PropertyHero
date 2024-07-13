package com.gomicorp.propertyhero.adapters;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.gomicorp.propertyhero.R;
import com.gomicorp.propertyhero.model.DistrictSuggest;

import java.util.List;

/**
 * Created by CTO-HELLOSOFT on 5/9/2016.
 */
public class DistrictSuggestAdapter extends RecyclerView.Adapter {

    private final List<DistrictSuggest> districtSuggests;

    public DistrictSuggestAdapter(List<DistrictSuggest> districtSuggests) {
        this.districtSuggests = districtSuggests;
    }

    @Override
    public int getItemCount() {
        return districtSuggests.size();
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolder;

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_district_home, parent, false);
        viewHolder = new ViewHolderProduct(view);

        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        DistrictSuggest districtSuggest = districtSuggests.get(position);
        ((ViewHolderProduct) holder).thumb.setImageResource(districtSuggest.getImgRes());
        ((ViewHolderProduct) holder).tvTitle.setText(districtSuggest.getTitle());
    }

    protected static class ViewHolderProduct extends RecyclerView.ViewHolder {

        ImageView thumb;
        TextView tvTitle;

        public ViewHolderProduct(View itemView) {
            super(itemView);

            thumb = (ImageView) itemView.findViewById(R.id.thumbnail);
            tvTitle = (TextView) itemView.findViewById(R.id.title);
        }
    }
}
