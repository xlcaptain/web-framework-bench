from fastapi import FastAPI, Path
from typing import Optional, List, Dict, Any, Union
from pydantic import BaseModel
import uvicorn
import os
import multiprocessing

app = FastAPI()


# 响应模型
class ApiResponse(BaseModel):
    code: int
    message: str
    result: Optional[Union[Dict[str, Any], List[Dict[str, Any]]]] = None


# 用户模型
class User(BaseModel):
    id: int
    name: str
    email: str


class CreateUserRequest(BaseModel):
    name: str
    email: str


# 健康检查端点
@app.get("/api/health")
async def health_check():
    return "OK"


# 获取用户列表
@app.get("/api/users", response_model=ApiResponse)
async def get_users():
    users = [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob", "email": "bob@example.com"},
    ]
    return ApiResponse(
        code=200,
        message="获取用户列表成功",
        result=users
    )


# 根据 ID 获取用户
@app.get("/api/users/{id}", response_model=ApiResponse)
async def get_user_by_id(id: int = Path(..., description="用户ID")):
    user = {
        "id": id,
        "name": f"User {id}",
        "email": f"user{id}@example.com"
    }
    return ApiResponse(
        code=200,
        message="获取用户成功",
        result=user
    )


# 创建用户
@app.post("/api/users", response_model=ApiResponse)
async def create_user(request: CreateUserRequest):
    user = {
        "id": 100,  # 实际应用中应该从数据库生成
        "name": request.name,
        "email": request.email
    }
    return ApiResponse(
        code=200,
        message="创建用户成功",
        result=user
    )


if __name__ == "__main__":
    # 获取worker数量，默认为CPU核心数
    worker_count = os.getenv("WORKER_THREADS")
    if worker_count:
        try:
            workers = int(worker_count)
            print(f"使用指定的 worker 数量: {workers}")
        except ValueError:
            workers = multiprocessing.cpu_count()
            print(f"WORKER_THREADS 格式错误，使用默认值: {workers} (CPU核心数)")
    else:
        workers = multiprocessing.cpu_count()
        print(f"未设置 WORKER_THREADS，使用默认值: {workers} (CPU核心数)")
    
    print(f"Server will start with {workers} workers")
    uvicorn.run(app, host="0.0.0.0", port=3000, workers=workers)

