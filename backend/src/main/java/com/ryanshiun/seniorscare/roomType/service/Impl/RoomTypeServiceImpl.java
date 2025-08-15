package com.ryanshiun.seniorscare.roomType.service.Impl;

import com.ryanshiun.seniorscare.roomType.dao.RoomTypeDao;
import com.ryanshiun.seniorscare.roomType.dto.RoomTypeForm;
import com.ryanshiun.seniorscare.roomType.model.RoomType;
import com.ryanshiun.seniorscare.roomType.service.RoomTypeService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.*;

@Service
public class RoomTypeServiceImpl implements RoomTypeService {

    private final RoomTypeDao dao;

    public RoomTypeServiceImpl(RoomTypeDao dao) {
        this.dao = dao;
    }

    // ====== C ======
    @Override
    public Integer addRoomType(RoomType room) {
        return dao.insert(room); // 對齊你的 DAO
    }

    /** 新增：用表單建（不含圖片處理） */
    @Override
    public Integer addRoomType(RoomTypeForm form) {
        RoomType r = new RoomType();
        r.setName(form.getName());
        r.setPrice(form.getPrice() == null ? 0 : form.getPrice());
        r.setCapacity(form.getCapacity() == null ? 0 : form.getCapacity());
        r.setDescription(form.getDescription());
        r.setAvailable(Boolean.TRUE.equals(form.getIsAvailable()));
        r.setAdminNote(form.getAdminNote());
        return dao.insert(r);
    }

    @Override
    public Integer addRoomWithImage(RoomTypeForm form) {
        RoomType r = new RoomType();
        r.setName(form.getName());
        r.setPrice(form.getPrice() == null ? 0 : form.getPrice());
        r.setCapacity(form.getCapacity() == null ? 0 : form.getCapacity());
        r.setDescription(form.getDescription());
        r.setAvailable(Boolean.TRUE.equals(form.getIsAvailable()));
        r.setAdminNote(form.getAdminNote());

        String imagePath = resolveImagePathFromForm(form);
        if (imagePath != null && !imagePath.isBlank()) {
            r.setImagePath(imagePath);
        }
        return dao.insert(r);
    }

