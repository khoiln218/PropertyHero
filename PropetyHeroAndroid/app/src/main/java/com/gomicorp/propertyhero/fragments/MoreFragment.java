package com.gomicorp.propertyhero.fragments;


import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.fragment.app.Fragment;

import com.android.volley.VolleyError;
import com.gomicorp.app.AppController;
import com.gomicorp.app.CircleTransform;
import com.gomicorp.app.Config;
import com.gomicorp.helper.L;
import com.gomicorp.propertyhero.R;
import com.gomicorp.propertyhero.activities.AboutActivity;
import com.gomicorp.propertyhero.activities.AccountDetailsActivity;
import com.gomicorp.propertyhero.activities.ContactActivity;
import com.gomicorp.propertyhero.activities.LoginActivity;
import com.gomicorp.propertyhero.activities.MainActivity;
import com.gomicorp.propertyhero.callbacks.OnAccountRequestListener;
import com.gomicorp.propertyhero.json.AccountRequest;
import com.gomicorp.propertyhero.model.Account;
import com.squareup.picasso.MemoryPolicy;
import com.squareup.picasso.NetworkPolicy;
import com.squareup.picasso.Picasso;

import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 */
public class MoreFragment extends Fragment implements View.OnClickListener {

    private static final String TAG = MoreFragment.class.getSimpleName();

    private ImageView imgAvatar;
    private TextView tvFullName, tvUserName;
    private TextView logoutBtn;
    private RelativeLayout progressLayout;

    private Account account;

    ActivityResultLauncher<Intent> loginResultLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                if (result.getResultCode() == Config.SUCCESS_RESULT) {
                    setupUI();
                }
            });

    public MoreFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View root = inflater.inflate(R.layout.fragment_more, container, false);

        imgAvatar = (ImageView) root.findViewById(R.id.imgAvatar);
        tvFullName = (TextView) root.findViewById(R.id.tvFullName);
        tvUserName = (TextView) root.findViewById(R.id.tvUserName);
        logoutBtn = root.findViewById(R.id.logoutBtn);
        progressLayout = (RelativeLayout) root.findViewById(R.id.progressLayout);

        root.findViewById(R.id.btnAccount).setOnClickListener(this);
        root.findViewById(R.id.ratingBtn).setOnClickListener(this);
        root.findViewById(R.id.emailBtn).setOnClickListener(this);
        root.findViewById(R.id.telegramBtn).setOnClickListener(this);
        root.findViewById(R.id.twitterBtn).setOnClickListener(this);
        root.findViewById(R.id.btnAbout).setOnClickListener(this);
        logoutBtn.setOnClickListener(this);

        return root;
    }

    @Override
    public void onResume() {
        super.onResume();
        if (account != null) {
            Picasso.with(getActivity())
                    .load(account.getAvatar())
                    .placeholder(R.drawable.default_avatar)
                    .transform(new CircleTransform())
                    .networkPolicy(NetworkPolicy.NO_CACHE)
                    .memoryPolicy(MemoryPolicy.NO_CACHE, MemoryPolicy.NO_STORE)
                    .into(imgAvatar);
        }
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser)
            setupUI();
    }

    private void setupUI() {
        progressLayout.setVisibility(View.VISIBLE);
        tvFullName.setText(AppController.getInstance().getPrefManager().getFullName());
        logoutBtn.setVisibility(View.VISIBLE);
        if (AppController.getInstance().getPrefManager().getUserID() != 0) {
            AccountRequest.getDetails(AppController.getInstance().getPrefManager().getUserID(), new OnAccountRequestListener() {
                @Override
                public void onSuccess(List<Account> accounts) {
                    if (accounts.size() > 0) {
                        account = accounts.get(0);
                        String userName = account.getAccType() == Config.HELLO_RENT ? account.getUserName() : account.getEmail();
                        AppController.getInstance().getPrefManager().addUserInfo(account.getId(), userName, account.getFullName(), account.getPhoneNumber(), account.getAccRole(), null);
                        tvFullName.setText(account.getFullName());
                        tvUserName.setVisibility(View.VISIBLE);
                        tvUserName.setText(account.getUserName());

                        Picasso.with(getActivity())
                                .load(account.getAvatar())
                                .placeholder(R.drawable.default_avatar)
                                .transform(new CircleTransform())
                                .networkPolicy(NetworkPolicy.NO_CACHE)
                                .memoryPolicy(MemoryPolicy.NO_CACHE, MemoryPolicy.NO_STORE)
                                .into(imgAvatar);

                        progressLayout.setVisibility(View.GONE);
                    }
                }

                @Override
                public void onError(VolleyError error) {
                    L.showToast(getString(R.string.request_time_out));
                }
            });
        } else {
            imgAvatar.setImageResource(R.drawable.vector_action_login);
            tvFullName.setText(getString(R.string.text_login));
            tvUserName.setVisibility(View.GONE);
            logoutBtn.setVisibility(View.GONE);
            progressLayout.setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnAccount) {
            if (account == null) {
                loginResultLauncher.launch(new Intent(getActivity(), LoginActivity.class));
            } else {
                Intent accDetails = new Intent(getActivity(), AccountDetailsActivity.class);
                Bundle bundle = new Bundle();
                bundle.putString(Config.AVATAR_URL, account.getAvatar());
                bundle.putInt(Config.ACCOUNT_TYPE, account.getAccType());
                accDetails.putExtra(Config.DATA_EXTRA, bundle);
                startActivity(accDetails);
            }
        } else if (id == R.id.ratingBtn) {
            final String appPackageName = requireActivity().getPackageName(); // getPackageName() from Context or Activity object
            try {
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + appPackageName)));
            } catch (ActivityNotFoundException ex) {
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + appPackageName)));
            }
        } else if (id == R.id.emailBtn) {
            startActivity(new Intent(getActivity(), ContactActivity.class));
        } else if (id == R.id.logoutBtn) {
            String userName = AppController.getInstance().getPrefManager().getUserName();
            AppController.getInstance().getPrefManager().Logout();
            AppController.getInstance().getPrefManager().addUserName(userName);
            Intent intent = new Intent(requireContext(), MainActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            requireActivity().finish();
        } else if (id == R.id.telegramBtn) {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse("https://t.me/propertyheroes"));
                startActivity(intent);
            } catch (ActivityNotFoundException e) {
                e.printStackTrace();
            }
        } else if (id == R.id.twitterBtn) {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setData(Uri.parse("https://x.com/PHR_Hero"));
                startActivity(intent);
            } catch (ActivityNotFoundException e) {
                e.printStackTrace();
            }
        } else if (id == R.id.btnAbout) {
            startActivity(new Intent(requireContext(), AboutActivity.class));
        }
    }
}
