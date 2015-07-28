package com.tongqu.client.unzip;


//public class UnzipAsyncTask extends AsyncTask<URL, Integer, String> {
//	private final Activity activity;
//	TextView tvPro, tvProgress, tvTips;
//	private ProgressBar progress;
//	private int count = 0;
//	private UnzipCallBack callBack;
//	private String zipFilePath;// 解压文件路径
//	private String targetFileDir;// 解压文件目标文件夹路径
//	private Handler mnCallBack;// 解压完成后的回调
//
//	private long StartTime = 0;
//
//	public UnzipAsyncTask(Activity activity, String zipPath, String targetPath, Handler callBack) {
//		this.activity = activity;
//		zipFilePath = zipPath;
//		targetFileDir = targetPath;
//		mnCallBack = callBack;
//	}
//
//	@Override
//	protected void onPreExecute() {
//		super.onPreExecute();
//		progress = (ProgressBar) activity.findViewById(R.id.asyncTaskProgress);
//		tvPro = (TextView) activity.findViewById(R.id.tv_Pro);
//		tvProgress = (TextView) activity.findViewById(R.id.tv_Progress);
//		tvTips = (TextView) activity.findViewById(R.id.tv_tips);
//		progress.setVisibility(View.VISIBLE);
//		tvPro.setVisibility(View.VISIBLE);
//		tvProgress.setVisibility(View.INVISIBLE);
//
//		callBack = new UnzipCallBack() {
//
//			@Override
//			public void run(int max, int progress) {
//				count = max;
//				publishProgress(progress);
//			}
//		};
//	}
//
//	@Override
//	protected String doInBackground(URL... params) {
//		String ret = null;
//		StartTime = System.currentTimeMillis();
//		int result = ZipTool.unzip(zipFilePath, targetFileDir, callBack);
//		Log.i("result ===================== ", "" + result);
//		ret = "Finished AsyncTask";
//		return ret;
//	}
//
//	@Override
//	protected void onProgressUpdate(Integer... values) {
//		super.onProgressUpdate(values);
//		progress.setMax(count);
//		progress.setProgress(values[0]);
//		tvPro.setText(((values[0] * 100) / count) + "%");
//		tvTips.setText("版本更新中..." + ((values[0] * 100) / count) + "%");
//	}
//
//	@Override
//	protected void onPostExecute(String result) {
//		super.onPostExecute(result);
//		// mnCallBack.sendEmptyMessage(LoadActivity.UNZIP_SUCCESS);
//	}
//}
