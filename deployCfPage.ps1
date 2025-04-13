# D E P L O Y C F P A G E . P S 1
# Author: NT-AUTHORITY
# Date: 2025-04-13
# Description: 重试 Cloudflare Pages 部署的 PowerShell 脚本
# Version: 1.0.0

param (
    [string]$apiKey,
    [string]$siteName,
    [string]$accountID,
    [switch]$debug = $false
)

# 检查参数是否提供
if (-not $debug) {
    if (-not $apiKey) {
        Write-Error "请提供 Cloudflare API 密钥。"
        exit 1
    }
    if (-not $accountID) {
        Write-Error "请提供 Cloudflare 账户 ID。"
        exit 1
    }
    if (-not $siteName) {
        Write-Error "请提供要部署的站点名称。"
        exit 1
    }
}

# 获取所有部署
function GetAllDeployments {
    param (
        [string]$apiKey,
        [string]$siteName,
        [string]$accountID
    )

    $deploymentsURL = "https://api.cloudflare.com/client/v4/accounts/$accountID/pages/projects/$siteName/deployments"
    $deploymentsResponse = Invoke-WebRequest -Uri $deploymentsURL -Headers @{
        "Authorization" = "Bearer $apiKey"
    } -Method Get

    if ($deploymentsResponse.StatusCode -eq 200) {
        Write-Host "获取所有部署成功。"
        return $deploymentsResponse.Content
    } else {
        Write-Error "获取所有部署失败，状态码：$($deploymentsResponse.StatusCode)"
        Write-Error "响应内容：$($deploymentsResponse.Content)"
        Write-Error "URL：$deploymentsURL"
        Write-Error "请求头：$($deploymentsResponse.Headers)"
        exit 1
    }
}

# 获取最新部署 ID
function GetLatestDeploymentID {
    param (
        [string]$content
    )

    # 将 JSON 内容解析为 PowerShell 对象
    $jsonData = $content | ConvertFrom-Json

    # 检查 JSON 数据结构是否包含结果数组
    if ($jsonData.result) {
        # 找到最新的部署记录，即 `created_on` 时间最大的记录
        $latestDeployment = $jsonData.result | Sort-Object -Property created_on -Descending | Select-Object -First 1

        # 返回最新部署记录的 `short_id`
        return $latestDeployment.short_id
    } else {
        Write-Error "内容中没有找到部署记录。"
        return $null
    }
}

# 重试部署
function RetryDeployment {
    param (
        [string]$apiKey,
        [string]$siteName,
        [string]$accountID,
        [string]$latestID
    )

    $retryURL = "https://api.cloudflare.com/client/v4/accounts/$accountID/pages/projects/$siteName/deployments/$latestID/retry"
    $retryResponse = Invoke-WebRequest -Uri $retryURL -Headers @{
        "Authorization" = "Bearer $apiKey"
    } -Body "{}" -Method Post

    if ($retryResponse.StatusCode -eq 200) {
        Write-Host "重试部署成功。"
    } else {
        Write-Error "重试部署失败，状态码：$($retryResponse.StatusCode)"
        Write-Error "响应内容：$($retryResponse.Content)"
        Write-Error "URL：$retryURL"
        Write-Error "请求头：$($retryResponse.Headers)"
        exit 1
    }
}

# 主逻辑
$allDeployments = GetAllDeployments -apiKey $apiKey -siteName $siteName -accountID $accountID
$latestID = GetLatestDeploymentID -content $allDeployments

if ($latestID) {
    Write-Host "最新部署 ID：$latestID"
    RetryDeployment -apiKey $apiKey -siteName $siteName -accountID $accountID -latestID $latestID
} else {
    Write-Error "获取最新部署 ID 失败。"
    exit 1
}