# 读取脚本的运行参数。其中默认参数是路径，可选参数是删除开关 -remove 或 -r
param (
    [Parameter(Mandatory = $false)]
#    [string]$Path = $PSScriptRoot, # 设置默认值为当前脚本保存路径
    [string]$Path = (Get-Location).Path, # 设置默认值为运行当前脚本的工作路径
    [Alias('r')]        # 移除开关的别名
    [switch]$Remove,    # 移除开关
    [Alias('s')]        # 搜索开关的别名
    [switch]$Search,    # 搜索开关
    [Alias('a')]        # 添加开关的别名
    [switch]$Add,       # 添加开关
    [Alias('h')]        # 帮助开关的别名
    [switch]$Help       # 帮助开关
)

# Description: PowerShell脚本，用于输出不同颜色的用户名
function Write-UserName {
    if ($isAdmin) {
        $Color = [System.ConsoleColor]::Red
    }
    else {
        $Color = [System.ConsoleColor]::Yellow
    }
    Write-Host "【$targetName】" -NoNewline -ForegroundColor $Color
}

# Description: PowerShell脚本，用于输出不同颜色的消息
function Write-Message {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$Color = "White"
    )
    # 计算 $Message 和 $targetName 中汉字的数量
    $englishCharCount = (($Message + $targetName) -replace '[^\p{P}\p{Z}\p{S}\p{N}\p{Ll}\p{Lu}\p{Lt}]', '').Length
    $length = ($Message.Length + $targetName.Length - $englishCharCount) * 2 + $englishCharCount
    # 输出 * 的长度等于 $Message 的长度 + $targetName 的长度
    $stars = "*" * ($length + 6)
    Write-Host $stars
    Write-UserName
    Write-Host $Message -ForegroundColor $Color
    #Write-Host $length $Message.Length + $targetName.Length - $englishCharCount
    Write-Host $stars
    Write-Host " "
}

# Description: PowerShell脚本，用于将指定路径添加到系统的PATH环境变量中。
function Add-PathIfNotExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $existingPaths = $envPath -split ';'  # 将系统的PATH环境变量拆分为数组
    $pathExists = $existingPaths -contains $Path  # 检查要添加的路径是否已存在

    if (-not $pathExists) {
        # 如果路径不存在
        $newPath = $envPath + ';' + $Path  # 将要添加的路径拼接到现有的PATH环境变量中
        [Environment]::SetEnvironmentVariable('Path', $newPath, [EnvironmentVariableTarget]::Machine)  # 将新的PATH环境变量设置为机器级别
        # 输出成功添加路径的消息
        $message = "已将路径 '$Path' 添加到【" + $envLevel + "】的 PATH 环境变量。"
        Write-Message $message Green
    }
    else {
        # 输出路径已存在的消息
        $message = "注意：环境变量中已存在 '$Path'。"
        Write-Message $message Yellow
    }
}

# Description: PowerShell脚本，用于将指定路径从系统的PATH环境变量中移除。
function Remove-PathIfExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    $existingPaths = $envPath -split ';'  # 将系统的PATH环境变量拆分为数组
    $pathExists = $existingPaths -contains $Path  # 检查要移除的路径是否存在
    if ($pathExists) {
        # 如果路径存在
        $newPath = ($existingPaths | Where-Object { $_ -ne $Path }) -join ';'  # 从现有的PATH环境变量中移除要移除的路径
        [Environment]::SetEnvironmentVariable('Path', $newPath, [EnvironmentVariableTarget]::Machine)  # 将新的PATH环境变量设置为机器级别
        $changedPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
        if ($newPath -eq $changedPath) {
            $message = "已将路径 '$Path' 从【" + $envLevel + "】的 PATH 环境变量中移除。"
            Write-Message $message Green
        }
        else {
            $message = "未能将路径 '$Path' 从【" + $envLevel + "】的 PATH 环境变量中移除。"
            Write-Message $message Yellow
        }
    }
    else {
        # 输出路径不存在的消息
        $message = "注意：环境变量 Path 中不存在：'$Path'。"
        Write-Message $message Yellow
    }
}

