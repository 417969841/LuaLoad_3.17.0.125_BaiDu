package com.tongqu.client.game;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.tongqu.client.lord.R;
import com.tongqu.client.utils.DownloadInfo;

public class DownloadProgressPopWindow extends PopupWindow {

	private ImageButton btnClose, btnStop;
	private Context mContext;
	private TextView tvProgress, tvPro, tvUpdateMsg;
	private Long startTime;
	private final long mnInitPosition;
	private ProgressBar pb;
	private Dialog dialog;
	private DownloadInfo mDownloadInfo;

	public DownloadProgressPopWindow(Context context, DownloadInfo data, long initPosition) {
		super(View.inflate(context, R.layout.hall_download_progress, null), android.widget.LinearLayout.LayoutParams.FILL_PARENT, android.widget.LinearLayout.LayoutParams.FILL_PARENT, true);
		// setBackgroundDrawable(new BitmapDrawable());
		// setOutsideTouchable(true);
		mContext = context;
		mDownloadInfo = data;
		mnInitPosition = initPosition;
		// tvProgress = (TextView)
		// getContentView().findViewById(R.id.tvProgress);
		tvPro = (TextView) getContentView().findViewById(R.id.tvPro);
		tvUpdateMsg = (TextView) getContentView().findViewById(R.id.tvUpdateMsg);
		pb = (ProgressBar) getContentView().findViewById(R.id.pb);

		if (LuaCallDownloadControler.DownloadTips != "") {
			// 如果提示语不为空,显示DownloadTips, 否则,显示默认的
			tvUpdateMsg.setText(LuaCallDownloadControler.DownloadTips);
		}
		btnClose = (ImageButton) getContentView().findViewById(R.id.btnClose);
		btnClose.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				mDownloadInfo.setShowDialog(false);
				dismiss();
				Toast.makeText(mContext, "资源后台更新", Toast.LENGTH_LONG).show();
			}
		});
		btnStop = (ImageButton) getContentView().findViewById(R.id.btnStop);
		btnStop.setOnClickListener(new OnClickListener() {
			public void onClick(View v) {
				if (dialog == null) {
					dialog = new AlertDialog.Builder(mContext).setTitle("系统提示").setMessage("是否取消当前下载？").setPositiveButton("停止", new DialogInterface.OnClickListener() {

						@Override
						public void onClick(DialogInterface dialog, int which) {
							// TODO Auto-generated method stub
							mDownloadInfo.setStop(true);
							dismiss();
							Toast.makeText(mContext, "资源更新已取消", Toast.LENGTH_LONG).show();
						}
					}).setNegativeButton("返回", null).create();
				}
				if (!dialog.isShowing()) {
					dialog.show();
				}
			}
		});
		startTime = System.currentTimeMillis();
		handler.sendEmptyMessage(UPDATE_PROGRESS);
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
				if (downloaded == totalsize) {
					dismiss();
					Toast.makeText(mContext, "资源更新已完成！", Toast.LENGTH_LONG).show();
					return;
				}

				long speed = (downloaded - mnInitPosition) / time;
				if (speed <= 0) {
					return;
				}

				pb.setMax((int) (totalsize / 1024));
				pb.setProgress((int) (downloaded / 1024));
				tvPro.setText((downloaded * 100 / totalsize) + "%");

				int seconds = (int) ((totalsize - downloaded) / speed);
				if (seconds > 3000 || seconds < 0) {
					return;
				}
				int minute = seconds / 60;
				int second = seconds % 60;

				// tvProgress.setText("预计剩余时间" + minute + "分" + second + "秒！");
			}
		}
	};

	@Override
	public void dismiss() {
		// TODO Auto-generated method stub
		super.dismiss();
		try {
			handler.removeMessages(UPDATE_PROGRESS);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
