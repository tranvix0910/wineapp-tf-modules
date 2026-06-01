# Kiến trúc Doanh nghiệp & Hạ tầng WineApp

Hệ thống thương mại điện tử rượu vang cao cấp được thiết kế theo kiến trúc đa tầng (Multi-tier Architecture), tích hợp sẵn toàn bộ mã nguồn ứng dụng (Frontend, Backend), hạ tầng dưới dạng mã (Infrastructure as Code - IaC) sử dụng Terraform, và quy trình tự động hóa tích hợp/triển khai liên tục (CI/CD) theo mô hình GitOps trên AWS.

---

## 1. Tổng Quan Dự Án

Dự án WineApp là một giải pháp thương mại điện tử toàn diện và sẵn sàng cho môi trường Production. Dự án gồm ba khối thành phần chính luôn kết hợp chặt chẽ với nhau:

* **Ứng dụng (Application Source):** Gồm ứng dụng React Frontend và RESTful API Backend Node.js.
* **Hạ tầng (Infrastructure as Code):** Bộ các module Terraform tự định nghĩa để khởi tạo toàn bộ tài nguyên trên AWS bao gồm Mạng (VPC), An ninh (Security Groups, IAM), Container (ECS Fargate), Load Balancer (ALB), và Cơ sở dữ liệu (Amazon DocumentDB).
* **Quy trình tự động hóa (CI/CD & GitOps):** Đường ống dẫn AWS CodeBuild tự động đóng gói Docker Image, đẩy lên AWS ECR, và tự động cập nhật phiên bản thông qua việc thay đổi cấu hình Helm Chart trên GitOps Config Repository.

---

## 2. Kiến Trúc Hạ Tầng Hệ Thống (AWS Infrastructure)

Hạ tầng của WineApp được triển khai hoàn toàn trên AWS vùng ap-southeast-1 (Singapore) và tuân thủ nghiêm ngặt các tiêu chuẩn về an toàn thông tin, có độ an toàn cao và chia thành các phân lớp rõ ràng:

### Mạng và Phân Vùng An Ninh (Networking & Security Zones)
* **AWS VPC (Virtual Private Cloud):** Sử dụng dải mạng CIDR 10.0.0.0/16.
* **Phân chia Subnet:**
  * **Public Subnets (2 subnet tại 2 Availability Zones khác nhau):** Dải mạng 10.0.1.0/24 và 10.0.2.0/24. Đây là nơi đặt Application Load Balancer (ALB) và Bastion Host nhằm tiếp nhận lưu lượng từ internet và cho phép quản trị viên truy cập.
  * **Private Subnets (2 subnet tại 2 Availability Zones khác nhau):** Dải mạng 10.0.101.0/24 và 10.0.102.0/24. Đây là vùng an toàn dùng để chạy các container ecs-fargate (Frontend, Backend) và cơ sở dữ liệu DocumentDB. Luồng truy cập từ internet vào các private subnet đều phải thông qua Load Balancer hoặc NAT Gateway.
* **An ninh mạng (Security Groups):** Các lớp bảo vệ độc lập bao gồm Public SG (cho Load Balancer), Private SG (cho các ECS Tasks), Bastion SG (cho cổng IP riêng biệt để SSH), và Database SG (chỉ cho phép kết nối từ Private SG).

### Lớp Tính Toán (Compute Tier - AWS ECS Fargate)
* **ECS Cluster:** Điều phối và quản lý tất cả các phần ứng dụng dạng container.
* **Dịch vụ Frontend (Fargate Task):** Chạy container Nginx phục vụ mã nguồn React tĩnh ở port 80. Biến môi trường `REACT_APP_API_URL` được tự động truyền vào và lấy giá trị từ địa chỉ DNS của Load Balancer phía Backend để kết nối API.
* **Dịch vụ Backend (Fargate Task):** Chạy API Node.js/Express ở port 4000. Dịch vụ backend lấy biến môi trường `MONGO_CONNECTION` một cách an toàn từ AWS Secrets Manager thông qua cơ chế tham chiếu trực tiếp trong Task Definition.

### Lớp Dữ Liệu (Database Tier - Amazon DocumentDB)
* **Amazon DocumentDB:** Cơ sở dữ liệu dạng tài liệu tương thích hoàn toàn với MongoDB 5.0, có tính năng replica và auto-scaling phù hợp cho ứng dụng Node.js sử dụng thư viện Mongoose.
* **Môi trường chạy:** Được triển khai trong Private Subnet Group và chỉ chấp nhận kết nối đến từ các ECS task thông qua port 27017.
* **Mật khẩu và Chuỗi kết nối (Secrets Manager):** Mật khẩu hệ thống được khởi tạo ngẫu nhiên bằng Terraform (`random_password`) và được lưu trữ an toàn vào AWS Secrets Manager. Chuỗi kết nối đầy đủ có dạng `mongodb://rootuser:<password>@<docdb_endpoint>:27017/wine-website` cũng được tạo tự động và lưu vào Secrets Manager để Backend tái sử dụng.

