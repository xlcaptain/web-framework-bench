FROM complaint_12315:v2.0

# 设置工作目录
WORKDIR /workspace

# 复制依赖文件
COPY requirements.txt .

# 使用 uv 安装依赖到系统Python环境
# --system 参数表示安装到系统Python，而不是虚拟环境
RUN uv pip install --system --no-cache -r requirements.txt

# 验证 uvicorn 是否安装成功
RUN uv pip list | grep uvicorn || echo "uvicorn not found, will fail at runtime"

# 复制应用代码
COPY main.py .

# 暴露端口
EXPOSE 3000