1. Trigger:
   - Pipeline tự động chạy khi có push lên branch "main"

2. Môi trường:
   - Sử dụng Flutter bản stable mới nhất
   - Sử dụng máy Linux mặc định của Codemagic

3. Build:
   - Chạy flutter pub get
   - Build ứng dụng Android dạng release
   - Ưu tiên dùng: flutter build appbundle
   - Có thể fallback sang apk nếu cần

4. Artifacts:
   - Export file .aab hoặc .apk sau khi build

5. Deployment (ưu tiên cho demo):
   - Deploy lên Firebase App Distribution
   - Sử dụng Firebase CLI token
   - Sử dụng Firebase App ID
   - Các thông tin này phải được cấu hình qua environment variables

6. Secrets:
   - Tuyệt đối không hardcode credentials
   - Sử dụng environment variables của Codemagic để lưu:
     - Firebase token
     - Firebase App ID
     - (nếu cần) keystore

7. Output:
   - Generate đầy đủ file codemagic.yaml
   - Có comment giải thích từng step
   - Đơn giản, dễ hiểu, phù hợp cho demo

8. Bonus (nếu có thể):
   - Thêm cache cho Flutter dependencies
   - Có log rõ ràng cho từng bước build/deploy

Đảm bảo file YAML hợp lệ và có thể dùng ngay.