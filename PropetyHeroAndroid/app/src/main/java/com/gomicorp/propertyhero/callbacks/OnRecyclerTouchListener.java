package com.gomicorp.propertyhero.callbacks;

import android.view.View;

/**
 * Created by CTO-HELLOSOFT on 4/15/2016.
 */
public interface OnRecyclerTouchListener {

    void onClick(View view, int position);

    void onLongClick(View view, int position);
}
