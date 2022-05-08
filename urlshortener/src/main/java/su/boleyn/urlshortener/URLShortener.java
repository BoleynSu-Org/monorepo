package su.boleyn.urlshortener;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Scanner;
import java.util.TreeMap;

public class URLShortener {
	private Map<String, ArrayList<URLInfo>> map;
	private PrintWriter out;

	public URLShortener(String db) throws IOException {
		map = new HashMap<String, ArrayList<URLInfo>>();
		File file = new File(db);
		if (file.exists()) {
			Scanner in = new Scanner(file);
			while (in.hasNextLine()) {
				String line = in.nextLine();
				if (line.startsWith("#")) {
					continue;
				}
				String[] records = line.split("\t");
				if (records.length != 3 && records.length != 4) {
					in.close();
					throw new RuntimeException("the database is ill-formed");
				}
				URLInfo info = new URLInfo();
				info.code = URLDecoder.decode(records[0], "UTF-8");
				info.url = records[1];
				info.createdAt = new Date(Long.parseLong(records[2]));
				if (records.length == 4) {
					info.expiresAt = new Date(Long.parseLong(records[3]));
				}
				addURLInfo(info);
			}
			in.close();
		} else {
			file.createNewFile();
		}
		out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true))), true);
	}

	private String getURL(ArrayList<URLInfo> history) {
		if (history == null) {
			return null;
		} else {
			URLInfo info = history.get(history.size() - 1);
			if (info.expiresAt == null || info.expiresAt.after(new Date())) {
				return info.url;
			} else {
				return null;
			}
		}
	}

	public String getURL(String code) {
		return getURL(getHistory(code));
	}

	public ArrayList<URLInfo> getHistory(String code) {
		return map.get(code);
	}

	public Map<String, String> getAll() {
		Map<String, String> list = new TreeMap<String, String>();
		for (Entry<String, ArrayList<URLInfo>> entry : map.entrySet()) {
			String code = entry.getKey();
			String url = getURL(entry.getValue());
			if (url != null) {
				list.put(code, url);
			}
		}
		return list;
	}

	private void addURLInfo(URLInfo info) {
		if (!map.containsKey(info.code)) {
			map.put(info.code, new ArrayList<URLInfo>());
		}
		map.get(info.code).add(info);
	}

	public void shorten(URLInfo info) throws UnsupportedEncodingException {
		addURLInfo(info);
		out.println("#" + info.createdAt + "\t" + info.expiresAt);
		out.println(URLEncoder.encode(info.code, "UTF-8") + "\t" + info.url + "\t" + info.createdAt.getTime()
				+ (info.expiresAt == null ? "" : "\t" + info.expiresAt.getTime()));
	}
}
