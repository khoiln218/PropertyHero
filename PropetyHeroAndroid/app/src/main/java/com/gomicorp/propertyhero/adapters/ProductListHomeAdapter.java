package com.gomicorp.propertyhero.adapters;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.gomicorp.app.Config;
import com.gomicorp.helper.Utils;
import com.gomicorp.propertyhero.R;
import com.gomicorp.propertyhero.model.Product;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * Created by CTO-HELLOSOFT on 5/9/2016.
 */
public class ProductListHomeAdapter extends RecyclerView.Adapter {

    private List<Product> productList;

    public ProductListHomeAdapter(List<Product> productList) {
        this.productList = productList;
    }

    public void addProductList(List<Product> productList) {
        this.productList = productList;
        notifyDataSetChanged();
    }

    @Override
    public int getItemViewType(int position) {
        return productList.get(position) != null ? Config.VIEW_ITEM : Config.VIEW_PROGRESS;
    }


    @Override
    public int getItemCount() {
        return productList.size();
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RecyclerView.ViewHolder viewHolder;

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_property, parent, false);
        viewHolder = new ViewHolderProduct(view);

        return viewHolder;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int position) {
        Product product = productList.get(position);

        int width = com.gomicorp.helper.Utils.getScreenWidth() / 3;

        String imageUrl = product.getThumbnail().split(", ")[0];
        if (TextUtils.isEmpty(imageUrl)) {
            ((ViewHolderProduct) holder).thumb.setImageResource(R.drawable.emptyimg);
        } else {
            Picasso.with(holder.itemView.getContext())
                    .load(imageUrl)
                    .centerCrop()
                    .placeholder(R.drawable.emptyimg)
                    .resize(width, width)
                    .into(((ViewHolderProduct) holder).thumb);
        }

        ((ViewHolderProduct) holder).tvPrice.setText(Utils.numberToString(product.getPrice()));
        ((ViewHolderProduct) holder).tvArea.setText(Utils.numberToString(product.getGrossFloorArea()));
        String characterFilter = "[^\\p{L}\\p{M}\\p{N}\\p{P}\\p{Z}\\p{Cf}\\p{Cs}\\s]";
        String title = product.getTitle().replaceAll(characterFilter, "").trim();
        ((ViewHolderProduct) holder).tvTitle.setText(title);
        ((ViewHolderProduct) holder).tvAddress.setText(product.getAddresss());
    }

    protected class ViewHolderProduct extends RecyclerView.ViewHolder {

        ImageView thumb;
        TextView tvPrice, tvArea, tvTitle, tvAddress;

        public ViewHolderProduct(View itemView) {
            super(itemView);

            thumb = (ImageView) itemView.findViewById(R.id.thumbnail);
            tvPrice = (TextView) itemView.findViewById(R.id.tvPrice);
            tvArea = (TextView) itemView.findViewById(R.id.tvArea);
            tvTitle = (TextView) itemView.findViewById(R.id.tvTitle);
            tvAddress = (TextView) itemView.findViewById(R.id.tvAddress);
        }
    }
}