### Lớp Cân Bằng Tải và Định Tuyến (Load Balancing)
* **Application Load Balancer (ALB):** Nhận lưu lượng truy cập HTTP vào Port 80 (cho Frontend) và Port 4000 (cho Backend API), thực hiện kiểm tra sức khỏe (Health Checks) và chuyển tiếp an toàn tới các Target Group tương ứng.
* **Cơ chế Blue-Green Deployment:** Hệ thống có sẵn các Target Group cho chế độ Blue/Green thông qua AWS CodeDeploy giúp nâng cấp hệ thống mà không gây gián đoạn dịch vụ (Zero-Downtime Deployment).

### Quản Trị Viên và Giám Sát (Management & Monitoring)
* **Bastion Host:** Một máy ảo EC2 (t2.micro) chạy trong Public Subnet, cho phép quản trị viên đăng nhập bằng khóa SSH public để cấu hình, kiểm tra an toàn hoặc thực hiện các truy vấn database phía trong private subnet.
* **Amazon CloudWatch:** Lưu trữ tập trung toàn bộ log hệ thống từ các container Frontend và Backend với thời gian lưu trữ lưu vết là 7 ngày để giúp theo dõi và khắc phục sự cố khi cần thiết.

---

## 3. Cấu Trúc Thư Mục Dự Án

Thư mục gốc của dự án chứa toàn bộ thành phần của hệ sinh thái:

```
.
├── environments/               # Cấu hình môi trường triển khai cụ thể
│   └── wine-website/           # Môi trường chạy ứng dụng website chính
│       ├── main.tf             # File khởi tạo và kết nối các module
│       ├── variable.tf         # Khai báo biến đầu vào cho môi trường
│       └── output.tf           # Khai báo dữ liệu đầu ra (ALB DNS, DB Endpoint)
├── tf-modules/                 # Các module Terraform tái sử dụng
│   ├── bastion/                # Cấu hình EC2 Bastion Host & Public SSH Key
│   ├── code_deploy/            # Cấu hình CodeDeploy cho chế độ Blue/Green
│   ├── database/               # Khởi tạo DocumentDB Cluster & AWS Secrets Manager
│   ├── ecs_cluster/            # Khởi tạo ECS Cluster, Services, Task Definitions, CloudWatch
│   ├── iam/                    # Khai báo các quyền truy cập (IAM Roles & Policies)
│   ├── load_balancer/          # Khởi tạo ALB, target groups và listeners
│   ├── networking/             # Khởi tạo VPC, Private/Public Subnets, Route Tables
│   └── security/               # Khởi tạo các nhóm bảo mật (Security Groups)
├── wineapp-backend/            # Mã nguồn Express API Server
│   ├── src/                    # Thư mục logic chính (routes, services, app, utils)
│   ├── Dockerfile              # Đóng gói Docker cho Backend
│   ├── buildspec.yml           # Tập lệnh AWS CodeBuild dùng cho Backend
│   └── package.json            # Thông tin thư viện phụ thuộc của Node.js
└── wineapp-frontend/           # Mã nguồn React client
    ├── src/                    # Thư mục chứa các Page, Component và Redux store
    ├── Dockerfile              # Đóng gói Docker phục vụ static files bằng Nginx
    ├── buildspec.yml           # Tập lệnh AWS CodeBuild dùng cho Frontend
    └── package.json            # Thông tin thư viện phụ thuộc của React
```

---

## 4. Chi Tiết Các Thành Phần Ứng Dụng

### Frontend (wineapp-frontend)
Là một ứng dụng Single-Page Application (SPA) hiện đại, phần ứng dụng người dùng được xây dựng hoàn toàn bằng React 18, sở hữu giao diện trực quan và trải nghiệm mượt mà:
* **Công nghệ sử dụng:**
  * **React Router DOM v6:** Điều hướng không cần load lại trang.
  * **Redux Toolkit & Redux Persist:** Quản lý trạng thái toàn cục như giỏ hàng, danh sách yêu thích, thông tin phiên đăng nhập.
  * **Sass (SCSS):** Quản lý bộ CSS chuyên nghiệp và dễ dàng mở rộng.
  * **GSAP & Swiper:** Tạo ra các hiệu ứng chuyển động, hiệu ứng hình ảnh và các vùng slide hiển thị sản phẩm mượt mà.
