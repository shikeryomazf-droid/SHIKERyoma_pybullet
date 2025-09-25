FROM ubuntu:22.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
ENV DISPLAY=host.docker.internal:0

# 基本パッケージのインストール
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-opengl \
    x11-apps \
    mesa-utils \
    libgl1-mesa-glx \
    libglu1-mesa \
    freeglut3-dev \
    && rm -rf /var/lib/apt/lists/*

# PyBulletと必要なパッケージのインストール
RUN pip3 install pybullet numpy matplotlib

# 作業ディレクトリの設定
WORKDIR /workspace

# サンプルスクリプトの作成（オプション）
RUN echo 'import pybullet as p\n\
import time\n\
\n\
# 物理エンジンの起動\n\
physicsClient = p.connect(p.GUI)\n\
p.setGravity(0, 0, -10)\n\
\n\
# 地面の追加\n\
planeId = p.loadURDF("plane.urdf")\n\
\n\
# 立方体の追加\n\
cubeStartPos = [0, 0, 1]\n\
cubeStartOrientation = p.getQuaternionFromEuler([0, 0, 0])\n\
boxId = p.loadURDF("r2d2.urdf", cubeStartPos, cubeStartOrientation)\n\
\n\
# シミュレーションの実行\n\
for i in range(1000):\n\
    p.stepSimulation()\n\
    time.sleep(1./240.)\n\
\n\
p.disconnect()' > /workspace/test_pybullet.py

CMD ["/bin/bash"]