FROM python:3.10-slim

# Install dependencies untuk OpenCV, Pillow, dsb.
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install pip packages
# 1. Install torch/torchvision/torchaudio dari PyTorch CPU repo
# 2. Install sisa dependencies
RUN pip install --upgrade pip \
 && pip install torch==2.1.0+cpu torchvision==0.16.0+cpu torchaudio==2.1.0+cpu \
     -f https://download.pytorch.org/whl/cpu/torch_stable.html \
 && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY models/ ./models/

COPY . .

# Expose port
EXPOSE 5000

# Gunicorn command, pastikan backend.py memiliki variabel Flask bernama 'app'
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "backend:app"]
