package com.tongqu.client.utils.res;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Random;

import android.content.Context;

/**
 * 当没有存储卡时，缓存管理
 */
public class NullDiskCache implements DiskCache {
	private static final String TAG = "NullDiskCache";
	// private static final int MIN_FILE_SIZE_IN_BYTES = 100;

	private File mFilesCache;

	public NullDiskCache(Context context, String dirPath, String name) {
		// Lets make sure we can actually cache things!
		File baseDirectory = new File(context.getFilesDir().getAbsolutePath(), dirPath);

		File storageDirectory = new File(baseDirectory, name);
		createDirectory(storageDirectory);
		mFilesCache = storageDirectory;
		cleanupSimple();
		// clear();
	}

	/*
     * 
     * 
     */
	@Override
	public boolean exists(String key) {
		return getFile(key).exists();
	}

	public File getFile(String hash) {
		// Pub.LOG("filepath............:"+mFilesCache.toString() +
		// File.separator + hash);
		return new File(mFilesCache.toString() + File.separator + hash);
	}

	public InputStream getInputStream(String hash) throws IOException {
		if (exists(hash))
			return (InputStream) new FileInputStream(getFile(hash));
		else
			return null;
	}

	public void store(String key, InputStream is) {
		// Pub.LOG("store....path:"+getFile(key).getPath());
		is = new BufferedInputStream(is);
		FileOutputStream fos = null;
		OutputStream os = null;
		try {
			fos = new FileOutputStream(getFile(key));
			os = new BufferedOutputStream(fos);
			byte[] b = new byte[2048];
			int count;
			int total = 0;

			while ((count = is.read(b)) > 0) {
				os.write(b, 0, count);
				total += count;
			}

		} catch (IOException e) {
			return;
		} finally {
			try {
				if (os != null) {
					os.close();
					os = null;
				}
				if (fos != null) {
					fos.close();
					fos = null;
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void invalidate(String key) {
		// getFile(key).delete();
	}

	/**
	 * 存储的文件过多，随机删除其中的20个文件
	 * 
	 */
	public void cleanupSimple() {
		final int maxNumFiles = 500;
		final int delNumFiles = 20;
		String[] children = mFilesCache.list();

		if (children != null) {

			if (children.length > maxNumFiles) {
				Random random = new Random();
				int length = children.length;
				int interval = 0;
				if (length > 0) {
					interval = Math.abs(random.nextInt()) % length;
				}
				for (int i = 0; i < delNumFiles; i++) {
					int index = (interval + i) % maxNumFiles;
					File child = new File(mFilesCache, children[index]);
					child.delete();

				}
			}
		}
	}

	/*
	 * 
	 * 将缓存中的文件全部删除
	 */
	public void clear() {
		String[] children = mFilesCache.list();
		if (children != null) { // children will be null if hte directyr does
			// not exist.
			for (int i = 0; i < children.length; i++) {
				File child = new File(mFilesCache, children[i]);
				child.delete();
			}
		}
		// mFilesCache.delete();//暂时不删除目录
	}

	/*
	 * 建立存储目录
	 */
	private static final void createDirectory(File storageDirectory) {
		if (!storageDirectory.exists()) {
			storageDirectory.mkdirs();
		}
	}

	@Override
	public void cleanup() {
		// TODO Auto-generated method stub

	}

}
