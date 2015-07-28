package com.tongqu.client.game;

import android.content.Context;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.tongqu.client.lord.R;

public class HallUpdataPopWindow extends PopupWindow {

	private ImageButton leftBtn, rightBtn;
	private Context mContext;
	private TextView tv_updata_top, tv_updata_down, tv_updata_award;

	private String msUpdateTxt = "";
	private String msUpdataAwardTxt = "";
	private String msUpdateAppSizeTxt = "";
	private String msDownUrl = "";
	private boolean mbForceUpdate;

	public HallUpdataPopWindow(Context context, boolean bForceUpdate, String updateTxt, String updataAwardTxt, String updateAppSizeTxt, String url) {
		super(View.inflate(context, R.layout.hall_updata, null), android.widget.LinearLayout.LayoutParams.FILL_PARENT, android.widget.LinearLayout.LayoutParams.FILL_PARENT, true);
		mContext = context;
		mbForceUpdate = bForceUpdate;
		msUpdateTxt = updateTxt;
		msUpdataAwardTxt = updataAwardTxt;
		msUpdateAppSizeTxt = updateAppSizeTxt;
		msDownUrl = url;
		initView();
	}

	private void initView() {
		tv_updata_top = (TextView) getContentView().findViewById(R.id.tv_updata_top);
		tv_updata_down = (TextView) getContentView().findViewById(R.id.tv_updata_down);
		tv_updata_award = (TextView) getContentView().findViewById(R.id.tv_updata_award);
		tv_updata_award.setText(Html.fromHtml(msUpdataAwardTxt));
		tv_updata_top.setText(Html.fromHtml(msUpdateAppSizeTxt));
		tv_updata_down.setText(msUpdateTxt);

		leftBtn = (ImageButton) getContentView().findViewById(R.id.btn_left);
		leftBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				TQGameAndroidBridge.startBackgroundDownlord(TQLuaAndroidConsole.getGameSceneInstance().UPDATA_BACKGROUND_DOWNLORD, msDownUrl);
				if (mbForceUpdate) {
					TQLuaAndroidConsole.getGameSceneInstance().finish();
				}
				dismiss();
			}
		});
		rightBtn = (ImageButton) getContentView().findViewById(R.id.btn_right);
		rightBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				TQGameAndroidBridge.startBackgroundDownlord(TQLuaAndroidConsole.getGameSceneInstance().UPDATA_DOWNLORD, msDownUrl);
				dismiss();
			}
		});
	}
}
