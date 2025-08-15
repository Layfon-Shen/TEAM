package com.ryanshiun.seniorscare.caregiver.service.caregiver;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService {

//    @Value("${file.upload.base-path}")
    private String baseUploadPath= "SeniorsCare\\backend\\uploads\\images";

    @Override
    public String uploadFile(MultipartFile file, String directory) throws IOException {
        Path uploadPath = Paths.get(baseUploadPath, directory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String newFilename = UUID.randomUUID().toString() + extension;

        Path filePath = uploadPath.resolve(newFilename);
        Files.copy(file.getInputStream(), filePath);

        // 只回傳相對於 baseUploadPath 的路徑
        return directory + "\\" + newFilename;
    }

    @Override
    public boolean deleteFile(String filePath) {
        try {
            Path fullPath = Paths.get(baseUploadPath, filePath);
            return Files.deleteIfExists(fullPath);
        } catch (IOException e) {
            return false;
        }
    }
}