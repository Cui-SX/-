# 远程部署辅助脚本
# 使用方法: .\deploy_to_remote.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== E-Commerce 远程部署工具 ===" -ForegroundColor Cyan

# 1. 获取服务器信息
$ServerIP = Read-Host "请输入服务器IP地址"
$Username = Read-Host "请输入服务器用户名 (默认: root)"
if ([string]::IsNullOrWhiteSpace($Username)) { $Username = "root" }

# 2. 检查文件
$WarFile = "target\e-commerce.war"
if (-not (Test-Path $WarFile)) {
    Write-Error "找不到 WAR 文件: $WarFile。请先运行 'mvn clean package'。"
    exit 1
}

# 3. 上传文件
Write-Host "`n[1/3] 正在上传文件到服务器..." -ForegroundColor Yellow
$RemoteDir = "/tmp/ecommerce_deploy"

# 创建远程目录
ssh $Username@$ServerIP "mkdir -p $RemoteDir"

# 上传 WAR 包
Write-Host "上传 WAR 包..."
scp $WarFile "$Username@$ServerIP`:$RemoteDir/e-commerce.war"

# 上传部署脚本
Write-Host "上传部署脚本..."
scp deploy.sh "$Username@$ServerIP`:$RemoteDir/deploy.sh"

# 上传数据库脚本
Write-Host "上传数据库脚本..."
scp -r database "$Username@$ServerIP`:$RemoteDir/"

# 4. 执行部署
Write-Host "`n[2/3] 正在服务器上执行部署脚本..." -ForegroundColor Yellow
Write-Host "提示: 您可能需要输入 sudo 密码。" -ForegroundColor Gray

ssh -t $Username@$ServerIP "cd $RemoteDir && chmod +x deploy.sh && sudo ./deploy.sh"

Write-Host "`n[3/3] 部署完成！" -ForegroundColor Green
Write-Host "请访问: http://$ServerIP:8080/e-commerce" -ForegroundColor Cyan