* **Các tính năng chính trên giao diện:**
  * **Home Page:** Trang chủ hiển thị các bộ sưu tập nổi bật và danh sách vang đặc trưng.
  * **Shop:** Bộ lọc tìm kiếm nâng cao (theo khoảng giá, loại vang, thương hiệu), sắp xếp và phân trang.
  * **WineDetail:** Trang chi tiết thông tin sản phẩm và đánh giá từ khách hàng.
  * **Cart & Wishlist:** Trải nghiệm mua sắm với các chức năng thêm nhanh, cập nhật số lượng, yêu thích sản phẩm.
  * **Blog:** Chia sẻ các bài viết về kiến thức ẩm thực và rượu vang.
  * **MyAccount & Auth:** Đăng ký, đăng nhập bảo mật, đổi mật khẩu và thay đổi thông tin cá nhân.
  * **OTP & Recovery Email:** Khôi phục mật khẩu an toàn qua mã xác thực email một lần.

### Backend (wineapp-backend)
API server chạy trên nền tảng Node.js (phiên bản ES Modules hiện đại với import/export) cung cấp các dịch vụ an toàn, ổn định và nhanh chóng:
* **Công nghệ sử dụng:**
  * **Express:** Framework cho RESTful API gọn nhẹ.
  * **Mongoose:** Kết nối vào cơ sở dữ liệu DocumentDB một cách đơn giản và khai báo các Schema nghiệp vụ rõ ràng.
  * **JWT (JSON Web Token):** Chức năng xác thực và phân quyền người dùng bằng cơ chế Access Token và Refresh Token (trao đổi thông qua HttpOnly Cookie).
  * **BcryptJS:** Mã hóa mật khẩu người dùng an toàn trước khi ghi vào cơ sở dữ liệu.
  * **Nodemailer:** Gửi mail xác thực OTP, thông tin đặt hàng hoặc phục hồi tài khoản.
* **Các phân lớp Router API chính (`/api/v1/`):**
  * `/auth` - Đăng ký, đăng nhập, làm mới phiên làm việc.
  * `/user` - Thông tin profile người dùng.
  * `/address` - Thông tin địa chỉ giao nhận.
  * `/wines` - Quản lý sản phẩm rượu vang.
  * `/cart` - Quản lý giỏ hàng riêng biệt của từng khách hàng.
  * `/favorite` - Danh sách sản phẩm người dùng yêu thích.
  * `/reviews` - Viết và đọc đánh giá của từng sản phẩm.
  * `/blog` - Quản lý tin tức blog.
  * `/otp` - Kiểm tra và gửi OTP khôi phục mật khẩu.
  * `/contact` - Nhận và lưu thông tin liên hệ từ khách hàng.

---

## 5. Quy Trình CI/CD và GitOps Tự Động Hóa

Quy trình phát triển (Pipeline) của WineApp áp dụng các tiêu chuẩn DevOps tiên tiến với sự hỗ trợ của AWS CodeBuild và phương pháp GitOps:

```
[Developer] -> Push code den Git -> [AWS CodeBuild]
                                           │
         ┌─────────────────────────────────┴─────────────────────────────────┐
         ▼                                                                   ▼
[Build Docker Image]                                                 [Chay kiem tra]
         │                                                                   │
         ▼                                                                   ▼
[Push Image len AWS ECR]                                            [Gia dinh thanh cong]
         │
         ▼
[Clone GitOps Config Repo] -> [Cap nhat phien ban Tag moi trong values-prod.yaml] -> [Git Commit & Push]
```

### Chi tiết các bước trong Buildspec:
1. **Pha cài đặt (Install Phase):** Khởi tạo môi trường Node.js mới nhất, tải toàn bộ thư viện devDependencies trong package.json, và cài đặt các công cụ cần thiết (Git, Curl, Docker cli).
2. **Pha chuẩn bị (Pre-build Phase):**
   * Tự động phát hiện phiên bản bằng cách tìm kiếm Git Tag gần nhất (nếu không có sẽ sử dụng mã hash commit ngắn). Tag phiên bản này sẽ làm tag cho Docker Image (ví dụ: `v1.0.0` hoặc `a1b2c3d`).
   * Đăng nhập vào AWS ECR bằng quyền lợi từ CodeBuild Service Role.
3. **Pha xây dựng (Build Phase):**
   * Biên dịch ứng dụng và đóng gói thành một Docker Image hoàn chỉnh đạt chuẩn thiết kế an toàn.
   * Thực hiện kiểm tra sức khỏe của container ngay trong trình build bằng cách khởi chạy thử container, dùng `curl` check endpoint để kiểm chứng container chạy hoàn toàn khỏe mạnh trước khi đưa lên AWS.
