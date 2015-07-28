package com.tongqu.client.unzip;

import java.net.URL;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.tongqu.client.game.TQLuaAndroidConsole;
import com.tongqu.client.utils.Pub;

public class UnzipAsyncTaskForLua extends AsyncTask<URL, Integer, String> {
	private int count = 0;
	private UnzipCallBack callBack;
	private String zipFilePath;// 解压文件路径
	private String targetFileDir;// 解压文件目标文件夹路径
	private Handler mnCallBack;// 解压完成后的回调

	public UnzipAsyncTaskForLua(String zipPath, String targetPath, Handler callBack) {
		zipFilePath = zipPath;
		targetFileDir = targetPath;
		mnCallBack = callBack;
	}

	@Override
	protected void onPreExecute() {
		super.onPreExecute();

		callBack = new UnzipCallBack() {

			@Override
			public void run(int max, int progress) {
				count = max;
				publishProgress(progress);
			}
		};
	}

	@Override
	protected String doInBackground(URL... params) {
		String ret = null;
		int result = ZipTool.unzip(zipFilePath, targetFileDir, callBack);
		Pub.LOG("result ===================== " + result);
		ret = "Finished AsyncTask";
		return ret;
	}

	@Override
	protected void onProgressUpdate(Integer... values) {
		super.onProgressUpdate(values);
		// progress.setMax(count);
		// progress.setProgress(values[0]);
		// tvPro.setText(((values[0] * 100) / count) + "%");
		// tvTips.setText("版本更新中..." + ((values[0] * 100) / count) + "%");
		Message msg = new Message();
		msg.what = TQLuaAndroidConsole.getGameSceneInstance().UNZIP_PROGRESS_UPDATE;
		Bundle bundle = new Bundle();

		bundle.putInt("max", count);
		bundle.putInt("Progress", values[0]);
		msg.setData(bundle);// mes利用Bundle传递数据

		mnCallBack.sendMessage(msg);
	}

	@Override
	protected void onPostExecute(String result) {
		super.onPostExecute(result);
		mnCallBack.sendEmptyMessage(TQLuaAndroidConsole.getGameSceneInstance().UNZIP_SUCCESS);
	}
}
