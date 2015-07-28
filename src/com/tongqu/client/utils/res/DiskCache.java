package com.tongqu.client.utils.res;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

/**
 *本地存储缓存管理接口
 */
public interface DiskCache 
{

    public boolean exists(String key);

    public File getFile(String key);

    public InputStream getInputStream(String key) throws IOException;

    public void store(String key, InputStream is);

    public void invalidate(String key);

    public void cleanup();

    public void clear();

}