4. **Pha sau xây dựng (Post-build Phase):**
   * Đẩy (Push) Docker Image lên kho chứa AWS ECR.
   * Sử dụng Token cá nhân (được tải từ AWS Secrets Manager) để clone kho chứa cấu hình GitOps riêng biệt (`wineapp-frontend-config` hoặc `wineapp-backend-config`).
   * Cập nhật giá trị phiên bản image (`tag`) tự động vào file cấu hình Helm Chart (`helm-values/values-prod.yaml`).
   * Tự động commit và push sự thay đổi ngược lại kho chứa cấu hình. Thao tác này kích hoạt bộ công cụ tự động hóa GitOps triển khai phiên bản mới lên hệ thống thực tế.

---

## 6. Hướng Dẫn Triển Khai & Phục Vụ Development

### Kích Hoạt Môi Trường Development Tại Local

#### 1. Yêu cầu hệ thống tại local:
* Đã cài đặt Node.js (phiên bản 18 trở lên) và npm.
* Có sẵn cơ sở dữ liệu MongoDB chạy tại local hoặc MongoDB Atlas cluster.

#### 2. Khởi động API Backend:
1. Truy cập vào thư mục backend:
   ```bash
   cd wineapp-backend
   ```
2. Tạo file cấu hình môi trường `.env` tại thư mục gốc của backend với các nội dung sau:
   ```env
   PORT=4000
   MONGO_CONNECTION=mongodb://localhost:27017/wine-website
   JWT_ACCESSTOKEN_KEY=secret_access_key_local
   JWT_REFRESHTOKEN_KEY=secret_refresh_key_local
   EMAIL_NAME=your_email@gmail.com
   EMAIL_PASSWORD=your_email_app_password
   NODE_ENV=development
   ```
3. Cài đặt các thư viện và chạy server ở chế độ develop (sử dụng nodemon để tự động reload khi thay đổi file):
   ```bash
   npm install
   npm start
   ```

#### 3. Khởi động Ứng dụng Frontend:
1. Chuyển hướng sang thư mục frontend:
   ```bash
   cd ../wineapp-frontend
   ```
2. Cài đặt các thư viện phụ thuộc:
   ```bash
   npm install
   ```
3. Khởi động ứng dụng React:
   ```bash
   npm start
   ```
   Ứng dụng sẽ tự động chạy tại địa chỉ `http://localhost:3000`. Các thông tin nghiệp vụ sẽ kết nối trực tiếp vào API local đang chạy ở port 4000.

---

### Triển khai Hạ tầng bằng Terraform (AWS Deployment)

#### 1. Yêu cầu chuẩn bị trên AWS và máy cá nhân:
* Cài đặt công cụ CLI Terraform (phiên bản 1.0 trở lên).
* Cấu hình thông tin xác thực AWS (AWS Credentials) có đầy đủ quyền tạo các tài nguyên kể trên trên máy cá nhân.
* Đặt một cặp khóa SSH Key (SSH keypair) vào đường dẫn `../../Key/terraform.pub` để Bastion Host có thể đọc và cho phép truy cập.

#### 2. Các bước triển khai:
1. Chuyển vào thư mục môi trường cần triển khai:
   ```bash
   cd environments/wine-website
   ```
2. Khởi tạo Terraform để tải các Provider và Module:
   ```bash
   terraform init
   ```
3. Xem trước kế hoạch tạo tài nguyên để kiểm tra tính chính xác của hạ tầng:
   ```bash
   terraform plan
   ```
4. Áp dụng và bắt đầu tạo dựng hạ tầng trên hệ thống AWS:
   ```bash
   terraform apply
   ```
   Xác nhận `yes` khi được hỏi để đồng ý tạo tài nguyên. Sau khi hoàn thành, Terraform sẽ in ra thông tin địa chỉ DNS của Load Balancer và thông tin endpoints để truy cập.

---

## 7. Các Tiêu Chuẩn Thiết Kế và Bảo Mật Đạt Được

* **Bảo mật dữ liệu tĩnh (Data at Rest):** Database DocumentDB nằm hoàn toàn trong phân private subnet khép kín. Mật khẩu không hề ghi trực tiếp mà được mã hóa và lưu an toàn trên AWS Secrets Manager.
* **Cơ chế Zero-Downtime:** Sẵn sàng cho việc triển khai CodeDeploy Blue/Green để cập nhật phiên bản Frontend/Backend giúp hệ thống chạy ổn định 24/7 không hề bị downtime khi nâng cấp mã nguồn.
* **Khả năng bất lợi và tự phục hồi (Resiliency):** Nhờ có sự trợ giúp từ đặt AWS Application Load Balancer đi trước, lưu lượng được chia đều sang các task ECS chạy phân tán. Nếu một task bị crash, ECS Service sẽ tự động phát hiện ra và khởi động lại một task khác thay thế ngay lập tức.
* **Giám sát chặt chẽ (Logging & Auditing):** CloudWatch log ghi nhận toàn bộ các truy vấn từ người dùng, lỗi logic, và hiệu năng phục vụ công tác xử lý sự cố nhanh chóng.
