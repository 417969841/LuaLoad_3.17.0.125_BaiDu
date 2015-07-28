package com.tongqu.client.game;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.KeyguardManager;
import android.app.KeyguardManager.KeyguardLock;
import android.app.Service;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.os.Vibrator;
import android.view.KeyEvent;

import com.tongqu.client.lord.R;
import com.tongqu.client.utils.Pub;

public class MatchAlarmPromptActivity extends Activity {

	private Bundle bundle;
	private Context context;
	private PowerManager pm;
	private MediaPlayer ring;
	private Uri notification;
	private boolean click;
	private AlertDialog mAlertDialog;
	private AudioManager am;
	private int current;
	private Vibrator vibrator;
	private String matchtitle;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		Pub.LOG("MatchAlarmPrompt1Activity onCreate");
		setContentView(R.layout.match_alarm_prompt);
		context = this;
		turnOnScreen();
		playRing();
		vibrator = (Vibrator) getApplication().getSystemService(Service.VIBRATOR_SERVICE);
		vibrator.vibrate(new long[] { 100, 10, 100, 1000 }, 0);

		bundle = getIntent().getExtras();
		matchtitle = bundle.getString("matchtitle");
		bundle.remove("matchtitle");
		String title = "";
		String content = "";
		if (bundle.getInt("matchid") == 0 && matchtitle == null) {
			title = "登陆提醒";
			content = "亲，赶快登录【" + context.getResources().getString(R.string.app_name) + "】领取奖励赢奖品吧！";
		} else {
			title = "同趣游戏提示";
			content = "您报名的“" + matchtitle + "”还有2分钟就要开始了，请赶快进入！";
		}

		AlertDialog.Builder alertbBuilder = new AlertDialog.Builder(this);
		alertbBuilder.setTitle(title).setMessage(content).setIcon(R.drawable.icon).setPositiveButton("启动游戏", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				click = true;
				Intent intent = null;
				if (TQLuaAndroidConsole.getGameSceneInstance() != null) {
					intent = new Intent(MatchAlarmPromptActivity.this, TQLuaAndroidConsole.getGameMainSceneClass());
				} else {
					intent = new Intent(MatchAlarmPromptActivity.this, TQLuaAndroidConsole.getLoadActivityClass());
				}
				// if (bundle.getInt("matchid") == 0 && matchtitle == null) {
				//
				// } else {
				// MatchListActivity.isAlarmStartMatch = true;
				// bundle.putInt("startmode", 1);// 启动比赛列表
				// intent.putExtras(bundle);
				// }
				startActivity(intent);

				try {
					dialog.dismiss();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				handler.sendEmptyMessage(100);
			}
		}).setNegativeButton("取消", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				click = true;
				try {
					dialog.dismiss();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				handler.sendEmptyMessage(101);
			}
		}).create();
		alertbBuilder.setCancelable(false);
		alertbBuilder.show();
		// MatchListActivity.alarmStartMatchPop = new
		// AlarmStartMatchPromptPopWindow(TQUtilsConfig.getInstance().getApplication());
		// MatchListActivity.alarmStartMatchPop.startTimer(matchtitle);

		new Thread() {
			int n = 0;

			public void run() {
				while (!click) {
					if (n > 300) {
						handler.sendEmptyMessage(101);
					}

					try {
						Thread.sleep(100);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					n++;
				}
			}
		}.start();

	}

	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			super.handleMessage(msg);
			if (ring != null) {
				ring.stop();
				ring.release();
				ring = null;
			}
			am.setStreamVolume(AudioManager.STREAM_MUSIC, current, 0);
			vibrator.cancel();
			MatchAlarmPromptActivity.this.finish();
			if (msg.what == 101) {
				relase();
				System.exit(0);
			}
		}
	};

	private PowerManager.WakeLock wl;

	private void turnOnScreen() {
		Pub.LOG("比赛闹钟，点亮屏幕");
		pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
		boolean isScreenOn = pm.isScreenOn();
		Pub.LOG("isScreenOn =" + isScreenOn);
		if (!isScreenOn) {
			wl = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP | PowerManager.ON_AFTER_RELEASE, "RC_Alert_reLight");
		} else {
			wl = pm.newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK, "RC_Alert_");
		}
		wl.acquire();

		KeyguardManager km = (KeyguardManager) getSystemService(Context.KEYGUARD_SERVICE);
		boolean isKeyguardLocked = km.inKeyguardRestrictedInputMode();
		Pub.LOG("isKeyguardLocked =" + isKeyguardLocked);
		if (isKeyguardLocked) {
			KeyguardLock kl = km.newKeyguardLock("unLock");
			kl.disableKeyguard();
		}
	}

	public void onStop() {
		super.onStop();
	}

	private void playRing() {
		Pub.LOG("比赛闹钟，播放声音");
		am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
		current = am.getStreamVolume(AudioManager.STREAM_MUSIC);
		int max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		am.setStreamVolume(AudioManager.STREAM_MUSIC, max * 1 / 3, 0);
		notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);
		ring = MediaPlayer.create(context, notification);
		if (ring == null) {
			Pub.LOG("ring=" + ring);
			return;
		}
		ring.setAudioStreamType(AudioManager.STREAM_MUSIC);
		ring.setLooping(true);
		ring.start();
	}

	// private Uri getDefaultRingtoneUri(int type) {
	// try {
	// return RingtoneManager.getActualDefaultRingtoneUri(context, type);
	// } catch (Exception e) {
	// return null;
	// }
	// }

	public void relase() {
		if (null != wl && pm.isScreenOn()) {
			wl.release();
			wl = null;
		}
	}

}
