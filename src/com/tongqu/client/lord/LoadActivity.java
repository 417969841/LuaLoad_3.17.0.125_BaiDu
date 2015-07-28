package com.tongqu.client.lord;

import java.io.DataOutputStream;
import java.io.IOException;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.Intent.ShortcutIconResource;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.tongqu.client.game.DownLoadService;
import com.tongqu.client.game.TQGameAndroidBridge;
import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.FilesUtil;
import com.tongqu.client.utils.Pub;


public class LoadActivity extends Activity {

	ProgressBar progressBar;
	TextView tvPro, tvProgress, tvTips;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.hall_load_script);
		progressBar = (ProgressBar) findViewById(R.id.asyncTaskProgress);
		// tvPro = (TextView) findViewById(R.id.tv_Pro);
		tvProgress = (TextView) findViewById(R.id.tv_Progress);
		tvTips = (TextView) findViewById(R.id.tv_tips);

		Intent serviceIntent = new Intent(this, DownLoadService.class);
		this.stopService(serviceIntent);

		// 读取数据
		if (FilesUtil.getInstance().fileOpen(FilesUtil.READ, "shortcut.data")) {// 有存档
			FilesUtil.getInstance().fileClose();
		} else {
			Pub.LOG("第一次启动");
			if (!IfaddShortCut()) {
				addShortcut();
			}
			if (FilesUtil.getInstance().fileOpen(FilesUtil.WRITE, "shortcut.data")) {
				DataOutputStream os = FilesUtil.getInstance().dataOut;
				WriteData(os);
				FilesUtil.getInstance().fileClose();
			}
			TQGameAndroidBridge.getInstance().deleteScriptVersion();
		}

		Intent intent = new Intent(LoadActivity.this, BaiDuBaseActivity.class);
		startActivity(intent);
		finish();


	}

	public void WriteData(DataOutputStream is) {
		try {
			is.writeInt(1);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 判断是否有快捷方式
	 *
	 * @return
	 */
	public boolean IfaddShortCut() {
		boolean isInstallShortcut = false;
		final ContentResolver cr = getContentResolver();
		// 本人的2.2系统是”com.android.launcher2.settings”,网上见其他的为"com.android.launcher.settings"
		String AUTHORITY = "com.android.launcher.settings";
		Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY + "/favorites?notify=true");
		Cursor c = null;
		try {
			c = cr.query(CONTENT_URI, new String[] { "title", "iconResource" }, "title=?", new String[] { getResources().getString(R.string.app_name) }, null);// XXX表示应用名称
		} catch (Exception e) {
			if (c != null) {
				c.close();
			}
			return true;
		}

		if (c != null && c.getCount() > 0) {
			isInstallShortcut = true;
			// System.out.println("已创建");
			c.close();
		}

		return isInstallShortcut;
	}

	/**
	 * 为程序创建桌面快捷方式
	 */
	private void addShortcut() {
		Intent shortcut = new Intent("com.android.launcher.action.INSTALL_SHORTCUT");

		// 快捷方式的名称
		shortcut.putExtra(Intent.EXTRA_SHORTCUT_NAME, getResources().getString(R.string.app_name));
		shortcut.putExtra("duplicate", false); // 不允许重复创建

		// 是否允许重复创建
		Intent intent = new Intent(Intent.ACTION_MAIN);
		intent.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
		intent.addFlags(Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY);
		intent.addCategory(Intent.CATEGORY_LAUNCHER);
		intent.setClass(this, TQLuaAndroidConsole.getLoadActivityClass());
		// 设置启动程序
		shortcut.putExtra(Intent.EXTRA_SHORTCUT_INTENT, intent);

		// 快捷方式的图标
		ShortcutIconResource iconRes = Intent.ShortcutIconResource.fromContext(this, R.drawable.icon);
		shortcut.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, iconRes);

		sendBroadcast(shortcut);
	}

	/**
	 * 解压下载的zip包
	 */
	public void unZipScript() {
		// File zipFile = new File(TQLuaAndroidConsole.getGameSceneInstance().getZipFilePath() +
		// TQLuaAndroidConsole.getGameSceneInstance().ScriptZipName);
		// if (zipFile.exists()) {
		// // 如果有zip包，则解压
		// UnzipAsyncTask task = new UnzipAsyncTask(LoadActivity.this,
		// TQLuaAndroidConsole.getGameSceneInstance().getZipFilePath() + TQLuaAndroidConsole.getGameSceneInstance().ScriptZipName,
		// TQLuaAndroidConsole.getGameSceneInstance().getScriptFilePath(), mLoadhandler);
		// task.execute();
		// }
	}

	long downloaded = 0;// 已下载文件大小
	long totalsize = 0;// 文件总大小
	long mnInitPosition = 0;// 文件初始大小

	public static final int UNZIP_SUCCESS = 1;// 解压完成

	Handler mLoadhandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			super.handleMessage(msg);
			switch (msg.what) {
			case UNZIP_SUCCESS:
				// 解压完成
				// logicScriptLoad();
				break;
			default:
				break;
			}
		}
	};
}