# Description: PowerShell脚本，列出系统的 PATH 环境变量，如果与指定的 Path 参数相同的路径存在，输出该条目时用其他颜色标记
function Search-Path {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $existingPaths = $envPath -split ';'  # 将系统的 PATH 环境变量拆分为数组
    $existingPaths | ForEach-Object {
        if (-not (Test-Path $_)) {
            Write-Host " - 文件夹不存在：" -NoNewLine -ForegroundColor Yellow  # 输出不存在的路径时使用黄色
        }
        else {
            Write-Host " - 文件夹存在：" -NoNewLine -ForegroundColor Blue  # 输出存在的路径时使用蓝色
        }
        if ($_ -eq $Path) {
            Write-Host "'$_' - 环境变量 Path 中找到指定的设置项。" -ForegroundColor Green # 输出路径
        }
        else {
            Write-Host "'$_'"  # 输出路径
        }
    }
    $ifPathExists = $existingPaths -contains $Path  # 检查要搜索的路径是否存在
    if ($ifPathExists) {
        $message = "环境变量 Path 中存在：'$Path'。"
        Write-Message $message Green
    }
    else {
        $message = "环境变量 Path 中不存在：'$Path'。"
        Write-Message $message Yellow
    }
}

# Description: PowerShell脚本，用于清理系统的 PATH 环境变量，删除重复的路径
function Test-PathExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    $existingPaths = $envPath -split ';'  # 将系统的 PATH 环境变量拆分为数组
    # 检查要添加的路径是否已存在
    if ($existingPaths -contains $Path) {
        $message = "环境变量 Path 中存在：'$Path'。"
        Write-Message $message Green
    }
    else {
        $message = "环境变量 Path 中不存在：'$Path'。"
        Write-Message $message Yellow
    }
}

# 检查当前的 PowerShell 会话是否以管理员身份运行
function Set-EnvironmentTarget {
    param (
        [bool]$isAdmin
    )

    if ($isAdmin) {
        $target = [EnvironmentVariableTarget]::Machine
        $targetName = "系统管理员级别"
        Write-Host "【注意：当前以管理员身份运行，将修改机器级别的环境变量】" -ForegroundColor Red
    }
    else {
        $target = [EnvironmentVariableTarget]::User
        $targetName = "用户级别"
        Write-Host "【注意：当前是以用户身份运行，将修改用户级别的环境变量】" -ForegroundColor Yellow
        Write-Host "〖提示：你可以右键点击 PowerShell 脚本，然后选择 ""以管理员身份运行""〗" -ForegroundColor Yellow
    }
    Write-Host " "
    return $target, $targetName
}

# 如果运行参数中包含 -Help 或 -h，则输出帮助信息并退出
if($Help) {
    # 输出帮助信息
    Write-Host "帮助信息："
    Write-Host "本脚本用于快速查看/设置 [用户/系统] 的 Path 环境变量。"
    Write-Host "  [path]        指定路径，如果不指定则取当前工作路径；"
    Write-Host "  -Add 或 -a    添加路径到环境变量；"
    Write-Host "  -Remove 或 -r 从环境变量中删除中移除路径；"
    Write-Host "  -Search 或 -s 搜索环境变量中是否存在路径；"
    Write-Host "  -Help 或 -h   显示帮助信息；"
    Write-Host "注意：运行当前脚本的权限，决定操作用户级还是系统级的环境变量。"
    exit
}
# 主程序开始，全局设置开始
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$target, $targetName = Set-EnvironmentTarget -isAdmin $isAdmin
$envPath = [Environment]::GetEnvironmentVariable('Path', $target)
$envLevel = $isAdmin ? "系统" : "用户"
# 全局设置结束

# 如果运行参数提供的路径不是绝对路径，则转换为绝对路径
if ([System.IO.Path]::IsPathRooted($Path) -eq $false) {
    $Path = (Get-Item $Path).FullName
}
# 如果路径不存在，则输出错误信息并退出
if (-not (Test-Path $Path)) {
    #Write-Error "错误：路径 '$Path' 不存在。"
    #exit
}
switch ($true) {
    $Add {
        # 调用函数，添加路径
        Add-PathIfNotExists $Path
        exit
    }
    $Remove {
        # 调用函数，移除路径
        Remove-PathIfExists $Path
        exit
    }
    $Search {
        # 调用函数，搜索路径
        Search-Path $Path
        exit
    }
    default {
        # 调用函数，搜索路径
        Test-PathExists $Path
        exit
    }
}