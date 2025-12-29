# Julia安装简化说明

## ✅ 核心代码已简化

`01_setup_environment.R` 中的Julia初始化已经简化为：

```r
library(JuliaCall)
julia_setup()  # 自动检测Julia（无需JULIA_HOME）
```

## 安装要求

### Julia安装（仅需确保在PATH中）

1. **下载安装Julia:**
   - https://julialang.org/downloads/
   - 安装时**勾选"Add Julia to PATH"选项**

2. **验证安装:**
   ```bash
   # 打开命令行，运行
   julia --version
   ```
   
   应显示类似：`julia version 1.10.0`

3. **完成！** 无需设置JULIA_HOME环境变量

### 如果julia_setup()失败

**症状:** R运行时提示"Julia not found"

**解决方案:**

```bash
# 方法1: 检查PATH
julia --version

# 如果未找到，手动添加Julia到PATH:
# Windows:
# 1. 搜索"环境变量"
# 2. 编辑"Path"系统变量
# 3. 添加Julia的bin目录，例如:
#    C:\Users\你的用户名\AppData\Local\Programs\Julia-1.10.0\bin
# 4. 重启R/RStudio

# 方法2: 重新安装Julia，安装时务必勾选"Add to PATH"
```

## 启动流程（无需准备操作）

直接运行即可，所有依赖会自动安装：

```bash
cd "e:\IHEID Economics\IHEID\Topics in Econometrics\bayesianDEestimation"
Rscript main_analysis.R
```

脚本会自动：
- ✅ 检测Julia（通过PATH）
- ✅ 安装缺失的R包
- ✅ 安装Julia包
- ✅ 运行全部分析

**唯一需要手动设置的:**
```cmd
# FRED API密钥（仅需设置一次）
setx FRED_API_KEY "你的密钥"
```

## 多线程配置（可选）

Julia默认会自动使用合理的线程数。如果你希望手动控制：

```bash
# 方法1: 启动Julia时指定（推荐）
# 将JULIA_NUM_THREADS环境变量设置为你的CPU核心数
setx JULIA_NUM_THREADS "14"

# 方法2: 重启R后Julia会自动使用该设置
```

但这**完全是可选的**，默认配置已经足够高效。