    // ====== R ======
    @Override
    @Transactional(readOnly = true)
    public List<RoomType> getAllRoomTypes() {
        return dao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public RoomType getRoomTypeById(int id) {
        return dao.findById(id);
    }

    // ====== U / D ======
    @Override
    public boolean updateRoomType(RoomType room) {
        return dao.update(room);
    }

    @Override
    public boolean deleteRoomType(int id) {
        return dao.delete(id);
    }

    // ====== Queries ======
    @Override
    @Transactional(readOnly = true)
    public List<RoomType> getRoomTypesByPriceRange(int min, int max) {
        return dao.findByPriceRange(min, max);
    }

    @Override
    @Transactional(readOnly = true)
    public List<RoomType> getRoomTypesByDescriptionKeyword(String keyword) {
        return dao.findByKeyword(keyword);
    }

    @Override
    @Transactional(readOnly = true)
    public List<RoomType> getRoomTypesByCapacity(int capacity) {
        return dao.findByCapacity(capacity);
    }

    // ====== Pagination ======
    @Override
    @Transactional(readOnly = true)
    public List<RoomType> getRoomTypesPaged(int page, int size) {
        int offset = Math.max((page - 1), 0) * Math.max(size, 1);
        return dao.findPaged(offset, size);
    }

    @Override
    @Transactional(readOnly = true)
    public int countAllRoomTypes() {
        return dao.countAll();
    }

    // ====== CSV (path) ======
    @Override
    public void importRoomTypesFromCSV(String csvPath) {
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(new FileInputStream(csvPath), StandardCharsets.UTF_8))) {
            importCsvBuffered(br);
        } catch (IOException e) {
            throw new RuntimeException("Import CSV failed: " + e.getMessage(), e);
        }
    }

    // ====== CSV Export (writer) ======
    @Override
    @Transactional(readOnly = true)
    public void exportToCSV(PrintWriter writer) {
        // 保持你原先欄位順序（若無 special_features，該欄位會輸出空字串）
        writer.println("id,name,price,capacity,description,special_features,imagePath,isAvailable,adminNote,createdAt,updatedAt");
        for (RoomType r : dao.findAll()) {
            writer.println(String.join(",",
                    csv(r.getId()),
                    csv(r.getName()),
                    csv(r.getPrice()),
                    csv(r.getCapacity()),
                    csv(r.getDescription()),
                    csv(""), // special_features 若無欄位，填空
                    csv(r.getImagePath()),
                    csv(r.isAvailable()),
                    csv(r.getAdminNote()),
                    csv(r.getCreatedAt()),
                    csv(r.getUpdatedAt())
            ));
        }
        writer.flush();
    }

    // ====== CSV (multipart) ======
    @Override
    public void importFromCSV(MultipartFile file) {
        if (file == null || file.isEmpty()) return;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            importCsvBuffered(br);
        } catch (IOException e) {
            throw new RuntimeException("Import CSV(multipart) failed: " + e.getMessage(), e);
        }
    }

    // ====== Partial Update (Map) ======
    @Override
    public boolean partialUpdate(int id, Map<String, Object> updates) {
        RoomType room = dao.findById(id);
        if (room == null || updates == null || updates.isEmpty()) return false;

        if (has(updates, "name"))                room.setName(getStr(updates, "name"));
        if (has(updates, "description"))         room.setDescription(getStr(updates, "description"));
        if (hasAny(updates, "admin_note", "adminNote"))
            room.setAdminNote(getStrAny(updates, "admin_note", "adminNote"));

        if (has(updates, "price"))               room.setPrice(getInt(updates, "price"));
        if (has(updates, "capacity"))            room.setCapacity(getInt(updates, "capacity"));

        if (hasAny(updates, "is_available", "isAvailable"))
            room.setAvailable(getBoolAny(updates, "is_available", "isAvailable"));

        if (hasAny(updates, "image_path", "imagePath"))
            room.setImagePath(getStrAny(updates, "image_path", "imagePath"));

        return dao.update(room);
    }

    // ====== Partial Update (Form) ======
    @Override
    public boolean partialUpdate(int id, RoomTypeForm form) {
        RoomType room = dao.findById(id);
        if (room == null) return false;

        if (form.getName() != null)            room.setName(form.getName());
        if (form.getDescription() != null)     room.setDescription(form.getDescription());
        if (form.getPrice() != null)           room.setPrice(form.getPrice());
        if (form.getCapacity() != null)        room.setCapacity(form.getCapacity());
        if (form.getIsAvailable() != null)     room.setAvailable(form.getIsAvailable());
        if (form.getAdminNote() != null)       room.setAdminNote(form.getAdminNote());

        String imagePath = resolveImagePathFromForm(form);
        if (imagePath != null && !imagePath.isBlank()) {
            room.setImagePath(imagePath);
        }
        return dao.update(room);
    }

    // ====== Image helpers ======

    /** Controller 不動；這裡決定 imagePath 來源：優先檔案，其次字串路徑 */
    private String resolveImagePathFromForm(RoomTypeForm form) {
        MultipartFile file = form.getImage();
        if (file != null && !file.isEmpty()) {
            try { 
                return saveImage(file);       // 回傳 /images/{filename}
            } catch (IOException e) { 
                throw new RuntimeException("Save image failed: " + e.getMessage(), e); 
            }
        }
        if (form.getImagePath() != null && !form.getImagePath().isBlank()) {
            return form.getImagePath().trim(); // 支援外部或既有路徑
        }
        return null;
    }

    /** 以原檔名儲存到 uploads/images；對外路徑回傳 /images/{filename} */
    private String saveImage(MultipartFile file) throws IOException {
        // 確保目錄存在
        File dir = new File("uploads/images/roomImg").getAbsoluteFile();
        if (!dir.exists()) Files.createDirectories(dir.toPath());

        // 取原檔名（去除任何路徑）
        String original = Optional.ofNullable(file.getOriginalFilename()).orElse("upload");
        original = java.nio.file.Paths.get(original).getFileName().toString();

        // 拆副檔名
        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0 && dot < original.length() - 1) {
            ext = original.substring(dot).toLowerCase(); // .png
            original = original.substring(0, dot);       // 照片 (2)
        }

        // 淨化基本檔名：空白→_；只留中英數._-；非法字元→_
        String base = original
                .replaceAll("[\\s]+", "_")
                .replaceAll("[^0-9A-Za-z\\u4e00-\\u9fa5._-]", "_")
                .trim();
        if (base.isBlank()) base = "file";
        if (base.length() > 200) base = base.substring(0, 200);

        // 防同名覆蓋：同名加 -1, -2...
        String filename = base + ext;
        File dest = new File(dir, filename);
        int i = 1;
        while (dest.exists()) {
            filename = base + "-" + i + ext;
            dest = new File(dir, filename);
            i++;
        }

        // 寫檔
        file.transferTo(dest);

        // 回傳可被 /images/** 提供的 URL
        return "images/roomImg/" + filename;
    }

    // ====== CSV helpers ======
    private void importCsvBuffered(BufferedReader br) throws IOException {
        String header = br.readLine();
        if (header == null) return;

        String line;
        while ((line = br.readLine()) != null) {
            String[] cols = splitCsv(line);
            if (cols.length < 7) continue;

            RoomType r = new RoomType();
            int i = 0;
            r.setId(parseIntSafe(cols[i++]));           // id
            r.setName(ns(cols[i++]));                   // name
            r.setPrice(parseIntSafe(cols[i++]));        // price
            r.setCapacity(parseIntSafe(cols[i++]));     // capacity
            r.setDescription(ns(cols[i++]));            // description
            r.setImagePath(ns(cols[i++]));              // imagePath
            r.setAvailable(cols.length > i ? parseBoolSafe(cols[i++]) : true); // isAvailable
            r.setAdminNote(cols.length > i ? ns(cols[i++]) : null);            // adminNote

            if (r.getId() > 0) dao.update(r);
            else dao.insert(r);
        }
    }

    // tiny utils
    private static String csv(Object v) {
        String s = v == null ? "" : String.valueOf(v);
        if (s.contains(",") || s.contains("\"") || s.contains("\n") || s.contains("\r")) {
            s = s.replace("\"", "\"\"");
            return "\"" + s + "\"";
        }
        return s;
    }
    private static int parseIntSafe(String s) { try { return Integer.parseInt(s == null ? "0" : s.trim()); } catch (Exception e) { return 0; } }
    private static boolean parseBoolSafe(String s) {
        if (s == null) return false;
        String t = s.trim().toLowerCase();
        return "1".equals(t) || "true".equals(t) || "yes".equals(t);
    }
    private static String ns(String s) { return s == null ? "" : s; }

    private static boolean has(Map<String, Object> map, String key) { return map.containsKey(key) && map.get(key) != null; }
    private static boolean hasAny(Map<String, Object> map, String... keys) { for (String k : keys) if (has(map, k)) return true; return false; }
    private static String getStr(Map<String, Object> map, String key) { Object v = map.get(key); return v == null ? null : String.valueOf(v); }
    private static String getStrAny(Map<String, Object> map, String... keys) { for (String k : keys) if (has(map, k)) return getStr(map, k); return null; }
    private static int getInt(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v == null) return 0;
        if (v instanceof Number) return ((Number) v).intValue();
        String s = String.valueOf(v).trim();
        return s.isEmpty() ? 0 : Integer.parseInt(s);
    }
    private static boolean getBoolAny(Map<String, Object> map, String... keys) {
        for (String k : keys) if (has(map, k)) return getBool(map, k);
        return false;
    }
    private static boolean getBool(Map<String, Object> map, String key) {
        Object v = map.get(key);
        if (v == null) return false;
        if (v instanceof Boolean) return (Boolean) v;
        String s = String.valueOf(v).trim().toLowerCase();
        return "1".equals(s) || "true".equals(s) || "yes".equals(s);
    }

    // very light CSV splitter
    private static String[] splitCsv(String line) {
        List<String> out = new ArrayList<>();
        StringBuilder cur = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (ch == '"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') { cur.append('"'); i++; }
                else { inQuotes = !inQuotes; }
            } else if (ch == ',' && !inQuotes) { out.add(cur.toString()); cur.setLength(0); }
            else { cur.append(ch); }
        }
        out.add(cur.toString());
        return out.toArray(new String[0]);
    }

    // ====== Filtered Search ======
    @Override
    @Transactional(readOnly = true)
    public List<RoomType> searchFiltered(String keyword, Integer minPrice, Integer maxPrice, Integer capacity,
                                         List<Integer> featureIds, boolean matchAll,
                                         String sortBy, String order, int page, int size) {
        int offset = Math.max(page - 1, 0) * Math.max(size, 1);
        return dao.findFilteredPaged(keyword, minPrice, maxPrice, capacity,
                featureIds, matchAll, sortBy, order, offset, size);
    }

    @Override
    @Transactional(readOnly = true)
    public int countFiltered(String keyword, Integer minPrice, Integer maxPrice, Integer capacity,
                             List<Integer> featureIds, boolean matchAll) {
        return dao.countFiltered(keyword, minPrice, maxPrice, capacity, featureIds, matchAll);
    }

    // ====== Image APIs exposed to controller ======
    @Override
    public void updateImagePath(int id, String imagePath) {
        if (imagePath == null) return;
        RoomType room = dao.findById(id);
        if (room == null) return;
        room.setImagePath(imagePath);
        dao.update(room);
    }

    @Override
    public void updateImage(int id, MultipartFile img) {
        if (img == null || img.isEmpty()) return;
        try {
            String path = saveImage(img); // /images/{filename}
            updateImagePath(id, path);
        } catch (IOException e) {
            throw new RuntimeException("Save image failed: " + e.getMessage(), e);
        }
    }
}
