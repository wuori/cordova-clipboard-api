package com.verso.cordova.clipboard;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.ClipboardManager;
import android.content.ClipData;
import android.content.ClipDescription;

public class Clipboard extends CordovaPlugin {

    private static final String actionCopy = "copy";
    private static final String actionPaste = "paste";
    private static final String actionClear = "clear";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        ClipboardManager clipboard = (ClipboardManager) cordova.getActivity().getSystemService(Context.CLIPBOARD_SERVICE);

        if (action.equals(actionCopy)) {

            JSONObject options = args.getJSONObject(0);
            String text = options.getString("data");
            JSONObject response = new JSONObject();
            response.put("type", "text");
            response.put("data", text);
            response.put("error", false);

            try {
                ClipData clip = ClipData.newPlainText("Text", text);

                clipboard.setPrimaryClip(clip);

                callbackContext.success((JSONObject) response);

                return true;
            } catch (Exception e) {
                response.put("error", e);
                callbackContext.success((JSONObject) response);
                //callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, e.toString()));
            }
        } else if (action.equals(actionPaste)) {

            JSONObject response = new JSONObject();
            response.put("type", "text");
            response.put("error", false);

            try {
                String text = "";

                ClipData clip = clipboard.getPrimaryClip();
                if (clip != null) {
                    ClipData.Item item = clip.getItemAt(0);
                    text = item.getText().toString();
                    response.put("data", text);
                }

                callbackContext.success((JSONObject) response);

                return true;
            } catch (Exception e) {
                response.put("data", "");
                response.put("error", e);
                callbackContext.success((JSONObject) response);
                //callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, e.toString()));
            }
        } else if (action.equals(actionClear)) {
            try {
                ClipData clip = ClipData.newPlainText("", "");
                clipboard.setPrimaryClip(clip);

                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));

                return true;
            } catch (Exception e) {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, e.toString()));
            }
        }

        return false;
    }
}


