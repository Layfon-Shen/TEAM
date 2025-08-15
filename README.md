# 銀髮照護電商平台 (SeniorsCare)

這是一個專為銀髮族設計的電子商務平台，提供輔具用品的線上銷售與管理。

## 專案架構

本專案採用前後端分離架構。

### 後端 (`/backend`)

後端服務使用 Java Spring Boot 框架搭建，負責處理所有業務邏輯、資料庫互動及 API 提供。

- **框架**: Spring Boot 3
- **語言**: Java 17
- **建構與依賴管理**: Maven
- **資料庫**: Microsoft SQL Server
- **核心架構**:
    - **Controller**: 定義 RESTful API 接口，作為前後端溝通的橋樑。
    - **Service**: 實現核心業務邏輯。
    - **DAO (Data Access Object)**: 透過 Spring JDBC (`NamedParameterJdbcTemplate`) 執行資料庫的增刪改查操作。
    - **DTO (Data Transfer Object)**: 用於在不同層之間傳輸資料，特別是在 API 的請求和回應中。
    - **Model**: 代表資料庫中的資料實體。
    - **RowMapper**: 將 JDBC 的查詢結果 `ResultSet` 映射為 Java 物件。

#### 主要功能模組

1.  **商品核心 (`/device`)**:
    -   `DeviceController`: 商品管理 (CRUD, 排序, 分頁, CSV 匯入/匯出)。
    -   `DeviceCategoryController`: 商品分類管理。
    -   `CartController`: 購物車功能 (新增、修改、刪除、查看)。
    -   `OrderController`: 前台使用者訂單操作 (建立、查詢)。
    -   `AdminOrderController`: 後台管理員訂單操作 (查詢、更新狀態)。
    -   `AddressController`: 使用者收件地址管理。

2.  **會員/員工 (`/member`)**:
    -   `EmployeeController`: 後台員工資料管理 (CRUD, 權限、狀態管理)。

### 前端 (`/frontend`)

前端部分目前仍在開發中。

## 如何啟動後端服務

1.  **設定資料庫**:
    -   確保 Microsoft SQL Server 正在運行。
    -   在 `backend/src/main/resources/application.properties` 文件中，根據您的環境修改資料庫連線設定 (URL, username, password)。
    -   執行 `/sql` 目錄中的 SQL 腳本以建立所需的資料表。

2.  **啟動應用程式**:
    -   使用 IDE (如 IntelliJ IDEA 或 Eclipse) 直接運行 `SeniorsCareApplication.java`。
    -   或透過 Maven 指令：
        ```bash
        cd backend
        mvn spring-boot:run
        ```

3.  **API 接口**:
    -   服務啟動後，您可以透過 `http://localhost:8080` 訪問 API 接口 (預設埠號為 8080)。
