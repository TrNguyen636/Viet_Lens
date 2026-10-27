param (
    [string]$BaseUrl = "http://localhost:8080",
    [string]$AiUrl = "http://localhost:8000",
    [string]$JwtToken = ""
)

$ErrorActionPreference = "Continue"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     VIETLENS BACKEND AUTOMATED SMOKE TEST SUITE          " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Target Spring Boot URL : $BaseUrl"
Write-Host "Target PaiService URL  : $AiUrl"
Write-Host "----------------------------------------------------------"

$Passed = 0
$Failed = 0

function Test-Endpoint {
    param (
        [string]$Name,
        [string]$Method,
        [string]$Url,
        [hashtable]$Headers = @{},
        [string]$Body = "",
        [int[]]$ExpectedStatuses = @(200)
    )

    Write-Host -NoNewline "[TEST] $Name ($Method $Url) ... "
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            TimeoutSec = 15
            Headers = $Headers
        }
        if ($Body -and ($Method -eq "POST" -or $Method -eq "PUT")) {
            $params["Body"] = $Body
            $params["ContentType"] = "application/json; charset=utf-8"
        }

        $response = Invoke-WebRequest @params -UseBasicParsing
        $status = $response.StatusCode

        if ($ExpectedStatuses -contains $status) {
            Write-Host "PASSED (HTTP $status)" -ForegroundColor Green
            $script:Passed++
            return $response.Content
        } else {
            Write-Host "FAILED (Expected $($ExpectedStatuses -join ','), Got $status)" -ForegroundColor Red
            $script:Failed++
            return $null
        }
    } catch {
        $ex = $_.Exception
        if ($ex.Response) {
            $statusCode = [int]$ex.Response.StatusCode
            if ($ExpectedStatuses -contains $statusCode) {
                Write-Host "PASSED (HTTP $statusCode as expected)" -ForegroundColor Green
                $script:Passed++
                return $null
            } else {
                Write-Host "FAILED (Got HTTP $statusCode, Expected $($ExpectedStatuses -join ','))" -ForegroundColor Red
                $script:Failed++
                return $null
            }
        } else {
            Write-Host "FAILED (Connection error: $($ex.Message))" -ForegroundColor Red
            $script:Failed++
            return $null
        }
    }
}

# SECTION 1: PAISERVICE
Write-Host ""
Write-Host ">>> [SECTION 1] PAISERVICE (AI VISION) ENDPOINTS" -ForegroundColor Yellow
Test-Endpoint -Name "AI Health Check" -Method "GET" -Url "$AiUrl/api/v1/health" -ExpectedStatuses @(200)

# SECTION 2: JBE PUBLIC ENDPOINTS
Write-Host ""
Write-Host ">>> [SECTION 2] JBE PUBLIC HERITAGE ENDPOINTS (GUEST MODE)" -ForegroundColor Yellow
$allHeritages = Test-Endpoint -Name "Get All Heritages (paged)" -Method "GET" -Url "$BaseUrl/api/heritage/all?page=0&size=5" -ExpectedStatuses @(200)
Test-Endpoint -Name "Search Heritage by Keyword" -Method "GET" -Url "$BaseUrl/api/heritage/search?keyword=H%E1%BA%BF" -ExpectedStatuses @(200)
Test-Endpoint -Name "Filter by Category" -Method "GET" -Url "$BaseUrl/api/heritage/category/%C4%90%E1%BB%81n%20%C4%91%C3%A0i" -ExpectedStatuses @(200)
Test-Endpoint -Name "Get Nearby Heritages" -Method "GET" -Url "$BaseUrl/api/heritage/nearby?lat=16.0544&lng=108.2022&radius=50&limit=5" -ExpectedStatuses @(200)

$sampleId = "00000000-0000-0000-0000-000000000000"
if ($allHeritages) {
    try {
        $json = $allHeritages | ConvertFrom-Json
        if ($json -is [array] -and $json.Count -gt 0) {
            $sampleId = $json[0].id
        } elseif ($json.content -and $json.content.Count -gt 0) {
            $sampleId = $json.content[0].id
        }
    } catch {
        # ignore parse error
    }
}
Test-Endpoint -Name "Get Heritage Details by ID" -Method "GET" -Url "$BaseUrl/api/heritage/$sampleId" -ExpectedStatuses @(200, 404)
Test-Endpoint -Name "Get Heritage Reviews (Public)" -Method "GET" -Url "$BaseUrl/api/reviews/heritage/$sampleId" -ExpectedStatuses @(200)

# SECTION 3: AUTH GUARDS (401 UNAUTHORIZED)
Write-Host ""
Write-Host ">>> [SECTION 3] JBE SECURITY & 401 UNAUTHORIZED VERIFICATION" -ForegroundColor Yellow
Test-Endpoint -Name "Check Auth Guard on /api/users/profile (no token)" -Method "GET" -Url "$BaseUrl/api/users/profile" -ExpectedStatuses @(401)
Test-Endpoint -Name "Check Auth Guard on /api/interactions/bookmarks (no token)" -Method "GET" -Url "$BaseUrl/api/interactions/bookmarks" -ExpectedStatuses @(401)
Test-Endpoint -Name "Check Auth Guard on /api/interactions/bookmark/{id} (no token)" -Method "POST" -Url "$BaseUrl/api/interactions/bookmark/$sampleId" -ExpectedStatuses @(401)
Test-Endpoint -Name "Check Auth Guard on /api/reviews/{id} (no token)" -Method "POST" -Url "$BaseUrl/api/reviews/$sampleId" -Body "{`"rating`":5,`"comment`":`"Tuyet voi`"}" -ExpectedStatuses @(401)
Test-Endpoint -Name "Check Auth Guard on /api/ai/chat (no token)" -Method "POST" -Url "$BaseUrl/api/ai/chat" -Body "{`"heritageId`":`"$sampleId`",`"personaId`":`"GS_LAN`",`"message`":`"Xin chao`"}" -ExpectedStatuses @(401)

# SECTION 4: WITH JWT TOKEN
if ($JwtToken -ne "") {
    Write-Host ""
    Write-Host ">>> [SECTION 4] JBE AUTHENTICATED ENDPOINTS (WITH BEARER TOKEN)" -ForegroundColor Yellow
    $authHeaders = @{ "Authorization" = "Bearer $JwtToken" }
    Test-Endpoint -Name "Get User Profile" -Method "GET" -Url "$BaseUrl/api/users/profile" -Headers $authHeaders -ExpectedStatuses @(200)
    Test-Endpoint -Name "Get User Bookmarks" -Method "GET" -Url "$BaseUrl/api/interactions/bookmarks" -Headers $authHeaders -ExpectedStatuses @(200)
    Test-Endpoint -Name "Sync User Profile" -Method "POST" -Url "$BaseUrl/api/users/sync" -Headers $authHeaders -Body "{`"fullName`":`"Test User`"}" -ExpectedStatuses @(200)
} else {
    Write-Host ""
    Write-Host "[INFO] Khong co JwtToken duoc truyen vao. Bo qua Section 4." -ForegroundColor Gray
    Write-Host "       De test day du luong User co token: .\smoke_test.ps1 -JwtToken '<YOUR_SUPABASE_TOKEN>'" -ForegroundColor Gray
}

# SUMMARY
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "                 SMOKE TEST SUMMARY                       " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "PASSED ENDPOINTS : $Passed" -ForegroundColor Green
Write-Host "FAILED ENDPOINTS : $Failed" -ForegroundColor $(if ($Failed -gt 0) { "Red" } else { "Green" })
Write-Host "=========================================================="
