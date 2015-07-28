package com.tongqu.client.entity;

import java.io.File;

import com.tongqu.client.game.TQGameAndroidBridge;
import com.tongqu.client.utils.Pub;

/**
 * 每个lua升级包都是两个文件组成：zip升级文件，del文件列表
 */
public class LuaUpdateInfo {
	public String zipUrl;// lua脚本的zip包
	public String delUrl;// 升级lua时需要删除的文件列表
	public int callback;// 下载完成之后的lua回调
	public boolean restart;// 是否需要重启

	/**
	 * 获取zip文件名
	 *
	 * @return
	 */
	public String getZipFileName() {
		return Pub.getFileNameFromUrl(zipUrl);
	}

	/**
	 * 获取del文件名
	 *
	 * @return
	 */
	public String getDelFileName() {
		return Pub.getFileNameFromUrl(delUrl);
	}

	/**
	 * 是否下载完成zip
	 *
	 * @return
	 */
	public boolean isDownloadZip() {
		boolean ZipIsDown = false;
		File f = new File(TQGameAndroidBridge.getZipFilePath());
		if (f.exists()) {
			String[] fileName = f.list();
			for (int i = 0; i < fileName.length; i++) {
				if (Pub.getFileSuffix(fileName[i]).equals(".zip") && fileName[i].equals(getZipFileName())) {
					ZipIsDown = true;
					break;
				}
			}
		}
		return ZipIsDown;
	}

	/**
	 * 是否下载完成del
	 *
	 * @return
	 */
	public boolean isDownloadDel() {
		boolean DatIsDown = false;
		File f = new File(TQGameAndroidBridge.getZipFilePath());
		if (f.exists()) {
			String[] fileName = f.list();
			for (int i = 0; i < fileName.length; i++) {
				if (Pub.getFileSuffix(fileName[i]).equals(".dat") && fileName[i].equals(getDelFileName())) {
					DatIsDown = true;
					break;
				}
			}
		}
		return DatIsDown;
	}
}
