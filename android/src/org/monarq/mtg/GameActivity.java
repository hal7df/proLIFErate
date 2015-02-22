package org.monarq.mtg.activities;

import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;

import android.content.Context;
import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;

import android.graphics.Color;

import android.view.Window;
import android.view.WindowManager;

import android.util.Log;

import org.qtproject.qt5.android.bindings.QtActivity;

public class GameActivity extends QtActivity
{
  public static GameActivity s_activity = null;
  public static PowerManager pm = null;
  public static PowerManager.WakeLock wl = null;
  
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    s_activity = this;
    setTitleBar();
    acquireWakeLock();
    super.onCreate(savedInstanceState);
  }
  
  @Override
  public void onDestroy()
  {
    super.onDestroy();
    s_activity = null;
    wl.release();
    Log.d("GameActivity","Released wake lock");
  }

  public void setTitleBar() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
    {
      Log.d("GameActivity","Setting status bar color");
      getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
      getWindow().setStatusBarColor(Color.argb(255,204,0,0));
      getWindow().setNavigationBarColor(Color.argb(255,255,68,68));
    }
  }

  public void acquireWakeLock() {
    pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
    wl = pm.newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK, "Game WakeLock");
    wl.acquire();
    Log.d("GameActivity","Acquired wake lock");
  }
}
