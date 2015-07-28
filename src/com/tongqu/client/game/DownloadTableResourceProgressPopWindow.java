package com.tongqu.client.game;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.tongqu.client.lord.R;
import com.tongqu.client.utils.DownloadFollowUp;
import com.tongqu.client.utils.DownloadInfo;
import com.tongqu.client.utils.Downloader;
import com.tongqu.client.utils.Pub;

public class DownloadTableResourceProgressPopWindow extends PopupWindow implements OnClickListener {

	public static boolean haveShown = false; // 是否显示过，显示过则解压完之后要弹toast

	private Button btnClose, btnStopDownload, btnStartDownload;
	private Button btnEnterTable;
	private Context mContext;
	private TextView tvPro, tvContent;
	private Long startTime;
	private final long mnInitPosition;
	private ProgressBar pb;
	private DownloadInfo mDownloadInfo;
	private final static String downloadPauseContent = "建议您下载【真人语音资源包（1.2M）】获得最佳体验，是否下载？"; // 下载中提示
	private final static String downloadingContent = "正在帮您下载【真人语音资源包（1.2M）】，请稍候..."; // 下载暂停中提示

	public DownloadTableResourceProgressPopWindow(Context context, DownloadInfo data, long initPosition) {
		super(View.inflate(context, R.layout.hall_download_table_res_progress, null), android.widget.LinearLayout.LayoutParams.FILL_PARENT, android.widget.LinearLayout.LayoutParams.FILL_PARENT, true);
		mContext = context;
		mDownloadInfo = data;
		mnInitPosition = initPosition;
		initView();
		startTime = System.currentTimeMillis();
		handler.sendEmptyMessage(UPDATE_PROGRESS);
		haveShown = true;
		Pub.closeProgressDialog();
	}

	private void initView() {
		tvPro = (TextView) getContentView().findViewById(R.id.tvPro);
		tvContent = (TextView) getContentView().findViewById(R.id.tvContent);
		pb = (ProgressBar) getContentView().findViewById(R.id.pb);
		btnClose = (Button) getContentView().findViewById(R.id.btnClose);
		btnClose.setOnClickListener(this);
		btnStopDownload = (Button) getContentView().findViewById(R.id.btnStopDownload);
		btnStopDownload.setOnClickListener(this);
		btnStartDownload = (Button) getContentView().findViewById(R.id.btnStartDownload);
		btnStartDownload.setOnClickListener(this);
		btnEnterTable = (Button) getContentView().findViewById(R.id.btnEnterTable);
		btnEnterTable.setOnClickListener(this);

		// 非wifi情况
		if (Pub.getConnectionType() != Pub.NET_WIFI) {
			setPauseDownloadState();
		} else { // wifi
			Downloader.getInst().getDownloadFile(mDownloadInfo.getDownloadUrl(), mDownloadInfo.getFileDir(), DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_C, false, true, true);
			btnStartDownload.setVisibility(View.GONE);
			btnStopDownload.setVisibility(View.GONE);
			tvContent.setText(downloadingContent);
		}
	}

	/**
	 * 开始下载设置
	 */
	private void setStartDownloadState() {
		Downloader.getInst().getDownloadFile(mDownloadInfo.getDownloadUrl(), mDownloadInfo.getFileDir(), DownloadFollowUp.getInst().mDownloadActionHandler, DownloadFollowUp.DOWNLOAD_ACTION_C, false, true, true);
		btnStartDownload.setVisibility(View.GONE);
		btnStopDownload.setVisibility(View.VISIBLE);
		tvContent.setText(downloadingContent);
	}

	/**
	 * 停止下载设置
	 */
	private void setPauseDownloadState() {
		mDownloadInfo.setPause(true);
		btnStartDownload.setVisibility(View.VISIBLE);
		btnStopDownload.setVisibility(View.GONE);
		tvContent.setText(downloadPauseContent);
	}

	public static final int UPDATE_PROGRESS = 1;
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			super.handleMessage(msg);
			if (msg.what == UPDATE_PROGRESS) {

				handler.sendEmptyMessageDelayed(UPDATE_PROGRESS, 2000);

				long downloaded = mDownloadInfo.getDownloadSize();
				long totalsize = mDownloadInfo.getTotalSize();
				int time = (int) ((System.currentTimeMillis() - startTime) / 1000);
				if (time <= 0) {
					time = 1024;
				}
				if (downloaded == totalsize && totalsize != 0) {
					if (Downloader.getInst().isDownloadTableResourceProgressPopWindowShowing()) {
						TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
							@Override
							public void run() {
								Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LuaCallDownloadControler.mnCallBackLua, "");
								Cocos2dxLuaJavaBridge.releaseLuaFunction(LuaCallDownloadControler.mnCallBackLua);
							}
						});
					} else {
						TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() { // 不管有没有调用，都要释放一下
									@Override
									public void run() {
										Cocos2dxLuaJavaBridge.releaseLuaFunction(LuaCallDownloadControler.mnCallBackLua);
									}
								});
					}

					Toast.makeText(mContext, "资源下载已完成！", Toast.LENGTH_LONG).show();
					dismiss();
					try {
						handler.removeMessages(UPDATE_PROGRESS);
					} catch (Exception e) {
						e.printStackTrace();
					}
					return;
				}

				long speed = (downloaded - mnInitPosition) / time;
				if (speed <= 0) {
					return;
				}

				pb.setMax((int) (totalsize / 1024));
				pb.setProgress((int) (downloaded / 1024));
				tvPro.setText(downloaded + "/" + totalsize);
			}
		}
	};

	private void closePop() {
		mDownloadInfo.setShowDialog(false);
		dismiss();
		if (!mDownloadInfo.isPause() && !mDownloadInfo.isStop()) {
			mDownloadInfo.setRestriction(true);
			Toast.makeText(mContext, "资源后台下载中", Toast.LENGTH_LONG).show();
		} else {
			try {
				handler.removeMessages(UPDATE_PROGRESS);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void dismiss() {
		// TODO Auto-generated method stub
		super.dismiss();
	}

	@Override
	public void onClick(View v) {
		int vId = v.getId();
		if (vId == btnClose.getId()) {
			closePop();
		} else if (vId == btnStartDownload.getId()) {
			setStartDownloadState();
		} else if (vId == btnStopDownload.getId()) {
			setPauseDownloadState();
		} else if (vId == btnEnterTable.getId()) {
			closePop();
			if (LuaCallDownloadControler.mnCallBackLua > 0) {
				TQLuaAndroidConsole.getGameSceneInstance().runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Cocos2dxLuaJavaBridge.callLuaFunctionWithString(LuaCallDownloadControler.mnCallBackLua, "");
						Cocos2dxLuaJavaBridge.releaseLuaFunction(LuaCallDownloadControler.mnCallBackLua);
					}
				});
			}
		}
	}

}
