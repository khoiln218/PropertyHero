package com.gomicorp.propertyhero;

import com.gomicorp.app.AppController;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.translate.Translate;
import com.google.cloud.translate.TranslateOptions;
import com.google.cloud.translate.Translation;

import java.io.IOException;
import java.io.InputStream;

public class TranslateService {
    private static volatile TranslateService INSTANCE;

    private Translate translate;

    private TranslateService() {
        try {
            InputStream inputStream = AppController.getInstance().getResources().openRawResource(R.raw.service_key);

            // Tạo đối tượng Translate với thông tin xác thực từ JSON
            translate = TranslateOptions.newBuilder()
                    .setCredentials(GoogleCredentials.fromStream(inputStream))
                    .build()
                    .getService();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static synchronized TranslateService getInstance() {
        if (INSTANCE == null) {
            return new TranslateService();
        }
        return INSTANCE;
    }

    public String translateText(String text, String sourceLanguage, String targetLanguage) {
        Translation translation = translate.translate(
                text.replaceAll("\n", "<br>"),
                Translate.TranslateOption.sourceLanguage(sourceLanguage),
                Translate.TranslateOption.targetLanguage(targetLanguage),
                Translate.TranslateOption.format("html")
        );
        return translation.getTranslatedText().replaceAll("<br>", "\n");
    }

    public interface OnTranslation {
        void onResult(String text);
    }
}